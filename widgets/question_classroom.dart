import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/answer_model.dart';
import '../providers/courses_provider.dart';

class QuestionClassroom extends StatefulWidget {
  String qId;
  Function(int) onSetRightAnswer;
  QuestionClassroom({this.qId, this.onSetRightAnswer});

  @override
  _QuestionClassroomState createState() => _QuestionClassroomState();
}

class _QuestionClassroomState extends State<QuestionClassroom> {
  var answers = <AnswerModel>[];
  int isAnswer = 4;
  bool isRightAnswer;
  bool _isLoading = false;

  void setIsAnswer(int val, bool ans) {
    setState(() {
      isAnswer = val;
      // print('$ans ---');
      isRightAnswer = ans;
    });
    widget.onSetRightAnswer(isRightAnswer ? 1 : 0);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _isLoading = true;
    Provider.of<CoursesProvider>(context, listen: false)
        .findAnswersByQuestionId(widget.qId)
        .then((value) {
      answers = value;
      setState(() {
        _isLoading = false;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Radio(
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white70),
                        value: 0,
                        groupValue: isAnswer,
                        onChanged: (val) {
                          setIsAnswer(val, answers[0].isRightAnswer);
                        }),
                    Expanded(
                      child: Text(
                        answers[0].content,
                        style: TextStyle(color: Colors.white70, fontSize: 15),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Radio(
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white70),
                        value: 1,
                        groupValue: isAnswer,
                        onChanged: (val) {
                          setIsAnswer(val, answers[1].isRightAnswer);
                        }),
                    Expanded(
                      child: Text(
                        answers[1].content,
                        style: TextStyle(color: Colors.white70, fontSize: 15),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Radio(
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white70),
                        value: 2,
                        groupValue: isAnswer,
                        onChanged: (val) {
                          setIsAnswer(val, answers[2].isRightAnswer);
                        }),
                    Expanded(
                      child: Text(
                        answers[2].content,
                        style: TextStyle(color: Colors.white70, fontSize: 15),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
  }
}
