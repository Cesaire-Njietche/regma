import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/colors.dart';
import '../models/answer_model.dart';
import '../models/question_model.dart';
import '../providers/courses_provider.dart';

class AddNewQuestionScreen extends StatefulWidget {
  static String routeName = '/add-new-question-screen';

  @override
  _AddNewQuestionScreenState createState() => _AddNewQuestionScreenState();
}

class _AddNewQuestionScreenState extends State<AddNewQuestionScreen> {
  bool isAdding = true;
  bool isInit = true;
  bool _isLoading = false;
  bool _isEditing = false;
  QuestionModel question;
  String lessonID;
  String questionID;
  int isRightAnswer;
  var _form = GlobalKey<FormState>();
  Map<String, AnswerModel> formValues = {};
  String questionContent;
  String answer1;
  String answer2;
  String answer3;
  int questionCount = 1;

  Future<void> saveQuestion() async {
    var id = '';
    FocusScope.of(context).unfocus();
    if (_form.currentState.validate()) {
      _form.currentState.save();
      setState(() {
        _isLoading = true;
      });

      var _question = QuestionModel(
        questionID: isAdding ? id : questionID,
        lessonID: isAdding ? lessonID : question.lessonID,
        content: questionContent,
        questionCount: isAdding ? questionCount : question.questionCount,
      );

      id = await Provider.of<CoursesProvider>(context, listen: false)
          .addNewQuestion(_question, isAdding);
      var _answer = AnswerModel(
        answerID: isAdding ? id : formValues['answer1'].answerID,
        questionID: isAdding ? id : formValues['answer1'].questionID,
        content: answer1,
        isRightAnswer: isRightAnswer == 0,
      );
      await Provider.of<CoursesProvider>(context, listen: false)
          .addNewAnswer(_answer, isAdding);

      _answer = AnswerModel(
        answerID: isAdding ? id : formValues['answer2'].answerID,
        questionID: isAdding ? id : formValues['answer2'].questionID,
        content: answer2,
        isRightAnswer: isRightAnswer == 1,
      );
      await Provider.of<CoursesProvider>(context, listen: false)
          .addNewAnswer(_answer, isAdding);

      _answer = AnswerModel(
        answerID: isAdding ? id : formValues['answer3'].answerID,
        questionID: isAdding ? id : formValues['answer3'].questionID,
        content: answer3,
        isRightAnswer: isRightAnswer == 2,
      );
      await Provider.of<CoursesProvider>(context, listen: false)
          .addNewAnswer(_answer, isAdding);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: myOrange.withOpacity(0.9),
        content: Text(
          isAdding
              ? 'Question added successfully'
              : 'Question updated successfully',
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        duration: Duration(seconds: 3),
      ));
      Navigator.of(context).pop();

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      if (ModalRoute.of(context).settings.arguments != null) {
        var value =
            ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

        if (value['adding'] == true) {
          isAdding = true;
          lessonID = value['ID'];
          questionCount = value['questionCount'];
          isRightAnswer = 0;
        } else {
          isAdding = false;
          questionID = value['ID'];
          question = Provider.of<CoursesProvider>(context, listen: false)
              .findQuestionById(questionID);
          questionContent = question.content;
          _isEditing = true;
          Provider.of<CoursesProvider>(context)
              .findAnswersByQuestionId(questionID)
              .then((answers) {
            formValues = {
              'answer1': answers[0],
              'answer2': answers[1],
              'answer3': answers[2],
            };
            answer1 = answers[0].content;
            answer2 = answers[1].content;
            answer3 = answers[2].content;
            isRightAnswer =
                answers.indexWhere((answer) => answer.isRightAnswer);
            setState(() {
              _isEditing = false;
            });
          });
        }
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  void setIsRightAnswer(val) {
    setState(() {
      isRightAnswer = val;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text(isAdding
            ? 'Add Question $questionCount'
            : 'Edit Question ${question.questionCount}'),
        actions: [
          _isLoading
              ? Padding(
                  padding: const EdgeInsets.only(
                    right: 10,
                  ),
                  child: Center(child: CircularProgressIndicator()),
                )
              : IconButton(
                  icon: Icon(
                    Icons.save,
                    color: myOrange,
                  ),
                  onPressed: saveQuestion,
                )
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
          _isEditing
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Form(
                  key: _form,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            initialValue: questionContent,
                            decoration: InputDecoration(labelText: "Question"),
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                            onSaved: (val) {
                              questionContent = val;
                            },
                            validator: (val) {
                              if (val.isEmpty)
                                return 'Enter a question';
                              else
                                return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Radio(
                                  value: 0,
                                  groupValue: isRightAnswer,
                                  onChanged: (val) {
                                    setIsRightAnswer(val);
                                  }),
                              Expanded(
                                child: TextFormField(
                                  initialValue: answer1,
                                  decoration:
                                      InputDecoration(labelText: "Answer 1"),
                                  style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                  onSaved: (val) {
                                    answer1 = val;
                                  },
                                  validator: (val) {
                                    if (val.isEmpty)
                                      return 'Enter an answer';
                                    else
                                      return null;
                                  },
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
                                  value: 1,
                                  groupValue: isRightAnswer,
                                  onChanged: (val) {
                                    setIsRightAnswer(val);
                                  }),
                              Expanded(
                                child: TextFormField(
                                  initialValue: answer2,
                                  decoration:
                                      InputDecoration(labelText: "Answer 2"),
                                  style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                  onSaved: (val) {
                                    answer2 = val;
                                  },
                                  validator: (val) {
                                    if (val.isEmpty)
                                      return 'Enter an answer';
                                    else
                                      return null;
                                  },
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
                                  value: 2,
                                  groupValue: isRightAnswer,
                                  onChanged: (val) {
                                    setIsRightAnswer(val);
                                  }),
                              Expanded(
                                child: TextFormField(
                                  initialValue: answer3,
                                  decoration:
                                      InputDecoration(labelText: "Answer 3"),
                                  style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                  onSaved: (val) {
                                    answer3 = val;
                                  },
                                  validator: (val) {
                                    if (val.isEmpty)
                                      return 'Enter an answer';
                                    else
                                      return null;
                                  },
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
