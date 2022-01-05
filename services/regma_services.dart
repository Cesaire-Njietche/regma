import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:regma/models/course_model.dart';

import '../helpers/util.dart';
import '../models/answer_model.dart';
import '../models/conversation.dart';
import '../models/friend_request.dart';
import '../models/friendship.dart';
import '../models/lesson_model.dart';
import '../models/media.dart';
import '../models/paid_media_item.dart';
import '../models/question_model.dart';
import '../models/subscription.dart';
import '../models/user.dart';
import '../services/file.dart';
import 'regma_interfaces.dart';

class RegmaServices extends RegmaInterfaces {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  MFile file = MFile();
  String get uid => auth.currentUser.uid;

  @override
  deleteEntity(String fsCollection, idField, dynamic idValue,
      {Function then()}) async {
    var result = await db
        .collection(fsCollection)
        .where(idField, isEqualTo: idValue)
        .get();

    result.docs.forEach((element) async {
      await element.reference.delete();
    });
  }

  /// get all query document snapshots from a given firebase collection
  Future<List<QueryDocumentSnapshot>> getAllDocsListOf(
      String fsCollection) async {
    var result = await db
        .collection(fsCollection)
        .get(GetOptions(source: Source.server));
    // print('${result.docs.length}' + '--------------');
    return result.docs;
  }

  /// User
  Future<void> saveUser(Map<String, dynamic> user, bool isAdding,
      [File picture]) async {
    //var uid = uid;
    var names = <String>[];
    names.addAll(user['name'].toString().trim().toLowerCase().split(' '));
    names.addAll(user['surname'].toString().trim().toLowerCase().split(' '));

    var searchArray = <String>[];
    searchArray.addAll(names);
    for (var name in names) {
      for (int i = 1; i < name.length; i++) {
        searchArray.add(name.substring(0, i));
      }
    }
    if (isAdding) {
      user.addAll({'userID': uid});
      await db.collection('regma_users').doc(uid).set(user);
    } else {
      if (picture != null) {
        //updating profile pic
        print('Yes....');
        if (user['profilePicURL'] != null) {
          //user had a profile picture. Delete it.
          await file.delete(user['profilePicURL']);
          user['profilePicURL'] =
              await file.uploadFile('regma-users', uid, picture);
        } else {
          user['profilePicURL'] =
              await file.uploadFile('regma-users', uid, picture);
        }
      }
      await db.collection('regma_users').doc(uid).set(
            user,
            SetOptions(
              merge: true,
            ),
          );
      print('*/*/*');
    }
    await db.collection('regma_users').doc(uid).set(
        {'searchArray': searchArray},
        SetOptions(
          merge: true,
        ));
  }

  Future<Map<String, dynamic>> getUser(String uid) async {
    var result = await db.collection('regma_users').doc(uid).get();
    return result.data();
  }

  Future<String> getParentalCode() async {
    var result = await getUser(uid);
    var parentalCode = result['parentalCode'];

    return parentalCode == null ? '***' : parentalCode;
  }

  Future<void> setParentalCode(String code) async {
    await db.collection('regma_users').doc(uid).set(
        {'parentalCode': code},
        SetOptions(
          merge: true,
        ));
  }

  Future<String> getFCMToken() async {
    var result = await getUser(uid);
    var fcmToken = result['fcmToken'];

    return fcmToken;
  }

  Future<void> setFCMToken(String token) async {
    await db.collection('regma_users').doc(uid).set(
        {'fcmToken': token},
        SetOptions(
          merge: true,
        ));
  }

  Future<void> setIsVisibleOnSearch(bool val) async {
    await db.collection('regma_users').doc(uid).set(
        {'isVisibleOnSearch': val},
        SetOptions(
          merge: true,
        ));
  }

  Future<List<MUser>> getAllUsers() async {
    var users = <MUser>[];
    var result = await db.collection('regma_users').get();

    result.docs.forEach((userJson) {
      var user = MUser.fromJson(userJson.data());
      users.add(user);
    });
    return users;
  }

  /// Courses
  Future<List<CourseModel>> getAllCourses() async {
    List<CourseModel> courses = [];
    var result = await db.collection("courses").get();
    result.docs.forEach((courseJson) {
      var course = courseJson.data();
      courses.add(CourseModel.fromJson(course));
    });
    return courses;
  }

  Future<String> saveCourse(Map<String, dynamic> course, bool isAdding) async {
    await db.doc('courses/${course['courseID']}').set(course);
    return course['courseID'];
  }

