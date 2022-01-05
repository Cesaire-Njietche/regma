import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key key}) : super(key: key);

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  User user;
  Timer timer;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    user = auth.currentUser;
    timer = Timer(Duration(seconds: 5), () {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'An email has been sent to ${user.email}. Click on the link provided to complete registration',
            style: TextStyle(
              color: Colors.black.withOpacity(.6),
              fontSize: w >= 410 ? 18 : 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user.reload();
    if (user.emailVerified) {
      //This never gets called. Reload triggers the userChanges listener
      // print('Email verified by user');
      // timer.cancel();
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => HomeScreen(),
      //     ));
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
