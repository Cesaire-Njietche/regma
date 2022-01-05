import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/colors.dart';
import '../models/friendship.dart';
import '../providers/friend_provider.dart';
import '../widgets/friendship_item.dart';

class ManageConnectionsScreen extends StatefulWidget {
  static String routeName = '/manage-connections';

  @override
  _ManageConnectionsScreenState createState() =>
      _ManageConnectionsScreenState();
}

class _ManageConnectionsScreenState extends State<ManageConnectionsScreen> {
  var index = 1;
  var friends = <Friendship>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: myOrange,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text('Manage Connections'),
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
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                  ),
                  child: _buildTabs(),
                ),
                SizedBox(
                  height: 10,
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: AnimatedCrossFade(
                    firstChild: FutureBuilder(
                      future:
                          Provider.of<FriendProvider>(context, listen: false)
                              .fetchAllRequests(),
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Consumer<FriendProvider>(
                            builder: (ctx, friendsProvider, _) {
                              var friends = friendsProvider.invitation;
                              return friends.length == 0
                                  ? Center(child: Text('No Invitation ...'))
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics: BouncingScrollPhysics(),
                                      itemCount: friends.length,
                                      itemBuilder: (ctx, ind) {
                                        var friend = friends[ind];

                                        return FriendshipItem(
                                          isInvitation: friend.isInvitation,
                                          isFriend: friend.isFriend,
                                          peerId: friend.peerId,
                                          uid: friend.uid,
                                          peerName: friend.peerName,
                                          peerUrl: friend.peerUrl,
                                          requestId: friend.id,
                                        );
                                      },
                                      padding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 10),
                                    );
                            },
                          );
                          friends = snapshot.data;
                          //friends = snapshot.data.invitation;

                        }
                      },
                    ),
                    secondChild: FutureBuilder(
                      future:
                          Provider.of<FriendProvider>(context, listen: false)
                              .fetchAllRequests(),
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Consumer<FriendProvider>(
                            builder: (ctx, friendsProvider, _) {
                              var friends = friendsProvider.pendingRequest;
                              return friends.length == 0
                                  ? Center(child: Text('No Pending Request...'))
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics: BouncingScrollPhysics(),
                                      itemBuilder: (ctx, ind) {
                                        var friend = friends[ind];

                                        return FriendshipItem(
                                          isInvitation: friend.isInvitation,
                                          isFriend: friend.isFriend,
                                          peerId: friend.peerId,
                                          uid: friend.uid,
                                          peerName: friend.peerName,
                                          peerUrl: friend.peerUrl,
                                          requestId: friend.id,
                                        );
                                      },
                                      itemCount: friends.length,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 10),
                                    );
                            },
                          );
                        }
                      },
                    ),
                    duration: Duration(milliseconds: 200),
                    crossFadeState: index == 1
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget _buildTabs() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              setState(() {
                index = 1;
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: index == 1 ? Colors.white38 : null,
                border: index == 1
                    ? Border(
                        bottom: BorderSide(
                          width: 2,
                          color: myOrange,
                        ),
                      )
                    : null,
              ),
              child: Text(
                'Invitations',
                style: TextStyle(
                    color: index == 1 ? myOrange : Colors.grey, fontSize: 17),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              setState(() {
                index = 2;
              });
            },
            child: AnimatedContainer(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 5),
              duration: Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: index == 2 ? Colors.white38 : null,
                border: index == 2
                    ? Border(
                        bottom: BorderSide(
                          width: 2,
                          color: myOrange,
                        ),
                      )
                    : null,
              ),
              child: Text(
                'Pending Requests',
                style: TextStyle(
                  color: index == 2 ? myOrange : Colors.grey.withOpacity(.7),
                  fontSize: 17,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
