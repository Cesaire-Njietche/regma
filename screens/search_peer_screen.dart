import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/colors.dart';
import '../models/friendship.dart';
import '../providers/friend_provider.dart';
import '../widgets/friendship_item.dart';

class SearchPeerScreen extends StatefulWidget {
  static String routeName = '/search-peer-screen';

  @override
  State<SearchPeerScreen> createState() => _SearchPeerScreenState();
}

class _SearchPeerScreenState extends State<SearchPeerScreen> {
  var friends = <Friendship>[];
  // final _controller = TextEditingController();
  Future future;
  // String query = '';
  @override
  void initState() {
    future =
        Provider.of<FriendProvider>(context, listen: false).fetchAllFriends();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('build');
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
        title: Text('Select Contact'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: myOrange,
            ),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DataSearch(),
              );
            },
          )
        ],
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white10,
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
              // SearchFriends(),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      // height: 10,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.transparent.withOpacity(0.05),
                      ),
                      child: Text(
                        'My Contacts',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: FutureBuilder(
                    future: future,
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        friends = snapshot.data;
                        //friends = [];
                        return friends.length == 0
                            ? Center(
                                child: Text('Search ...'),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                physics: BouncingScrollPhysics(),
                                itemCount: friends.length,
                                itemBuilder: (ctx, ind) {
                                  var friend = friends[ind];
                                  return FriendshipItem(
                                    peerName: friend.peerName,
                                    peerUrl: friend.peerUrl,
                                    peerId: friend.peerId,
                                    uid: friend.uid,
                                    isFriend: friend.isFriend,
                                    isInvitation: friend.isInvitation,
                                    fromSearch: true,
                                  );
                                });
                      }
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// class SearchFriends extends StatefulWidget {
//   const SearchFriends({Key key}) : super(key: key);
//
//   @override
//   _SearchFriendsState createState() => _SearchFriendsState();
// }
//
// class _SearchFriendsState extends State<SearchFriends> {
//   var friends = <Friendship>[];
//   final _controller = TextEditingController();
//   String query = '';
//   @override
//   Widget build(BuildContext context) {
//     return Flexible(
//       fit: FlexFit.loose,
//       flex: 2,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//             // height: 40,
//             // color: Colors.yellowAccent,
//             // decoration:
//             //     BoxDecoration(borderRadius: BorderRadius.circular(20)),
//             child: TextField(
//               decoration: InputDecoration(
//                 // fillColor: Colors.black87,
//                 floatingLabelBehavior: FloatingLabelBehavior.never,
//                 focusColor: myOrange,
//                 labelText: 'Search',
//                 labelStyle: TextStyle(fontSize: 15),
//                 prefixIcon: Icon(Icons.search_sharp),
//                 enabledBorder: UnderlineInputBorder(
//                   borderRadius: BorderRadius.circular(20),
//                   borderSide: BorderSide(
//                     color: Colors.white70,
//                   ),
//                 ),
//                 focusedBorder: UnderlineInputBorder(
//                   borderRadius: BorderRadius.circular(20),
//                   borderSide: BorderSide(
//                     color: Colors.white70,
//                   ),
//                 ),
//               ),
//               style: TextStyle(color: Colors.black87),
//               cursorColor: myOrange,
//               controller: _controller,
//               onChanged: (val) {
//                 query = val;
//                 if (val == '') {
//                   _controller.clear();
//                 }
//                 setState(() {
//                   // if (val == '') {
//                   //   _controller.clear();
//                   // }
//                 });
//               },
//             ),
//           ),
//           Expanded(
//             child: FutureBuilder(
//                 future: Provider.of<FriendProvider>(context, listen: false)
//                     .searchFriendsByName(query),
//                 builder: (ctx, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   } else {
//                     friends = snapshot.data;
//                     //friends = [];
//                     return friends.length == 0
//                         ? Center(
//                             child: Container(),
//                           )
//                         : ListView.builder(
//                             padding: EdgeInsets.symmetric(vertical: 5),
//                             physics: BouncingScrollPhysics(),
//                             itemCount: friends.length,
//                             itemBuilder: (ctx, ind) {
//                               var friend = friends[ind];
//                               return FriendshipItem(
//                                 peerName: friend.peerName,
//                                 peerUrl: friend.peerUrl,
//                                 peerId: friend.peerId,
//                                 uid: friend.uid,
//                                 isFriend: friend.isFriend,
//                                 isInvitation: friend.isInvitation,
//                                 fromSearch: true,
//                               );
//                             });
//                   }
//                 }),
//           )
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }

class DataSearch extends SearchDelegate<String> {
  DataSearch() : super(searchFieldLabel: "Search ...");

  var friends = <Friendship>[];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: myOrange,
        ),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.chevron_left,
        color: myOrange,
      ),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildWidget(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildWidget(context);
  }

  Widget _buildWidget(BuildContext context) {
    return query.isEmpty
        ? Container()
        : FutureBuilder(
            future: Provider.of<FriendProvider>(context, listen: false)
                .searchFriendsByName(query.toLowerCase()),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                friends = snapshot.data;
                // query = '';

                return friends.length == 0
                    ? Center(
                        child: Text(
                          'No Contact Found ...',
                          style: GoogleFonts.quicksand(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      )
                    : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(vertical: 5),
                        itemCount: friends.length,
                        itemBuilder: (ctx, ind) {
                          var friend = friends[ind];
                          return FriendshipItem(
                            key: ValueKey(friend.id),
                            uid: friend.uid,
                            peerId: friend.peerId,
                            peerUrl: friend.peerUrl,
                            peerName: friend.peerName,
                            isFriend: friend.isFriend,
                            isInvitation: friend.isInvitation,
                            fromSearch: true,
                          );
                        });
              }
            });
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      textTheme: TextTheme(
        headline6: GoogleFonts.quicksand(
          color: Colors.black87,
          decoration: TextDecoration.none,
        ),
      ),
      // inputDecorationTheme: InputDecorationTheme(
      //   hintStyle: GoogleFonts.quicksand(
      //     fontSize: 15,
      //     color: Colors.black54,
      //   ),
      // ),
    );
  }
}
