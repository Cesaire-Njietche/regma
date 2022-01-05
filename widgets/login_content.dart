import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../data/colors.dart';
import 'login.dart';
import 'register.dart';

class LoginContent extends StatefulWidget {
  @override
  _LoginContentState createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent> {
  var index = 1;
  @override
  Widget build(BuildContext context) {
    var cardWidth = 280.0;
    var cardHeight = 540.0;

    // print('${screenWidth} is the width');
    // print(screenHeight);
    return SingleChildScrollView(
      // child: Container(
      //   width: screenWidth,
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40, top: 10),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: cardWidth,
              margin: EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white38,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        index = 1;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      //height: 50,
                      width: cardWidth / 2,
                      decoration: BoxDecoration(
                        color: index == 1 ? myOrange : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                            color: index == 1 ? Colors.white : Colors.black38,
                            fontSize: 16,
                            fontWeight: index == 1
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        index = 2;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      //height: 50,
                      width: cardWidth / 2,
                      decoration: BoxDecoration(
                        color: index == 2 ? myOrange : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            color: index == 2 ? Colors.white : Colors.black38,
                            fontSize: 16,
                            fontWeight: index == 2
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 700),
              height: index == 1 ? cardHeight - 220 : cardHeight,
              width: cardWidth,
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(20),
              ),
              child: AnimatedCrossFade(
                duration: Duration(milliseconds: 200),
                crossFadeState: index == 1
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: Login(
                  cardWidth: cardWidth,
                  cardHeight: cardHeight - 220,
                ),
                secondChild: Register(
                  cardWidth: cardWidth,
                  cardHeight: cardHeight,
                ),
              ),
            ),
          ],
        ),
      ),
      //),
    );
  }
}
