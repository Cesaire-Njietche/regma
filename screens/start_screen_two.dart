import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/colors.dart';
import 'login_signup_screen.dart';

class StartScreenTwo extends StatelessWidget {
  static final String routeName = '/start-screen-two';
  @override
  Widget build(BuildContext context) {
    var screenHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    var screenWidth = MediaQuery.of(context).size.width;
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    // print(screenWidth);
    // print(screenHeight);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(252, 80, 80, 1),
                    Color.fromRGBO(252, 80, 80, 1),
                    //Color.fromRGBO(252, 80, 80, 1),
                    myOrange,
                    //myOrange,
                    //myOrange,
                    Color.fromRGBO(255, 186, 73, 1),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: screenHeight * .03,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Colors.white10.withOpacity(0.05),
                      Colors.white54.withOpacity(0.4),
                    ])),
              ),
            ),
            Positioned(
              child: Circle(
                size: Size(screenWidth * .25, screenWidth * .25),
                hasGradient: true,
                inv: false,
              ),
              right: -screenWidth * .05,
              top: -screenHeight * .05,
            ),
            Positioned(
              child: Circle(
                size: Size(screenWidth * 1.5, screenWidth * 1.5),
                hasGradient: false,
              ),
              left: -screenWidth * .1,
              right: -screenWidth * .1,
              bottom: -screenWidth * .9,
            ),
            Positioned(
              child: Circle(
                size: Size(screenWidth / 3.7, screenWidth / 3.7),
                hasGradient: true,
                inv: true,
              ),
              left: -screenWidth * 0.06,
              bottom: screenHeight * 0.5,
            ),
            Positioned(
              child: Circle(
                size: Size(screenWidth * .1, screenWidth * .1),
                hasGradient: false,
              ),
              right: screenWidth * .15,
              bottom: screenHeight * .35,
            ),
            Learn(screenHeight, screenWidth, isPortrait),
          ],
        ),
      ),
    );
  }
}

class Learn extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final bool isPortrait;

  Learn(this.screenHeight, this.screenWidth, this.isPortrait);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: screenHeight * .1,
          ),
          Container(
              height: 90,
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/group2.png'),
                  Image.asset('assets/images/group3.png'),
                ],
              )),
          SizedBox(
            height: screenHeight * 0.1,
          ),
          Container(
            height: screenHeight * .2,
            child: isPortrait
                ? Column(
                    children: [
                      Expanded(
                        child: DefaultTextStyle(
                          style: Theme.of(context).textTheme.bodyText1,
                          child: AnimatedTextKit(
                            animatedTexts: [
                              TyperAnimatedText('FUN'),
                            ],
                            totalRepeatCount: 20,
                          ),
                        ),
                      ),
                      Text(
                        'Express yourself',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      Text(
                        'Chat with your friends',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      //constraints: BoxConstraints(
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'FUN',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Express yourself',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          Text(
                            'Chat with your friends',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      ),

                      //constraints: BoxConstraints(
                    ],
                  ),
          ),
          SizedBox(
            height: isPortrait ? screenHeight * .2 : screenHeight * .1,
          ),
          Container(
            height: screenHeight * .03,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 7,
                  width: 15,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(65, 95, 119, 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.03,
                ),
                Container(
                  height: 7,
                  width: 15,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      )),
                ),
              ],
            ),
          ),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(LoginSignUpScreen.routeName);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Color.fromRGBO(65, 95, 119, 1),
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 32),
              child: Text(
                'GET STARTED',
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  //fontFamily: 'Quicksand',
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Circle extends StatelessWidget {
  final Size size;
  final bool hasGradient;
  final bool inv;

  Circle({@required this.size, this.hasGradient, this.inv});
  @override
  Widget build(BuildContext context) {
    Color color = Color.fromRGBO(253, 113, 78, 1);
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        gradient: !hasGradient
            ? null
            : inv
                ? LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      color,
                      color.withOpacity(0.02),
                      color.withOpacity(0.02),
                    ],
                  )
                : LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      color.withOpacity(0.2),
                      color,
                      color,
                    ],
                  ),
        shape: BoxShape.circle,
        color: hasGradient ? null : Color.fromRGBO(253, 113, 78, 0.56),
      ),
    );
  }
}
