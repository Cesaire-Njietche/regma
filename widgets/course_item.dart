import 'package:flutter/material.dart';

import '../data/colors.dart';

class CourseItem extends StatelessWidget {
  final String id;
  final String title;
  final String url;
  final double price;
  final bool isLock;
  final bool paymentOptions;
  CourseItem(
      {@required this.id,
      @required this.title,
      @required this.url,
      @required this.price,
      @required this.paymentOptions,
      @required this.isLock});
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

    var fontSizeRegma = w >= 410 ? 16.0 : 14.0;
    return LayoutBuilder(
      builder: (ctx, constraint) {
        //print(constraint.maxHeight);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              height: constraint.maxHeight * 0.7,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    10,
                  ),
                  topRight: Radius.circular(
                    10,
                  ),
                ),
                child: Stack(
                  children: [
                    Opacity(
                      opacity: .9,
                      child: Hero(
                        transitionOnUserGestures: true,
                        tag: id,
                        child: FadeInImage(
                          placeholder: const AssetImage(
                              'assets/images/placeholder_course_regma.png'),
                          image: NetworkImage(url),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    if (isLock) //THis course is not bought yet
                      Positioned(
                        top: 5,
                        left: 5,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.85),
                              shape: BoxShape.circle),
                          child: Icon(
                            Icons.lock,
                            color: myOrange,
                            size: 20,
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 5),
              height: constraint.maxHeight * 0.15,
              alignment: Alignment.centerRight,
              child: FittedBox(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: fontSizeRegma,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                right: 5,
              ),
              alignment: Alignment.centerRight,
              height: constraint.maxHeight * 0.1,
              child: paymentOptions
                  ? FittedBox(
                      child: Text('€${price.toStringAsFixed(2)}',
                          style: TextStyle(
                              color: myOrange, fontSize: fontSizeRegma)),
                    )
                  : Text('Free',
                      style:
                          TextStyle(color: myOrange, fontSize: fontSizeRegma)),
            ),
          ],
        );
      },
    );
  }
}
