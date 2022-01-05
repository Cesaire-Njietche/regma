import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/colors.dart';
import '../screens/chat_room_screen.dart';

class ConversationItem extends StatelessWidget {
  String peerId;
  String uid;
  String peerUrl;
  String peerName;
  String content;
  String timestamp;

  ConversationItem({
    this.peerId,
    this.uid,
    this.peerUrl,
    this.peerName,
    this.content,
    this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Column(
        children: [
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(
                ChatRoomScreen.routeName,
                arguments: {
                  'fromPush': false,
                  'uid': uid,
                  'peerId': peerId,
                  'peerUrl': peerUrl,
                  'peerName': peerName,
                },
              );
            },
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: myOrange.withOpacity(.3),
              backgroundImage: peerUrl == null
                  ? AssetImage('assets/images/profile.png')
                  : NetworkImage(peerUrl),
            ),
            title: Text(
              peerName,
              style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              content.length > (constraints.maxWidth / 15)
                  ? content.substring(0, (constraints.maxWidth ~/ 15) - 1) +
                      '...'
                  : content,
              style: GoogleFonts.quicksand(fontSize: 14.5),
            ),
            trailing: Text(
              timestamp,
              style: GoogleFonts.quicksand(
                fontSize: 12,
                color: Colors.black.withOpacity(.3),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 85,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Divider(
                  height: 2,
                  thickness: 1,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
