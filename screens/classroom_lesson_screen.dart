import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/colors.dart';
import '../models/lesson_model.dart';
import '../providers/courses_provider.dart';
import '../widgets/lesson_questions.dart';
import '../widgets/lesson_transcript.dart';

class ClassroomLessonScreen extends StatefulWidget {
  static String routeName = '/classroom-lesson-screen';

  @override
  _ClassroomLessonScreenState createState() => _ClassroomLessonScreenState();
}

class _ClassroomLessonScreenState extends State<ClassroomLessonScreen> {
  // Function(int, int, double) onSetAnswer; //length, index, answer;
  var val = <int>[];
  bool isFirst = true;
  void onSetAnswer(int length, int ind, int ans) {
    if (isFirst) {
      for (var i = 0; i < length; i++) {
        val.add(-1);
      }
      isFirst = false;
    }
    val[ind] = ans;
  }

  bool hasAnswered = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var value =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    var lesson = Provider.of<CoursesProvider>(context, listen: false)
        .findLessonById(value['id']);
    var lastCompletedLesson =
        value['lastCompletedLesson']; // Useful to show questions or not
    var screenHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
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
          Column(
            children: [
              // AspectRatio(
              //   aspectRatio: 16 / 9,
              //   child: BetterPlayer.network(
              //     lesson.videoURL,
              //     betterPlayerConfiguration: BetterPlayerConfiguration(
              //       autoDispose: true,
              //       aspectRatio: 16 / 9,
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 20,
              ),
              RichText(
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
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      text: '${lesson.name}',
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: TranscriptAndQuestion(
                  height: screenHeight,
                  lesson: lesson,
                  lastCompletedLesson: lastCompletedLesson,
                  onSetAnswer: (length, ind, ans) =>
                      onSetAnswer(length, ind, ans),
                  hasAnswered: hasAnswered,
                  isLoading: isLoading,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(),
            ],
          ),
        ],
      ),
      floatingActionButton:
          !hasAnswered && lastCompletedLesson < lesson.lessonCount
              ? FloatingActionButton(
                  mini: true,
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        )
                      : Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 20,
                        ),
                  onPressed: () async {
                    var isLessonNotCompleted =
                        val.isEmpty || val.any((element) => element == -1);

                    if (isLessonNotCompleted) {
                      //The student has not answered all the questions
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red.withOpacity(.7),
                        content: Text(
                          'Answer all the questions please',
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        duration: Duration(seconds: 3),
                      ));
                      return;
                    }

                    var score = 0.0;
                    var sum = 0;
                    var ra = 0;

                    val.forEach((element) {
                      sum += element;
                      if (element == 1) ra++;
                    });
                    score = sum / val.length;

                    print('score = $score');
                    setState(() {
                      isLoading = true;
                    });
                    await Provider.of<CoursesProvider>(context, listen: false)
                        .setLastCompletedLessonByCourseId(
                            lesson.courseID, lesson.lessonCount);
                    await Provider.of<CoursesProvider>(context, listen: false)
                        .setLessonScore(lesson.lessonID, score);
                    setState(() {
                      isLoading = false;
                      hasAnswered = true;
                    });
                    await AwesomeDialog(
                      context: context,
                      dialogType: DialogType.SUCCES,
                      body: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                                text: 'Total : ',
                                style: GoogleFonts.quicksand(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                      text: '${score.toStringAsFixed(2)}',
                                      style: GoogleFonts.quicksand(
                                          color: myOrange,
                                          fontWeight: FontWeight.bold))
                                ]),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          RichText(
                            text: TextSpan(
                                text: 'Right Answer : ',
                                style: GoogleFonts.quicksand(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                      text: '${ra}/${val.length}',
                                      style: GoogleFonts.quicksand(
                                          color: myOrange,
                                          fontWeight: FontWeight.bold))
                                ]),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          RichText(
                            text: TextSpan(
                                text: 'Wrong Answer : ',
                                style: GoogleFonts.quicksand(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                      text: '${val.length - ra}/${val.length}',
                                      style: GoogleFonts.quicksand(
                                          color: myOrange,
                                          fontWeight: FontWeight.bold))
                                ]),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                      btnOkColor: myOrange,
                      dismissOnTouchOutside: true,
                      btnOkOnPress: () => Navigator.of(context).pop(),
                    ).show();
                    //Send result to Firebase
                    //Set lastCompletedLesson
                    //Set result back to parent screen to pop up
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: myOrange.withOpacity(.8),
                      content: Text(
                        'Answer submitted successfully to your email',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      duration: Duration(seconds: 3),
                    ));

                    if (lesson.lessonCount == 50) {
                      //get all the 50 scores from the database

                      //send message(score and course name) to firebase firestore purchases/uid/courses_result/courseId

                      // **** Cloud Functions ****
                      //listen to changes on that path
                      //get the email associated with the uid
                      //send email with score and name

                    }
                  },
                )
              : null,
    );
  }
}

class TranscriptAndQuestion extends StatefulWidget {
  double height;
  LessonModel lesson;
  int lastCompletedLesson;
  Function(int, int, int) onSetAnswer;
  bool hasAnswered;
  bool isLoading;

  TranscriptAndQuestion({
    this.height,
    this.lesson,
    this.lastCompletedLesson,
    this.onSetAnswer,
    this.hasAnswered,
    this.isLoading,
  });
  @override
  _TranscriptAndQuestionState createState() => _TranscriptAndQuestionState();
}

class _TranscriptAndQuestionState extends State<TranscriptAndQuestion> {
  var index = 1;

  Widget _buildTabs() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              setState(() {
                index = 1;
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: index == 1
                    ? Border(
                        bottom: BorderSide(
                          width: 1,
                          color: myOrange,
                        ),
                      )
                    : null,
              ),
              child: Text(
                'Transcript',
                style: TextStyle(
                    color: index == 1 ? Colors.white : Colors.grey,
                    fontSize: 16),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              setState(() {
                index = 2;
              });
            },
            child: AnimatedContainer(
              alignment: Alignment.center,
              duration: Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                border: index == 2
                    ? Border(
                        bottom: BorderSide(
                          width: 1,
                          color: myOrange,
                        ),
                      )
                    : null,
              ),
              child: Text(
                'Questions',
                style: TextStyle(
                  color:
                      index == 2 ? Colors.white : Colors.grey.withOpacity(.7),
                  fontSize: 16,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    //index = widget.hasAnswered ? 1 : 2;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        color: Color(0Xff13232e),
      ),
      // height: widget.height * .7,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          children: [
            _buildTabs(),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: AnimatedCrossFade(
                firstChild: LessonTranscript(widget.lesson.content),
                secondChild: widget.isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : widget.lastCompletedLesson < widget.lesson.lessonCount &&
                            !widget.hasAnswered
                        ? LessonQuestions(
                            id: widget.lesson.lessonID,
                            onSetAnswer: (length, ind, ans) =>
                                widget.onSetAnswer(length, ind, ans),
                          )
                        : Center(
                            child: Text(
                              'Completed',
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ),
                duration: Duration(milliseconds: 200),
                crossFadeState: index == 1
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
