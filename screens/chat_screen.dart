import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../data/colors.dart';
import '../models/conversation.dart';
import '../services/regma_services.dart';
import '../widgets/conversation_item.dart';
import 'manage_connections_screen.dart';
import 'search_peer_screen.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var conversations = <Conversation>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messaging',
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.forum_outlined,
              color: myOrange,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(SearchPeerScreen.routeName);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.people_alt_outlined,
              color: myOrange,
            ),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(ManageConnectionsScreen.routeName);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              // color: Colors.white70.withOpacity(.1),
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
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('chat').snapshots(),
            builder: (ctx,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (!snapshot.hasData) return Container();

              return FutureBuilder(
                  future: RegmaServices().getAllConversations(),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      conversations = snapshot.data;
                      //conversations = [];
                      if (conversations.length == 0) {
                        return Center(
                          child: Text(
                            'Start Chatting With Friends ...',
                          ),
                        );
                      }
                      return ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          physics: BouncingScrollPhysics(),
                          itemCount: conversations.length,
                          itemBuilder: (ctx, ind) {
                            var con = conversations[ind];
                            return ConversationItem(
                              uid: con.uid,
                              peerId: con.peerId,
                              peerUrl: con.peerUrl,
                              peerName: con.peerName,
                              content: con.content,
                              timestamp: con.timestamp,
                            );
                          });
                    }
                  });
            },
          ),
        ],
      ),
    );
  }
}
