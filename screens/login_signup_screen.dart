import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../data/colors.dart';
import '../widgets/login_content.dart';

class LoginSignUpScreen extends StatefulWidget {
  static final String routeName = '/login-signup';
  @override
  _LoginSignUpScreenState createState() => _LoginSignUpScreenState();
}

class _LoginSignUpScreenState extends State<LoginSignUpScreen> {
  @override
  Widget build(BuildContext context) {
    // var screenHeight =
    //     MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    // var screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              alignment: Alignment.topRight,
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
              // child: Container(
              //   color: Colors.red,
              //   height: screenHeight / 4,
              //   width: screenWidth * 2 / 5,
            ),
            Positioned(
              right: -40,
              top: -20,
              child: _buildCircle(100, 100),
              // CustomPaint(
              //   size: Size(screenWidth * 2 / 5, screenHeight / 4),
              //   painter: RegCustomPainter(radius: screenWidth / 10),
              // ),
            ),
            Positioned.fill(
              child: Center(
                child: LoginContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildCircle(double h, double w) {
  return Container(
    height: h,
    width: w,
    decoration: BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(253, 113, 78, 1).withOpacity(0.8),
            myOrange.withOpacity(0.8),
          ]),
      shape: BoxShape.circle,
    ),
  );
}

class RegCustomPainter extends CustomPainter {
  final double radius;
  RegCustomPainter({this.radius = 12});
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.shader = ui.Gradient.linear(
      Offset(0, 0),
      Offset(size.width, size.height),
      [
        myOrange.shade500,
        myOrange.withOpacity(0.6),
      ],
    );

    var path = Path()
      //..moveTo(size.width / 10, 0)
      //..quadraticBezierTo(size.width / 20, 0, 0, size.height / 4)
      //..lineTo(size.width / 10, size.height / 2)
      ..lineTo(0, size.height / 4)
      ..quadraticBezierTo(
          0, size.height / 4 + radius, radius, size.height / 4 + radius)
      //..quadraticBezierTo(0, size.height / 3, size.width / 3, size.height / 2)
      //..quadraticBezierTo(size.width / 2, size.height * 2 / 5, size.width / 2, size.height / 2)
      ..lineTo(radius * 2, size.height / 4 + radius + 3)
      ..quadraticBezierTo(radius * 5 / 2, size.height / 4 + radius + 3,
          radius * 5 / 2, size.height / 4 + radius * 2 + 3)
      ..lineTo(radius * 5 / 2, size.height / 4 + radius * 5 / 2)
      ..quadraticBezierTo(radius * 5 / 2 + 3, size.height / 4 + radius * 3,
          radius * 7 / 2 + 3, size.height / 4 + radius * 3)
      ..lineTo(size.width, size.height / 4 + radius * 3)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
