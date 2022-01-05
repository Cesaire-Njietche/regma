import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import '../data/colors.dart';

class StartScreenOne extends StatelessWidget {
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
                    myOrange,
                    myOrange,
                    myOrange,
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
              child: Circle(Size(screenWidth * .12, screenWidth * .12)),
              right: screenWidth * .28,
              top: screenHeight * .63,
            ),
            Positioned(
              child: Circle(Size(screenWidth / 1.2, screenWidth / 1.2)),
              left: -screenWidth * 0.25,
              top: screenHeight * 0.55,
            ),
            Positioned(
              child: Circle(Size(screenWidth / 2, screenWidth / 2)),
              right: -screenWidth * 0.25,
              bottom: screenHeight * 0.15,
            ),
            Positioned(
              child: Circle(Size(screenWidth * .09, screenWidth * .09)),
              right: screenWidth * .06,
              bottom: screenHeight * .08,
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
              height: 100,
              width: 100,
              child: Image.asset('assets/images/group1.png')),
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
                              TypewriterAnimatedText('LEARN'),
                            ],
                            totalRepeatCount: 20,
                          ),
                        ),
                      ),
                      Text(
                        'Learn the scriptures',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      FittedBox(
                        child: Text(
                          'Make one with the word of God',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        //constraints: BoxConstraints(
                        //  maxWidth: MediaQuery.of(context).size.width * 3 / 4),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'LEARN',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Learn the scriptures',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          Text(
                            'Make one with the word of God',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      ),

                      //constraints: BoxConstraints(
                      //  maxWidth: MediaQuery.of(context).size.width * 3 / 4),
                    ],
                  ),
          ),
          SizedBox(
            height: screenHeight * .2,
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
                    color: Colors.white,
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
                    color: Color.fromRGBO(65, 95, 119, 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          /*InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(StartScreenTwo.routeName);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Color.fromRGBO(65, 95, 119, 1),
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 32),
              child: Text(
                'GET STARTED',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
          ),*/
        ],
      ),
    );
  }
}

class Circle extends StatelessWidget {
  final Size size;

  Circle(this.size);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        /*gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromRGBO(253, 113, 78, 1).withOpacity(0.2),
              Color.fromRGBO(254, 148, 75, 1).withOpacity(0.6),
            ]),*/
        shape: BoxShape.circle,
        color: Color.fromRGBO(253, 113, 78, 0.56),
      ),
    );
  }
}
