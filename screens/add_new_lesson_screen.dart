import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

import '../data/colors.dart';
import '../models/lesson_model.dart';
import '../providers/courses_provider.dart';
import 'lesson_questions_screen.dart';

class AddNewLessonScreen extends StatefulWidget {
  static String routeName = '/add-new_lesson';

  @override
  _AddNewLessonScreenState createState() => _AddNewLessonScreenState();
}

class _AddNewLessonScreenState extends State<AddNewLessonScreen> {
  bool isAdding = true;
  bool _isLoading = false;
  bool isInit = true;
  var _form = GlobalKey<FormState>();
  var formValues = {
    'name': '',
    'content': '',
    'videoURL': '',
  };
  var transcriptName = '';
  File pickedTranscript;
  File pickedVideo;
  var courseID = ''; //send courseID when creating a new lesson
  var lessonID = ''; //send lessonID when updating
  LessonModel lesson;
  var lessonCount = 0;

  Future<void> pickVideo() async {
    var _pickedVideo =
        await ImagePicker().getVideo(source: ImageSource.gallery);

    if (_pickedVideo == null) return;

    setState(() {
      pickedVideo = File(_pickedVideo.path);
    });
  }

  Future<void> pickTranscript() async {
    var _pickedFile = await FilePicker.platform.pickFiles(
      allowedExtensions: ['pdf', 'ppt', 'pptx'],
      type: FileType.custom,
    );

    if (_pickedFile == null) return;
    pickedTranscript = File(_pickedFile.files.single.path);

    setState(() {
      transcriptName = path.basename(_pickedFile.files.single.path);
    });
  }

  Future<void> saveLesson() async {
    var id = '';
    FocusScope.of(context).unfocus();
    if (_form.currentState.validate()) {
      // if (pickedVideo == null && isAdding) {
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     backgroundColor: Colors.red.withOpacity(0.85),
      //     content: Text(
      //       'Select a video for the lesson',
      //       style: GoogleFonts.quicksand(
      //         fontWeight: FontWeight.w600,
      //         fontSize: 15,
      //       ),
      //     ),
      //     duration: Duration(seconds: 3),
      //   ));
      //   return; //Message to prompt the user to enter an image
      // }
      if (pickedTranscript == null && isAdding) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red.withOpacity(0.85),
          content: Text(
            'Pick a transcript for the lesson',
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          duration: Duration(seconds: 3),
        ));
        return; //Message to prompt the user to enter an image
      }
      _form.currentState.save();
      setState(() {
        _isLoading = true;
      });

      var _lesson = LessonModel(
        lessonID: isAdding ? id : lessonID,
        courseID: isAdding ? courseID : lesson.courseID,
        content: formValues['content'],
        name: formValues['name'],
        videoURL: formValues['videoURL'],
        lessonCount: isAdding ? lessonCount : lesson.lessonCount,
      );

      id = await Provider.of<CoursesProvider>(context, listen: false)
          .addNewLesson(_lesson, pickedTranscript, isAdding);

