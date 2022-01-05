import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/colors.dart';
import '../providers/courses_provider.dart';
import '../screens/classroom_lesson_screen.dart';

class CourseLessonsClassroomItem extends StatelessWidget {
  bool isLock; //locked when it is >= than lastCompletedLesson + 1
  String id;
  int lastCompletedLesson;
  CourseLessonsClassroomItem({
    this.id,
    this.isLock,
    this.lastCompletedLesson,
  });

  Widget build(BuildContext context) {
    var lesson =
        Provider.of<CoursesProvider>(context, listen: false).findLessonById(id);
    var course = Provider.of<CoursesProvider>(context, listen: false)
        .findCourseById(lesson.courseID);
    // return FutureBuilder(
    //     future:
    //         VideoThumbnail.thumbnailData(video: lesson.videoURL, quality: 25),
    //     builder: (ctx, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting)
    //         return Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       else
    //         return LayoutBuilder(
    //           builder: (ctx, constraint) => InkWell(
    //             onTap: isLock
    //                 ? null
    //                 : () {
    //                     Navigator.of(context).pushNamed(
    //                         ClassroomLessonScreen.routeName,
    //                         arguments: {
    //                           'id': id,
    //                           'lastCompletedLesson': lastCompletedLesson
    //                         });
    //                   },
    //             child: Stack(children: [
    //               ClipRRect(
    //                 borderRadius: BorderRadius.circular(12),
    //                 child: Image.memory(
    //                   snapshot.data,
    //                   fit: BoxFit.cover,
    //                   width: double.infinity,
    //                   height: constraint.maxHeight,
    //                 ),
    //               ),
    //               if (isLock) //Lock this lesson until the previous ones are completed
    //                 Positioned(
    //                   top: 5,
    //                   left: 5,
    //                   child: Container(
    //                     padding: EdgeInsets.all(5),
    //                     decoration: BoxDecoration(
    //                         color: Colors.white.withOpacity(.85),
    //                         shape: BoxShape.circle),
    //                     child: Icon(
    //                       Icons.lock,
    //                       color: myOrange,
    //                       size: 20,
    //                     ),
    //                   ),
    //                 ),
    //               Positioned(
    //                   bottom: constraint.maxHeight * .1,
    //                   right: constraint.maxWidth * .075,
    //                   child: Container(
    //                     alignment: Alignment.center,
    //                     width: constraint.maxWidth * .75,
    //                     decoration: BoxDecoration(
    //                       borderRadius: BorderRadius.circular(5),
    //                       color: Colors.black54,
    //                     ),
    //                     child: RichText(
    //                       text: TextSpan(
    //                         text: 'Lesson ${lesson.lessonCount}: ',
    //                         style: GoogleFonts.quicksand(
    //                           fontWeight: FontWeight.bold,
    //                           fontSize: 16,
    //                           color: myOrange,
    //                         ),
    //                         children: [
    //                           TextSpan(
    //                             style: GoogleFonts.quicksand(
    //                               color: Colors.white,
    //                               fontWeight: FontWeight.bold,
    //                               fontSize: 15,
    //                             ),
    //                             text: '${lesson.name}',
    //                           )
    //                         ],
    //                       ),
    //                     ),
    //                   ))
    //             ]),
    //           ),
    //         );
    //     });

    return LayoutBuilder(
      builder: (ctx, constraint) => InkWell(
        onTap: isLock
            ? null
            : () {
                Navigator.of(context).pushNamed(ClassroomLessonScreen.routeName,
                    arguments: {
                      'id': id,
                      'lastCompletedLesson': lastCompletedLesson
                    });
              },
        child: Stack(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FadeInImage(
              placeholder: const AssetImage(
                  'assets/images/placeholder_course_regma.png'),
              image: NetworkImage(course.thumbnailURL),
              fit: BoxFit.cover,
              width: double.infinity,
              height: constraint.maxHeight,
            ),
          ),
          if (isLock) //Lock this lesson until the previous ones are completed
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
            ),
          Positioned(
              bottom: constraint.maxHeight * .1,
              right: constraint.maxWidth * .075,
              child: Container(
                alignment: Alignment.center,
                width: constraint.maxWidth * .75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black54,
                ),
                child: RichText(
                  text: TextSpan(
                    text: 'Lesson ${lesson.lessonCount}: ',
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: myOrange,
                    ),
                    children: [
                      TextSpan(
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        text: '${lesson.name}',
                      )
                    ],
                  ),
                ),
              ))
        ]),
      ),
    );
  }
}