  Future<List<LessonModel>> getLessonsByCourseId(String id) async {
    List<LessonModel> lessons = [];
    var result = await db
        .collection("lessons")
        .where("courseID", isEqualTo: id)
        .orderBy("lessonCount")
        .get();
    result.docs.forEach((lessonJson) {
      var lesson = lessonJson.data();
      lessons.add(LessonModel.fromJson(lesson));
    });
    return lessons;
  }

  Future<List<QuestionModel>> getQuestionsByLessonId(String id) async {
    List<QuestionModel> questions = [];
    var result = await db
        .collection("questions")
        .where("lessonID", isEqualTo: id)
        .orderBy('questionCount')
        .get();
    result.docs.forEach((questionJson) {
      var question = questionJson.data();
      questions.add(QuestionModel.fromJson(question));
    });
    return questions;
  }

  Future<List<AnswerModel>> getAnswersByQuestionId(String id) async {
    List<AnswerModel> answers = [];
    var result =
        await db.collection("answers").where("questionID", isEqualTo: id).get();
    result.docs.forEach((answerJson) {
      var answer = answerJson.data();
      answers.add(AnswerModel.fromJson(answer));
    });
    return answers;
  }

  Future<String> saveLesson(Map<String, dynamic> lesson, bool isAdding) async {
    if (isAdding) {
      var lessonDoc = await db.collection('lessons').add(lesson);
      var id = lessonDoc.id;
      await db.doc('lessons/$id').set(
        {'lessonID': id},
        SetOptions(
          merge: true,
        ),
      );
      return id;
    } else {
      await db.doc('lessons/${lesson['lessonID']}').set(lesson);
      return lesson['lessonID'];
    }
  }

  Future<String> saveQuestion(
      Map<String, dynamic> question, bool isAdding) async {
    if (isAdding) {
      var questionDoc = await db.collection('questions').add(question);
      var id = questionDoc.id;
      await db.doc('questions/$id').set(
        {'questionID': id},
        SetOptions(
          merge: true,
        ),
      );
      return id;
    } else {
      await db.doc('questions/${question['questionID']}').set(question);
      return question['questionID'];
    }
  }

  Future<String> saveAnswer(Map<String, dynamic> answer, bool isAdding) async {
    if (isAdding) {
      var answerDoc = await db.collection('answers').add(answer);
      var id = answerDoc.id;
      await db.doc('answers/$id').set(
        {'answerID': id},
        SetOptions(
          merge: true,
        ),
      );
      return id;
    } else {
      await db.doc('answers/${answer['answerID']}').set(answer);
      return answer['answerID'];
    }
  }

  Future<List<String>> getAllBoughtItems(String item) async {
    var items = <String>[];
    var result = await db.collection('purchases/$uid/${item}s').get();
    result.docs.forEach((element) {
      items.add(element.id);
    });

    return items;
  }

  Future<void> setBoughtCourse(String courseId, String plan) async {
    Map<String, dynamic> value = {};
    value['plan'] = plan;
    value['lastCompletedLesson'] = 0;
    await db.doc('purchases/$uid/courses/$courseId').set(value);
  }

  Future<int> getLastCompletedLessonByCourseId(String id) async {
    var result = await db.doc('purchases/$uid/courses/$id').get();
    return !result.exists ? 0 : result['lastCompletedLesson'];
  }

  Future<void> setLastCompletedLessonByCourseId(
      String id, int lessonCount) async {
    await db.doc('purchases/$uid/courses/$id').set(
      {'lastCompletedLesson': lessonCount},
      SetOptions(
        merge: true,
      ),
    );
  }

  Future<void> setLessonScore(String lessonId, double score) async {
    await db.doc('purchases/$uid/lessons/$lessonId').set(
      {'score': score},
    );
  }

  Future<double> getLessonScore(String lessonId) async {
    var result = await db.doc('purchases/$uid/lessons/$lessonId').get();

    return result['score'] == null ? 0 : result['score'];
  }

  Future<void> saveSubscription(Map<String, dynamic> sub) async {
    await db.doc('subscriptions/$uid/courses/${sub['courseId']}').set(sub);
  }

  Future<List<Subscription>> getSubscriptions() async {
    List<Subscription> subscriptions = [];
    var result = await FirebaseFirestore.instance
        .collection("subscriptions/$uid/courses")
        .get();

    result.docs.forEach((subscriptionJson) {
      var subscription = subscriptionJson.data();
      subscriptions.add(Subscription.fromJson(subscription));
    });
    return subscriptions;
  }

  /// Media

  Future<String> saveMedia(Map<String, dynamic> media) async {
    await db.doc('media/${media['id']}').set(media);
    return media['id'];
  }

