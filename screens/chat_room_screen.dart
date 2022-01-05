import 'dart:async';

import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/colors.dart';
import '../helpers/util.dart';
import '../providers/message_provider.dart';
import '../services/regma_services.dart';

class ChatRoomScreen extends StatelessWidget {
  static String routeName = '/chat-room-screen';

  @override
  Widget build(BuildContext context) {
    var values =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    String uid = values['uid'];
    String peerId = values['peerId'];
    bool fromPush = values['fromPush'];

    print(fromPush);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white54,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: myOrange,
          ),
          onPressed: () {
            if (fromPush) {
              Provider.of<MessageProvider>(context, listen: false)
                  .setSelectedItem(3);
            }
            Navigator.of(context).pop();
          },
        ),
        // elevation: Theme.of(context).platform == TargetPlatform.iOS ? 4.0 : 0.0,
        elevation: 0.0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: values['peerUrl'] == null
                  ? AssetImage('assets/images/profile.png')
                  : NetworkImage(values['peerUrl']),
            ),
            SizedBox(
              width: 10,
            ),
            Text(values['peerName']),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.transparent.withOpacity(0.05),
                  Colors.transparent.withOpacity(0.1),
                  Colors.transparent.withOpacity(0.05)
                ],
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Message(
                  uid: uid,
                  peerId: peerId,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              NewMessage(
                uid: uid,
                peerId: peerId,
              ),
              SizedBox(
                height: 5,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class Message extends StatefulWidget {
  String uid;
  String peerId;
  Message({
    this.uid,
    this.peerId,
  });

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  ScrollController _scrollController = ScrollController();
  bool _firstAutoscrollExecuted = true;

  // void _scrollListener() {
  //   if (_scrollController.hasClients && _firstAutoscrollExecuted) {
  //     _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  //     _firstAutoscrollExecuted = false;
  //   }
  // }

  @override
  void initState() {
    //_scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var conId = Util.getConversationId(widget.uid, widget.peerId);
    var msgWidth = MediaQuery.of(context).size.width * .8;

    // Timer(
    //   Duration(milliseconds: 710),
    //   () => _scrollController.jumpTo(
    //     _scrollController.position.maxScrollExtent,
    //     // duration: const Duration(milliseconds: 900),
    //     // curve: Curves.easeOut,
    //   ),
    // );

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat/$conId/message')
            .orderBy(
              'timestamp',
              // descending: false,
            )
            .snapshots(),
        builder:
            (ctx, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) return Container();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController
                  .jumpTo(_scrollController.position.maxScrollExtent);
            }
          });
          final docs = snapshot.data.docs;
          return ListView.builder(
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 5),
            //reverse: true,
            itemBuilder: (ctx, ind) {
              var document = docs[ind];
              // print(document['timestamp']);
              DateTime timestamp;
              if (document['timestamp'] == null) {
                timestamp = DateTime.now();
              } else {
                timestamp = (document['timestamp'] as Timestamp).toDate();
              }
              var isSame = false;

              if (ind > 0) {
                isSame = docs[ind - 1]['idFrom'] == document['idFrom'];
              }
              return Row(
                children: <Widget>[
                  // Text
                  Container(
                      margin: EdgeInsets.only(top: isSame ? 0 : 5, bottom: 5),
                      padding:
                          isSame ? EdgeInsets.symmetric(horizontal: 7) : null,
                      child: TweenAnimationBuilder<double>(
                        key: Key(document.id),
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 900),
                        builder: (context, value, _) => Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0.0, 60 * (1 - value)),
                            child: Bubble(
                              key: ValueKey(document.id),
                              color: document['idFrom'] == widget.uid
                                  ? myOrange.withOpacity(.6)
                                  : Colors.white70,
                              elevation: 0,
                              padding: const BubbleEdges.all(10.0),
                              nip: isSame
                                  ? BubbleNip.no
                                  : document['idFrom'] == widget.uid
                                      ? BubbleNip.rightTop
                                      : BubbleNip.leftTop,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    document['content'],
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(.75),
                                        fontSize: 15),
                                  ),
                                  SizedBox(
                                    height: 9,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        RegmaServices().getTime(timestamp),
                                        style: TextStyle(
                                            color: Colors.black.withOpacity(.3),
                                            fontSize: 12),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      width: msgWidth)
                ],
                mainAxisAlignment: document['idFrom'] == widget.uid
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
              );
            },
            itemCount: docs.length,
          );
        });
  }

  @override
  void dispose() {
    // _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
}

class NewMessage extends StatefulWidget {
  String uid;
  String peerId;

  NewMessage({
    this.uid,
    this.peerId,
  });

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _controller = TextEditingController();
  var _enteredMessage = '';

  Future<void> submitMessage() async {
    var conId = Util.getConversationId(widget.uid, widget.peerId);
    _controller.clear(); //clear the TextField
    FocusScope.of(context).unfocus(); //close the soft keyboard

    var date = DateTime.now();
    var lastMessage = {
      'idFrom': widget.uid,
      'idTo': widget.peerId,
      'content': _enteredMessage.trim(),
      // 'timestamp': date.toUtc().millisecondsSinceEpoch.toString(),
      'timestamp': FieldValue.serverTimestamp(),
      'read': false,
    };

    await FirebaseFirestore.instance
        .collection('chat/$conId/message')
        .add(lastMessage);

    var users = [widget.uid, widget.peerId];

    await FirebaseFirestore.instance.doc('chat/$conId').set({
      'lastMessage': lastMessage,
      'users': users,
    });
    _enteredMessage = '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 20),
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.width / 3),
        child: TextField(
          style: GoogleFonts.quicksand(),
          controller: _controller,
          autocorrect: true,
          enableSuggestions: true,
          textCapitalization: TextCapitalization.sentences,
          maxLines: null,
          decoration: InputDecoration(
            hintStyle: GoogleFonts.quicksand(fontSize: 14),
            suffixIcon: IconButton(
              onPressed: null,
              icon: FittedBox(
                fit: BoxFit.cover,
                child: ClipOval(
                  child: Material(
                    color: myOrange.withOpacity(.75), // button color
                    child: InkWell(
                      splashColor: Colors.black54, // inkwell color
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width / 5,
                          height: MediaQuery.of(context).size.width / 5,
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Icon(Icons.arrow_upward,
                                color: Colors.white, size: 18.0),
                          )),
                      onTap:
                          _enteredMessage.trim().isEmpty ? null : submitMessage,
                    ),
                  ),
                ),
              ),
            ),
            fillColor: Colors.white,
            hintText: 'Message here...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(MediaQuery.of(context).size.width / 18),
              ),
            ),
          ),
          onChanged: (value) {
            setState(() {
              _enteredMessage = value;
            });
          },
        ),
      ),
    );
  }
}
