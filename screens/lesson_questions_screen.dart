import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/colors.dart';
import '../providers/courses_provider.dart';
import '../screens/add_new_question_screen.dart';
import '../widgets/center_no_history.dart';
import '../widgets/lesson_questions_item.dart';

class LessonQuestionsScreen extends StatelessWidget {
  static String routeName = '/lesson-questions-screen';

  @override
  Widget build(BuildContext context) {
    var id = ModalRoute.of(context).settings.arguments as String;
    var lesson =
        Provider.of<CoursesProvider>(context, listen: false).findLessonById(id);

    var questionCount = 0;

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
        title: Text(lesson.name),
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
                .findQuestionsByLessonId(id),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Consumer<CoursesProvider>(
                  builder: (ctx, courses, _) =>
                      courses.questionItems.length == 0
                          ? CenterNoHistory('No Question Yet!')
                          : Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: Text(
                                    'Questions',
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
                                    itemCount: courses.questionItems.length,
                                    itemBuilder: (ctx, ind) {
                                      var question = courses.questionItems[ind];
                                      questionCount =
                                          courses.questionItems.length;

                                      return LessonQuestionsItem(
                                        question.questionID,
                                        ind + 1,
                                        question.content,
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                );
              }
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .pushNamed(AddNewQuestionScreen.routeName, arguments: {
          'ID': id,
          'questionCount': questionCount + 1,
          'adding': true
        }),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