  Future<List<Media>> getAllMedia() async {
    List<Media> media = [];
    var result = await db.collection("media").get();
    result.docs.forEach((mediaJson) {
      var _media = mediaJson.data();
      media.add(Media.fromJson(_media));
    });
    return media;
  }

  Future<void> setBoughtMedia(
      String mediaId, String image, String name, double price) async {
    Map<String, dynamic> value = {};
    value['id'] = mediaId;
    value['image'] = image;
    value['name'] = name;
    value['price'] = price;
    value['dateTime'] = DateTime.now().toIso8601String();
    await db.doc('purchases/$uid/medias/$mediaId').set(value);
  }

  Future<List<PaidMediaItem>> getBoughtMedia() async {
    List<PaidMediaItem> paidMedia = [];
    var result = await db.collection("purchases/$uid/medias").get();

    result.docs.forEach((elt) {
      var media = elt.data();

      paidMedia.add(PaidMediaItem.fromJson(media));
    });

    return paidMedia;
  }

  Future<Map<String, double>> getDownloadSize() async {
    var result = await db.doc("admin/downloadSize").get();

    Map<String, double> res = {
      'maximum': result.data()['maximum'] as double,
      'minimum': result.data()['minimum'] as double,
    };

    return res;
  }

  /// Messaging

  String getTime(DateTime timestamp) {
    // var zone = DateTime.now().timeZoneOffset.inMilliseconds;
    // DateTime dateTime =
    //     DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp) + zone);
    // DateTime dateTime = DateTime.parse(timestamp);
    DateTime dateTime = timestamp.toLocal();
    DateFormat format;
    if (DateTime.now().difference(dateTime).inMilliseconds <= 86400000) {
      format = DateFormat('jm');
    } else {
      format = DateFormat.yMEd('en_US');
    }
    // return format
    //     .format(DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp)));

    return format.format(dateTime);
  }

  Future<List<Conversation>> getAllConversations() async {
    //var uid = uid;
    var cons = <Conversation>[];

    try {
      var result = await db
          .collection('chat')
          .where('users', arrayContains: uid)
          .orderBy('lastMessage.timestamp', descending: true)
          .get();
      // print('kl ${result.docs.length}');
      for (var elt in result.docs) {
        var msg = elt['lastMessage'];
        var users =
            (elt['users'] as List<dynamic>).map((e) => e.toString()).toList();
        // print('kl');
        DateTime timestamp;
        if (msg['timestamp'] == null) {
          timestamp = DateTime.now();
        } else {
          timestamp = (msg['timestamp'] as Timestamp).toDate();
        }
        var timestampString = getTime(timestamp);

        var ind = users.indexWhere((element) => element != uid); //Peer info
        var userJson = await getUser(users[ind]);
        var user = MUser.fromJson(userJson);
        var con = Conversation(
          id: DateTime.now().toString(),
          peerId: user.userID,
          uid: uid,
          peerName: user.name,
          peerUrl: user.profilePicURL,
          content: msg['content'],
          timestamp: timestampString,
        );

        cons.add(con);
      }
    } catch (e) {
      print(e.toString());
    }

    return cons;
  }

  Future<void> setLastConversation(
      Map<String, dynamic> lastMessage, String uid, String peerId) async {
    var convId = Util.getConversationId(uid, peerId);
    var conv = {
      'lastMessage': lastMessage,
      'users': [uid, peerId],
    };
    await db.collection("chat").doc(convId).set(conv);
  }

  Future<List<Friendship>> getAllFriends() async {
    //var uid = uid;
    var users = <Friendship>[];
    var result = await db
        .collection('friendship')
        .where('users', arrayContains: uid)
        .where('status', isEqualTo: 1)
        .get();
    for (var elt in result.docs) {
      var friends = <String>[];
      friends =
          (elt['users'] as List<dynamic>).map((e) => e.toString()).toList();
      var ind = friends.indexWhere((element) => element != uid); //Peer uid
      var friendJson = await getUser(friends[ind]);
      var friend = MUser.fromJson(friendJson);
      var user = Friendship(
          id: DateTime.now().toString(),
          uid: uid,
          peerId: friend.userID,
          peerUrl: friend.profilePicURL,
          peerName: friend.name + ' ' + friend.surname,
          isFriend: true,
          isInvitation: 0);
      users.add(user);
    }
    return users;
  }

