import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:regma/screens/chat_room_screen.dart';

import '../data/colors.dart';
import '../providers/friend_provider.dart';
import '../widgets/confirm_settings_change.dart';

Future<bool> _confirmSettingsChange(BuildContext context) async {
  bool result = await showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      context: context,
      builder: (_) {
        return ConfirmSettingsChange(false);
      });

  return result;
}

class FriendshipItem extends StatelessWidget {
  Key key;
  String requestId;
  String uid;
  String peerId;
  String peerUrl;
  String peerName;
  bool isFriend;
  int isInvitation;
  bool fromSearch;

  FriendshipItem({
    this.key,
    this.requestId,
    this.uid,
    this.peerId,
    this.peerUrl,
    this.peerName,
    this.isFriend,
    this.isInvitation,
    this.fromSearch = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: isFriend
              ? () {
                  // if (fromSearch) Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed(
                    ChatRoomScreen.routeName,
                    arguments: {
                      'fromPush': false,
                      'uid': uid,
                      'peerId': peerId,
                      'peerUrl': peerUrl,
                      'peerName': peerName,
                    },
                  );
                }
              : null,
          leading: CircleAvatar(
            radius: 20,
            backgroundColor: myOrange.withOpacity(.3),
            backgroundImage: peerUrl == null
                ? AssetImage('assets/images/profile.png')
                : NetworkImage(peerUrl),
          ),
          title: Text(
            peerName,
            style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(.7)),
          ),
          trailing: isFriend
              ? Text('')
              : isInvitation == 0
                  ? FittedBox(
                      child: Container(
                        width: 100,
                        child: InviteButton(peerId, peerName),
                      ),
                    )
                  : isInvitation == 1
                      ? Container(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                  icon: Icon(
                                    Icons.cancel,
                                    color: myOrange,
                                  ),
                                  onPressed: () async {
                                    await Provider.of<FriendProvider>(context,
                                            listen: false)
                                        .cancelFriendRequest(requestId);
                                  }),
                              IconButton(
                                  icon: Icon(
                                    Icons.check,
                                    color: myOrange,
                                  ),
                                  onPressed: () async {
                                    var result =
                                        await _confirmSettingsChange(context);
                                    if (result) {
                                      await Provider.of<FriendProvider>(context,
                                              listen: false)
                                          .acceptFriendRequest(requestId);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: RichText(
                                            text: TextSpan(
                                                text: peerName,
                                                style: GoogleFonts.quicksand(
                                                  color: myOrange,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    style:
                                                        GoogleFonts.quicksand(
                                                      color: Colors.white,
                                                    ),
                                                    text:
                                                        ' invitation accepted',
                                                  )
                                                ]),
                                          ),
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
                                    }
                                  }),
                            ],
                          ),
                        )
                      : Icon(
                          Icons.pending,
                          color: myOrange,
                        ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class InviteButton extends StatefulWidget {
  String peerId;
  String peerName;
  InviteButton(this.peerId, this.peerName);
  @override
  _InviteButtonState createState() => _InviteButtonState();
}

class _InviteButtonState extends State<InviteButton> {
  var isLoading = false;
  var isSent = false;
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : isSent
            ? Icon(
                Icons.check,
                color: myOrange,
              )
            : TextButton.icon(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });

                  await Provider.of<FriendProvider>(context, listen: false)
                      .sendFriendRequest(widget.peerId);
                  setState(() {
                    isLoading = false;
                    isSent = true;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: RichText(
                        text: TextSpan(
                            text: 'Invitation sent to ',
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                            ),
                            children: [
                              TextSpan(
                                style: GoogleFonts.quicksand(
                                  color: myOrange,
                                ),
                                text: widget.peerName,
                              )
                            ]),
                      ),
                      duration: Duration(seconds: 3),
                    ),
                  );

                  // var result = await _confirmSettingsChange(context);
                  //
                  // if (result) {
                  //   await Provider.of<FriendProvider>(context, listen: false)
                  //       .sendFriendRequest(widget.peerId);
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(
                  //       content: RichText(
                  //         text: TextSpan(
                  //             text: 'Invitation sent to ',
                  //             style: GoogleFonts.quicksand(
                  //               color: Colors.white,
                  //             ),
                  //             children: [
                  //               TextSpan(
                  //                 style: GoogleFonts.quicksand(
                  //                   color: myOrange,
                  //                 ),
                  //                 text: widget.peerName,
                  //               )
                  //             ]),
                  //       ),
                  //       duration: Duration(seconds: 3),
                  //     ),
                  //   );
                  //   setState(() {
                  //     isLoading = false;
                  //     isSent = true;
                  //   });
                  // } else {
                  //   setState(() {
                  //     isLoading = false;
                  //   });
                  // }
                },
                icon: Icon(Icons.person_add_outlined),
                label: Text(
                  'INVITE',
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              );
  }
}
