import 'package:flutter/material.dart';

import 'start_screen_one.dart';
import 'start_screen_two.dart';

class StartScreen extends StatelessWidget {
  static String routeName = '/start-screen';
  @override
  Widget build(BuildContext context) {
    final controller = PageController(
      initialPage: 0,
    );
    return PageView(
      scrollDirection: Axis.horizontal,
      controller: controller,
      children: [
        StartScreenOne(),
        StartScreenTwo(),
      ],
    );
  }
}