  Future<bool> isFriendToMe(String peerId) async {
    var result = await db
        .collection('friendship')
        .where('users', arrayContains: uid)
        .where('status', isEqualTo: 1)
        .get();
    for (var elt in result.docs) {
      var friends = <String>[];
      friends =
          (elt['users'] as List<dynamic>).map((e) => e.toString()).toList();
      if (friends.contains(peerId)) return true; //Peer uid
    }

    return false;
  }

  Future<bool> isMessageSent(String peerId) async {
    //I have sent an invitation to peerId, no need to appear in the search
    var result = await db
        .collection('friendship')
        .where('idFrom', isEqualTo: uid)
        .where('idTo', isEqualTo: peerId)
        .where('status', isEqualTo: 0)
        .get();

    // for (var doc in result.docs) {
    //   if (doc.data()['idTo'] == peerId) return true;
    // }

    return result.docs.length > 0;
  }

  Future<bool> isMessageReceived(String peerId) async {
    //I have received an invitation from peerId, no need to appear in the search
    var result = await db
        .collection('friendship')
        .where('idFrom', isEqualTo: peerId)
        .where('idTo', isEqualTo: uid)
        .where('status', isEqualTo: 0)
        .get();

    return result.docs.length > 0;
  }

  Future<List<Friendship>> searchFriendsByName(String name) async {
    var users = <Friendship>[];
    bool isFriend = false;
    var result = await db
        .collection('regma_users')
        .where('searchArray', arrayContains: name)
        .where('isVisibleOnSearch', isEqualTo: true)
        .get();

    for (var elt in result.docs) {
      var user = MUser.fromJson(elt.data());
      if (user.userID != uid) {
        isFriend = await isFriendToMe(user.userID);
        var isSent = await isMessageSent(
            user.userID); //Check whether a friend request has been sent or not
        var isReceived = await isMessageReceived(user
            .userID); //Check whether a friend request has been received or not
        if (!isSent && !isReceived)
          users.add(Friendship(
            id: DateTime.now().toString(),
            peerName: user.name + ' ' + user.surname,
            peerUrl: user.profilePicURL,
            peerId: user.userID,
            uid: uid,
            isFriend: isFriend,
            isInvitation: 0,
          ));
      }
    }
    return users;
  }

  Future<Friendship> sendFriendRequest(String peerId) async {
    var values = {
      'idFrom': uid,
      'idTo': peerId,
      'status': 0,
      'users': [uid, peerId],
    };
    var result = await db.collection('friendship').add(values);
    await FirebaseFirestore.instance.doc('friendship/${result.id}').set(
      {'id': result.id},
      SetOptions(
        merge: true,
      ),
    );
    var userJson = await getUser(peerId);
    var user = MUser.fromJson(userJson);

    return Friendship(
        id: result.id,
        peerName: user.name + ' ' + user.surname,
        peerUrl: user.profilePicURL,
        peerId: peerId,
        uid: uid,
        isInvitation: 2,
        isFriend: false);
  }

  Future<void> acceptFriendRequest(String requestId) async {
    await db.doc('friendship/$requestId').set(
      {'status': 1},
      SetOptions(
        merge: true,
      ),
    );
  }

  Future<void> cancelFriendRequest(String requestId) async {
    await deleteEntity('friendship', 'id', requestId);
  }

  Future<List<Friendship>> getAllRequests() async {
    var friends = <Friendship>[];

    var result = await db
        .collection('friendship')
        .where('users', arrayContains: uid)
        .where('status', isEqualTo: 0)
        .get();

    for (var elt in result.docs) {
      var request = FriendRequest.fromJson(elt.data());
      var friendUID = request.idTo == uid ? request.idFrom : request.idTo;
      var isInvitation = request.idTo == uid ? 1 : 2;
      var userJson = await getUser(friendUID);
      var user = MUser.fromJson(userJson);
      var friend = Friendship(
        id: request.id,
        uid: uid,
        peerId: friendUID,
        peerUrl: user.profilePicURL,
        peerName: user.name + ' ' + user.surname,
        isFriend: false,
        isInvitation: isInvitation,
      );

      friends.add(friend);
    }

    return friends;
  }

  /// Disable/Enable services

  Future<void> setPaymentOptions(bool val) async {
    print('object');
    await db.doc('admin/payment').set({'enable': val});
  }

  Future<bool> getPaymentOptions() async {
    var result = await db.doc('admin/payment').get();

    return result.data()['enable'] as bool;
  }

  Future<void> setYearlySubscription(bool val) async {
    await db.doc('admin/yearlySubscription').set({'enable': val});
  }

  Future<bool> getYearlySubscription() async {
    var result = await db.doc('admin/yearlySubscription').get();

    return result.data()['enable'] as bool;
  }
}
