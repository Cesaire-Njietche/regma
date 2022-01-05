import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/message_provider.dart';
import '../services/regma_services.dart';
import '../widgets/regma_bottom_navigation_bar.dart';
import 'chat_room_screen.dart';
import 'chat_screen.dart';
import 'classroom_screen.dart';
import 'courses_screen.dart';
import 'media_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  static final String routeName = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var pages = <Widget>[];
  var _selectedItem = 0;
  FirebaseMessaging messaging;
  NotificationSettings settings;
  String token;
  bool requestPass = false;

  initializeFCM() async {
    messaging = FirebaseMessaging.instance;

    settings = await messaging.requestPermission(
      sound: true,
      badge: true,
      carPlay: false,
      alert: true,
      announcement: false,
      criticalAlert: false,
      provisional: false,
    );

    token = await FirebaseMessaging.instance.getToken();
    await RegmaServices().setFCMToken(token);

    FirebaseMessaging.instance.onTokenRefresh
        .listen(RegmaServices().setFCMToken);
    // requestPass = true;
    // setState(() {});
  }

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    String uid, peerId, peerName, peerUrl;
    uid = message.data['uid'].toString().trim();
    peerId = message.data['peerId'].toString();
    final user = await RegmaServices().getUser(uid);
    peerUrl = user['profilePicURL'];
    peerName = user['name'];

    Navigator.of(context).pushNamed(
      ChatRoomScreen.routeName,
      arguments: {
        'fromPush': true,
        'uid': peerId,
        'peerId': uid,
        'peerUrl': peerUrl,
        'peerName': peerName,
      },
    );
  }

  @override
  void initState() {
    super.initState();
    pages = [
      CoursesScreen(),
      ClassroomScreen(),
      MediaScreen(),
      ChatScreen(),
      SettingsScreen(),
    ];
    initializeFCM();
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    // var width = MediaQuery.of(context).size.width;
    // if (requestPass)
    //   print('User granted permission: ${settings.authorizationStatus}');

    return Scaffold(
      // appBar: RegmaAppBar(
      //   context: context,
      //   barTitle: Text(
      //     'Yes',
      //     style: TextStyle(color: Colors.amber),
      //   ),
      //   actions: [
      //     IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {})
      //   ],
      // ),
      body: Consumer<MessageProvider>(
          builder: (context, msg, _) => pages[msg.selectedItem]),

      bottomNavigationBar: RegmaBottomNavigationBar(
          // onChange: (index) {
          //   // _selectedItem = index;
          //   // //print(_selectedItem);
          //   // setState(() {});
          //   Provider.of<MessageProvider>(context, listen: false)
          //       .setSelectedItem(index);
          // },
          ),
    );
  }
}
