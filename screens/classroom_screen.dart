import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/colors.dart';
import '../providers/cart_provider.dart';
import '../providers/courses_provider.dart';
import '../widgets/badge.dart';
import '../widgets/center_no_history.dart';
import '../widgets/course_classroom_item.dart';
import 'cart_screen.dart';

class ClassroomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool paymentOptions =
        Provider.of<CoursesProvider>(context, listen: false).paymentOptions;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'My Classroom',
          ),
          actions: [
            paymentOptions
                ? Consumer<CartProvider>(
                    builder: (_, cart, ch) => Badge(
                      child: ch,
                      value: '${cart.count()}',
                      color: Colors.lime.shade300,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                        color: myOrange,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(CartScreen.routeName);
                      },
                    ),
                  )
                : Container(),
          ],
        ),
        body: Stack(
          children: [
            Container(
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
            ),
            FutureBuilder(
                future: Provider.of<CoursesProvider>(context, listen: false)
                    .fetchBoughtCourses(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  var courses = snapshot.data;
                  return courses.length == 0
                      ? CenterNoHistory(
                          'You Have Not Enrolled To Any Course Yet ...')
                      : GridView.builder(
                          padding: EdgeInsets.all(8.0),
                          physics: BouncingScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 400,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                            childAspectRatio: 3 / 2,
                          ),
                          itemBuilder: (ctx, ind) {
                            var course = courses[ind];
                            return CourseClassRoomItem(
                              id: course.courseID,
                              url: course.thumbnailURL,
                              title: course.name,
                            );
                          },
                          itemCount: courses.length,
                        );
                }),
          ],
        ));
  }
}
