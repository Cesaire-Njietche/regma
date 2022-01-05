import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

import '../data/dummy.dart';
import '../models/answer_model.dart';
import '../models/course_model.dart';
import '../models/lesson_model.dart';
import '../models/question_model.dart';
import '../services/file.dart';
import '../services/regma_services.dart';

class CoursesProvider with ChangeNotifier {
  var _courses = Dummy.courseItems;
  var _lessons = Dummy.lessonItems;

  var _questions = <QuestionModel>[];
  var _answers = <AnswerModel>[];
  var purchasedCourses = <String>[]; //List of subscribed courses ids
  User user;
  var lastCompletedLesson = 0;
  var paymentOptions = false;
  var yearlySubscription = true;
  // bool success = false;
  CoursesProvider() {
    user = FirebaseAuth.instance.currentUser;
    _courses.clear();
  }
  List<CourseModel> get courseItems {
    return [..._courses];
  }

  // List<CourseModel> getAllBoughtCourses() =>
  //     _courses.where((course) => !course.isLock).toList();

  List<String> get ids {
    return _courses.map((course) => course.courseID).toList();
  }

  List<LessonModel> get lessonItems {
    return [..._lessons];
  }

  List<QuestionModel> get questionItems {
    return [..._questions];
  }

  List<AnswerModel> get answerItems {
    return [..._answers];
  }

  Future<String> addNewCourse(
      CourseModel course, File thumbnail, bool isAdding) async {
    if (thumbnail != null) {
      if (!isAdding) {
        //updating
        await MFile().delete(course.thumbnailURL);
      }
      course.thumbnailURL = await MFile().uploadFile("course-thumbnails",
          'courses' + '__' + DateTime.now().toString(), thumbnail);
    }

    var id = await RegmaServices().saveCourse(course.toJson(), isAdding);
    course.courseID = id;
    if (isAdding)
      _courses.add(course);
    else {
      var ind = _courses.indexWhere((element) => element.courseID == id);
      _courses[ind] = course;
    }
    notifyListeners();
    return id;
  }

  Future<List<CourseModel>> fetchAllCourses() async {
    //_courses.clear();
    _courses = await RegmaServices().getAllCourses();
    purchasedCourses = await loadPurchasedCoursesId();

    // _courses.sort((c1, c2) => c1.isLock ? 1 : -1);
    var ind = 0;
    paymentOptions = await RegmaServices().getPaymentOptions();
    yearlySubscription = await RegmaServices().getYearlySubscription();
    if (!paymentOptions) {
      _courses.forEach((course) => course.isLock = false);
    }
    if (purchasedCourses.length > 0) {
      purchasedCourses.forEach((id) {
        ind = _courses.indexWhere((course) => course.courseID == id);
        if (ind != -1) _courses[ind].isLock = false;
      });
    }

    print('${_courses.length} _courses.lengthY');
    //notifyListeners();
    return _courses;
  }

  Future<List<CourseModel>> fetchBoughtCourses() async {
    var courses = <CourseModel>[];
    purchasedCourses = await loadPurchasedCoursesId();

    _courses.forEach((course) {
      if (purchasedCourses.any((element) => element == course.courseID))
        courses.add(course);
    });
    return paymentOptions ? courses : _courses;
  }

  Future<List<String>> loadPurchasedCoursesId() async {
    return await RegmaServices().getAllBoughtItems('course');
  }

  Future<bool> hasPurchased(String id) async {
    purchasedCourses = await loadPurchasedCoursesId();
    return purchasedCourses.any((element) => element == id);
  }

  Future<void> deleteCourseById(String id) async {
    await RegmaServices().deleteEntity('courses', 'courseID', id);
    await MFile().delete(findCourseById(id).thumbnailURL);

    var lessons = await findLessonsByCourseId(id);
    lessons.forEach((lesson) async {
      await deleteLessonById(lesson.lessonID);
    });
    _courses.removeWhere((course) => course.courseID == id);
    notifyListeners();
  }

  CourseModel findCourseById(String id) =>
      _courses.firstWhere((course) => course.courseID == id);

  void setCourseToFreeById(String id) {
    int ind = _courses.indexWhere((course) => course.courseID == id);
    _courses[ind].isLock = false;
    notifyListeners();
  }

  Future<void> setBoughtCourse(String courseId, String plan) async {
    await RegmaServices().setBoughtCourse(courseId, plan);
    notifyListeners();
  }

  //Lessons

  LessonModel findLessonById(String id) =>
      _lessons.firstWhere((lesson) => lesson.lessonID == id);

  Future<List<LessonModel>> findLessonsByCourseId(String id) async {
    _lessons.clear();
    _lessons = await RegmaServices().getLessonsByCourseId(id);
    lastCompletedLesson =
        await RegmaServices().getLastCompletedLessonByCourseId(id);

    notifyListeners();

    return _lessons;
  }

