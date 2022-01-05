import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/colors.dart';
import '../providers/auth_service_provider.dart';
import '../providers/courses_provider.dart';
import '../widgets/center_no_history.dart';
import '../widgets/course_lessons_classroom_item.dart';
import '../widgets/course_lessons_item.dart';
import 'add_new_lesson_screen.dart';

class CourseLessonsScreen extends StatelessWidget {
  static String routeName = '/course-lessons-screen';

  //Show different screens for admin and user. For admin, a list. For user, a nice polished grid

  @override
  Widget build(BuildContext context) {
    var value =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    var course = Provider.of<CoursesProvider>(context, listen: false)
        .findCourseById(value['id']);
    var user = Provider.of<AuthServiceProvider>(context).user;
    var lessonCount = 0;
    var isEditing = value['isEditing'];
    //print(isEditing);
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
        title: Text(course.name),
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
                .findLessonsByCourseId(value['id']),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                // if (user == null) {
                //   print('OP');
                //   return Center(
                //     child: CircularProgressIndicator(),
                //   );
                // }
                if (isEditing) {
                  //View all lessons for a course and act accordingly
                  return Consumer<CoursesProvider>(
                    builder: (ctx, courses, _) => courses.lessonItems.length ==
                            0
                        ? CenterNoHistory('No Lesson Yet!')
                        : Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Text(
                                  'Lessons',
                                  style: GoogleFonts.quicksand(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 5),
                                  itemBuilder: (ctx, ind) {
                                    lessonCount = courses.lessonItems.length;
                                    var lesson = courses.lessonItems[ind];
                                    return CourseLessonsItem(
                                        lesson.lessonID, ind + 1, lesson.name);
                                  },
                                  itemCount: courses.lessonItems.length,
                                ),
                              ),
                            ],
                          ),
                  );
                } else {
                  return Consumer<CoursesProvider>(
                      builder: (ctx, courses, _) =>
                          courses.lessonItems.length == 0
                              ? CenterNoHistory('No Lesson Yet!')
                              : GridView.builder(
                                  padding: EdgeInsets.all(8.0),
                                  physics: BouncingScrollPhysics(),
                                  itemCount: courses.lessonItems.length,
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 400,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 3 / 2,
                                  ),
                                  itemBuilder: (ctx, ind) {
                                    var lesson = courses.lessonItems[ind];
                                    // print(courses.lastCompletedLesson + 1);
                                    // print(lesson.lessonCount);
                                    return CourseLessonsClassroomItem(
                                      id: lesson.lessonID,
                                      isLock: courses.lastCompletedLesson + 1 <
                                          lesson.lessonCount,
                                      lastCompletedLesson:
                                          courses.lastCompletedLesson,
                                    );
                                  },
                                ));
                }
              }
            },
          ),
        ],
      ),
      floatingActionButton: isEditing
          ? FloatingActionButton(
              onPressed: () => Navigator.of(context)
                  .pushNamed(AddNewLessonScreen.routeName, arguments: {
                'ID': value['id'],
                'lessonCount': lessonCount + 1,
                'adding': true
              }),
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
}
