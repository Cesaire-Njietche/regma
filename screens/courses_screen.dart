import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/colors.dart';
import '../providers/cart_provider.dart';
import '../providers/courses_provider.dart';
import '../widgets/badge.dart';
import '../widgets/course_item.dart';
import 'cart_screen.dart';
import 'course_detail_screen.dart';

class CoursesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool paymentOptions =
        Provider.of<CoursesProvider>(context, listen: false).paymentOptions;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Courses',
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
            //Will add refresh indicator
            future: Provider.of<CoursesProvider>(context, listen: false)
                .fetchAllCourses(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('No Internet Connection'),
                );
              } else {
                return Consumer<CoursesProvider>(
                  builder: (context, _courses, _) {
                    var courses = _courses.courseItems;
                    var paymentOptions = _courses.paymentOptions;
                    // print(
                    //     '${_courses.courseItems.length} _courses.courseItems');
                    return GridView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(8.0),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 400,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                        childAspectRatio: 3 / 2,
                      ),
                      itemBuilder: (ctx, ind) {
                        var course = courses[ind];
                        return InkWell(
                          onTap: () {
                            // if (course.isLock)
                            //   Navigator.of(context).pushNamed(
                            //       CourseDetailScreen.routeName,
                            //       arguments: course.courseID);
                            // else
                            //   Navigator.of(context).pushNamed(
                            //       CourseLessonsScreen.routeName,
                            //       arguments: {
                            //         'id': course.courseID,
                            //         'isEditing': false
                            //       });
                            Navigator.of(context).pushNamed(
                                CourseDetailScreen.routeName,
                                arguments: course.courseID);
                          },
                          child: Card(
                            color: Colors.white.withOpacity(.8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: CourseItem(
                              id: course.courseID,
                              title: course.name,
                              url: course.thumbnailURL,
                              price: course.yearlyPrice,
                              isLock: course.isLock,
                              paymentOptions: paymentOptions,
                            ),
                          ),
                        );
                      },
                      itemCount: courses
                          .length, //When its 0, it will throw an exception
                    );
                  },
                );
              }
            },
          )
        ],
      ),
    );
  }
}