      var con = await showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(
              isAdding
                  ? 'Lesson successfully created'
                  : 'Lesson successfully updated',
              style: GoogleFonts.quicksand(),
            ),
            content: Text(
              'Click on Continue to add questions',
              style: GoogleFonts.quicksand(),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  "Continue",
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  "Cancel",
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          );
        },
      );
      if (con)
        Navigator.of(context).pushReplacementNamed(
            LessonQuestionsScreen.routeName,
            arguments: id);
      else
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
          courseID = value['ID'];
          lessonCount = value['lessonCount'];
        } else {
          isAdding = false;
          lessonID = value['ID'];
          lesson = Provider.of<CoursesProvider>(context, listen: false)
              .findLessonById(lessonID);
          formValues = {
            'name': lesson.name,
            'content': lesson.content,
            'videoURL': lesson.videoURL,
          };
        }
      }
    }
    isInit = false;
    super.didChangeDependencies();
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
            ? 'Add Lesson $lessonCount'
            : 'Edit Lesson ${lesson.lessonCount}'),
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
                  onPressed: saveLesson,
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
          Form(
            key: _form,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      initialValue: formValues['name'],
                      decoration: InputDecoration(labelText: "Lesson Name"),
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                      onSaved: (val) {
                        formValues['name'] = val;
                      },
                      validator: (val) {
                        if (val.isEmpty)
                          return 'Enter a name';
                        else
                          return null;
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    // if (isAdding)
                    //   pickedVideo == null
                    //       ? Container(
                    //           width: 200,
                    //           height: 200,
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(10),
                    //           ),
                    //           child: ClipRRect(
                    //             borderRadius: BorderRadius.circular(10),
                    //             child: Image.asset(
                    //               'assets/images/placeholder_course_regma.png',
                    //               fit: BoxFit.cover,
                    //             ),
                    //           ))
                    //       : AspectRatio(
                    //           aspectRatio: 16 / 9,
                    //           child: BetterPlayer.file(
                    //             pickedVideo.path,
                    //             betterPlayerConfiguration:
                    //                 BetterPlayerConfiguration(
                    //               autoDispose: true,
                    //               fit: BoxFit.cover,
                    //               aspectRatio: 16 / 9,
                    //             ),
                    //           ),
                    //         ),
                    // if (!isAdding)
                    //   pickedVideo == null
                    //       ? AspectRatio(
                    //           aspectRatio: 16 / 9,
                    //           child: BetterPlayer.network(
                    //             formValues['videoURL'],
                    //             betterPlayerConfiguration:
                    //                 BetterPlayerConfiguration(
                    //               autoDispose: true,
                    //               aspectRatio: 16 / 9,
                    //               fit: BoxFit.cover,
                    //             ),
                    //           ),
                    //         )
                    //       : AspectRatio(
                    //           aspectRatio: 16 / 9,
                    //           child: BetterPlayer.file(
                    //             pickedVideo.path,
                    //             betterPlayerConfiguration:
                    //                 BetterPlayerConfiguration(
                    //               autoDispose: true,
                    //               aspectRatio: 16 / 9,
                    //               fit: BoxFit.cover,
                    //             ),
                    //           ),
                    //         ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // TextButton.icon(
                    //   label: Text(
                    //     'Lesson Video',
                    //     style: GoogleFonts.quicksand(
                    //       fontWeight: FontWeight.w600,
                    //       fontSize: 15,
                    //     ),
                    //   ),
                    //   icon: Icon(
                    //     Icons.video_library,
                    //     color: myOrange,
                    //   ),
                    //   onPressed: pickVideo,
                    // ), //
                    // SizedBox(
                    //   height: 20,
                    // ), // Image picker to p
                    if (isAdding)
                      pickedTranscript == null
                          ? Container(
                              child: Center(
                                child: Text('No Transcript Picked',
                                    style: TextStyle(
                                      fontSize: 15,
                                    )),
                              ),
                            )
                          : Container(
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Lesson Transcript: ',
                                    style: GoogleFonts.quicksand(
                                        color: myOrange,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                    children: [
                                      TextSpan(
                                        text: transcriptName,
                                        style: GoogleFonts.quicksand(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    if (!isAdding)
                      pickedTranscript != null
                          ? Container(
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Lesson Transcript: ',
                                    style: GoogleFonts.quicksand(
                                        color: myOrange,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                    children: [
                                      TextSpan(
                                        text: transcriptName,
                                        style: GoogleFonts.quicksand(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              child: Center(
                                  child: Text(
                                      'Your transcript is on file. You can still change it.',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ))),
                            ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton.icon(
                      label: Text(
                        isAdding ? 'Add Transcript' : 'Change Transcript',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      icon: Icon(
                        Icons.book,
                        color: myOrange,
                      ),
                      onPressed: pickTranscript,
                    ), //
                    // TextFormField(
                    //   initialValue: formValues['content'],
                    //   maxLines: null,
                    //   style: GoogleFonts.quicksand(
                    //     fontWeight: FontWeight.w600,
                    //     fontSize: 15,
                    //   ),
                    //   decoration: InputDecoration(
                    //     labelText: "Content",
                    //   ),
                    //   onSaved: (val) {
                    //     formValues['content'] = val;
                    //   },
                    //   validator: (val) {
                    //     if (val.isEmpty)
                    //       return 'Enter transcript for the lesson';
                    //     else
                    //       return null;
                    //   },
                    // ),
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
