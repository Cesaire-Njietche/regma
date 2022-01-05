import 'package:flutter/material.dart';

Map<int, Color> color = {
  50: Color.fromRGBO(245, 248, 255, .1),
  100: Color.fromRGBO(245, 248, 255, .2),
  200: Color.fromRGBO(245, 248, 255, .3),
  300: Color.fromRGBO(245, 248, 255, .4),
  400: Color.fromRGBO(245, 248, 255, .5),
  500: Color.fromRGBO(245, 248, 255, .6),
  600: Color.fromRGBO(245, 248, 255, .7),
  700: Color.fromRGBO(245, 248, 255, .8),
  800: Color.fromRGBO(245, 248, 255, .9),
  900: Color.fromRGBO(245, 248, 255, 1),
};
MaterialColor myOrange =
    MaterialColor(Color.fromRGBO(255, 161, 74, 1).value, color);
