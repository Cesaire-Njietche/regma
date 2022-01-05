import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Util {
  static bool isValidEmail(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  static void rShowCupertinoDialog(String title, String content,
      Function onContinue, BuildContext context, TextStyle style) {
    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(
              title,
              style: style,
            ),
            content: Text(
              content,
              style: style,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  onContinue();
                  Navigator.pop(context);
                },
                child: Text(
                  "Continue",
                  style: style,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: style,
                ),
              )
            ],
          );
        });
  }

  static String getConversationId(String userId, String peerId) {
    return userId.hashCode <= peerId.hashCode
        ? userId + '_' + peerId
        : peerId + '_' + userId;
  }
}
