import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  Widget content;
  double height;
  double width;

  CustomDialog({this.content, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      elevation: 2,
      backgroundColor: Colors.white.withOpacity(.95),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        height: height ?? 300,
        width: width ?? 500,
        child: content,
      ),
    );
  }
}
