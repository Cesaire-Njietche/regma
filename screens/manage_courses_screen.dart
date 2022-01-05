import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/colors.dart';
import '../providers/courses_provider.dart';
import '../screens/add_new_course_screen.dart';
import '../widgets/center_no_history.dart';
import '../widgets/manage_courses_item.dart';

class ManageCoursesScreen extends StatelessWidget {
  static String routeName = '/manage-course-screen';

  @override
  Widget build(BuildContext context) {
    var courses = Provider.of<CoursesProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: myOrange,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('All Courses'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: myOrange,
            ),
            onPressed: () =>
                Navigator.of(context).pushNamed(AddNewCourseScreen.routeName),
          )
        ],
      ),
      body: Stack(children: [
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
            future: courses.fetchAllCourses(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Consumer<CoursesProvider>(
                  builder: (ctx, courses, _) => courses.courseItems.length == 0
                      ? CenterNoHistory('No Course Yet!')
                      : ListView.builder(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 5,
                          ),
                          itemBuilder: (ctx, ind) {
                            var course = courses.courseItems[ind];
                            return ManageCoursesItem(course.courseID,
                                course.thumbnailURL, course.name);
                          },
                          itemCount: courses.courseItems.length,
                        ),
                );
              }
            })
      ]),
    );
  }
}