  Future<void> deleteLessonById(String id) async {
    await RegmaServices().deleteEntity('lessons', 'lessonID', id);
    await MFile().delete(findLessonById(id).videoURL);

    var questions = await findQuestionsByLessonId(id);

    questions.forEach((question) async {
      await deleteQuestionById(question.questionID);
    });
    _lessons.removeWhere((lesson) => lesson.lessonID == id);
    notifyListeners();
  }

  Future<String> addNewLesson(
      LessonModel lesson, File transcript, bool isAdding) async {
    // if (video != null) {
    //   if (!isAdding) {
    //     //updating
    //     MFile().delete(lesson.videoURL);
    //   }
    //   lesson.videoURL = await MFile().uploadFile(
    //       "lesson-videos", 'lessons' + '__' + DateTime.now().toString(), video);
    // }
    if (transcript != null) {
      if (!isAdding) {
        //updating
        MFile().delete(lesson.content);
      }
      lesson.content = await MFile().uploadFile(
          "lesson-transcripts", path.basename(transcript.path), transcript);
    }

    var id = await RegmaServices().saveLesson(lesson.toJson(), isAdding);
    lesson.lessonID = id;
    if (isAdding)
      _lessons.add(lesson);
    else {
      var ind = _lessons.indexWhere((element) => element.lessonID == id);
      _lessons[ind] = lesson;
    }

    notifyListeners();
    return id;
  }

  Future<void> setLastCompletedLessonByCourseId(
      String id, int lessonCount) async {
    await RegmaServices().setLastCompletedLessonByCourseId(id, lessonCount);
    lastCompletedLesson = lessonCount;
    notifyListeners();
  }

  Future<void> setLessonScore(String lessonId, double score) async {
    await RegmaServices().setLessonScore(lessonId, score);
  }

  //Questions

  Future<List<QuestionModel>> findQuestionsByLessonId(String id) async {
    _questions.clear();
    _questions = await RegmaServices().getQuestionsByLessonId(id);

    //notifyListeners();
    return _questions;
  }

  QuestionModel findQuestionById(String id) =>
      _questions.firstWhere((question) => question.questionID == id);

  Future<String> addNewQuestion(QuestionModel question, bool isAdding) async {
    var id = await RegmaServices().saveQuestion(question.toJson(), isAdding);

    if (isAdding) {
      question.questionID = id;
      _questions.add(question);
    } else {
      var ind =
          _questions.indexWhere((elt) => elt.questionID == question.questionID);
      _questions[ind] = question;
    }
    notifyListeners();
    return id;
  }

  Future<void> deleteQuestionById(String id) async {
    await RegmaServices().deleteEntity('questions', 'questionID', id);
    var answers = await findAnswersByQuestionId(id);
    answers.forEach((answer) async {
      await RegmaServices()
          .deleteEntity('answers', 'answerID', answer.answerID);
    });

    _questions.removeWhere((question) => question.questionID == id);
    notifyListeners();
  }

  //Answers

  Future<String> addNewAnswer(AnswerModel answer, bool isAdding) async {
    var id = await RegmaServices().saveAnswer(answer.toJson(), isAdding);

    if (isAdding) {
      answer.answerID = id;
      _answers.add(answer);
    } else {
      var ind =
          _answers.indexWhere((element) => element.answerID == answer.answerID);
      _answers[ind] = answer;
    }
    notifyListeners();
    return id;
  }

  Future<List<AnswerModel>> findAnswersByQuestionId(String id) async {
    _answers.clear();
    _answers = await RegmaServices().getAnswersByQuestionId(id);

    //notifyListeners();

    return _answers;
  }

  void setPaymentOptions(bool val) {
    paymentOptions = val;
    notifyListeners();
  }

  void setYearlySubscription(bool val) {
    yearlySubscription = val;
    notifyListeners();
  }

  // Future<Map<QuestionModel, List<AnswerModel>>>
  //     findQuestionsAndAnswersByLessonId(String id) async {
  //   Map<QuestionModel, List<AnswerModel>> lesson = {};
  //   _questions = await findQuestionsByLessonId(id);
  //   print(_questions.length);
  //
  //   for (var q in _questions) {
  //     lesson[q] = await findAnswersByQuestionId(q.questionID);
  //     //lesson[q] = _answers;
  //     print('Answers length -- I ${lesson[_questions[0]].length}');
  //   }
  //   var q = lesson.keys.toList()[0];
  //   print('Answers length -- O ${lesson[_questions[0]][0]}');
  //   print('Lesson length ${lesson.length}');
  //   return lesson;
  // }

  @override
  void dispose() {
    _courses.clear();
    super.dispose();
  }
}
