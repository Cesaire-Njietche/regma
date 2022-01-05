import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/question_model.dart';
import '../providers/courses_provider.dart';
import '../widgets/question_classroom.dart';

class LessonQuestions extends StatelessWidget {
  String id;
  Function(int, int, int) onSetAnswer; //length, index, answer;
  //double h;
  LessonQuestions({
    this.id,
    this.onSetAnswer,
  });

  @override
  Widget build(BuildContext context) {
    List<QuestionModel> result;

    return FutureBuilder(
        future: Provider.of<CoursesProvider>(context, listen: false)
            .findQuestionsByLessonId(id),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          else {
            result = snapshot.data;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: result.length,
                    itemBuilder: (ctx, ind) {
                      var question = result[ind];
                      return Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              question.content,
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 15),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            QuestionClassroom(
                              qId: question.questionID,
                              onSetRightAnswer: (answer) {
                                onSetAnswer(result.length, ind, answer);
                              },
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        });
  }
}
