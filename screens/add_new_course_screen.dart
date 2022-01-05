import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../data/colors.dart';
import '../models/course_model.dart';
import '../providers/courses_provider.dart';
import 'course_lessons_screen.dart';

class AddNewCourseScreen extends StatefulWidget {
  static String routeName = '/add-new-course';

  @override
  _AddNewCourseScreenState createState() => _AddNewCourseScreenState();
}

class _AddNewCourseScreenState extends State<AddNewCourseScreen> {
  final _form = GlobalKey<FormState>();
  var formValues = {
    'courseID': '',
    'name': '',
    'description': '',
    'imageUrl': '',
    'minAge': '',
    'maxAge': '',
    'mPrice': '',
    'yPrice': '',
  };
  File pickedImage;
  bool _isLoading = false;
  String courseId;
  bool isInit = true;
  bool isAdding = true;

  Future<void> pickImage() async {
    final _pickedImage = await ImagePicker().getImage(
      source: ImageSource.gallery, //change this to gallery on production mode
    );

    if (_pickedImage == null) return;

    setState(() {
      pickedImage = File(_pickedImage.path);
    });
  }

  Future<void> saveCourse() async {
    var id = '';
    FocusScope.of(context).unfocus();
    if (_form.currentState.validate()) {
      if (pickedImage == null && isAdding) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red.withOpacity(0.85),
          content: Text(
            'Select an image for the course',
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
      var course = CourseModel(
        courseID: formValues['courseID'],
        name: formValues['name'],
        thumbnailURL: formValues['imageUrl'],
        description: formValues['description'],
        monthlyPrice: double.parse(formValues['mPrice']),
        minUserAge: int.parse(formValues['minAge']),
        maxUserAge: int.parse(formValues['maxAge']),
        isLock: true,
        yearlyPrice: formValues['yPrice'] == ''
            ? 0.0
            : double.parse(formValues['yPrice']),
      );

      if (isAdding)
        id = await Provider.of<CoursesProvider>(context, listen: false)
            .addNewCourse(course, pickedImage, true);
      else
        id = await Provider.of<CoursesProvider>(context, listen: false)
            .addNewCourse(course, pickedImage, false);

      var con = await showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(
              isAdding
                  ? 'Course successfully created'
                  : 'Course successfully updated',
              style: GoogleFonts.quicksand(),
            ),
            content: Text(
              'Click on Continue to add lessons',
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
        Navigator.of(context)
            .pushReplacementNamed(CourseLessonsScreen.routeName, arguments: {
          'id': formValues['courseID'],
          'isEditing': true,
        });
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
        courseId = ModalRoute.of(context).settings.arguments as String;
        isAdding = false;
        var course = Provider.of<CoursesProvider>(context, listen: false)
            .findCourseById(courseId);
        formValues = {
          'courseID': course.courseID,
          'name': course.name,
          'description': course.description,
          'imageUrl': course.thumbnailURL,
          'minAge': course.minUserAge.toString(),
          'maxAge': course.maxUserAge.toString(),
          'mPrice': course.monthlyPrice.toString(),
          'yPrice': course.yearlyPrice.toString(),
        };
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

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
          title: Text(isAdding ? 'Add New Course' : 'Edit Course'),
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
                    onPressed: saveCourse,
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
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (isAdding)
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: pickedImage == null
                                    ? Image.asset(
                                        'assets/images/placeholder_course_regma.png',
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        pickedImage,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          if (!isAdding)
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: pickedImage == null
                                    ? Image.network(
                                        formValues['imageUrl'],
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        pickedImage,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          SizedBox(
                            width: 10,
                          ),
                          TextButton.icon(
                            label: Text(
                              'Course image',
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            icon: Icon(
                              Icons.photo,
                              color: myOrange,
                            ),
                            onPressed: pickImage,
                          ), //Image picker to pick an image in the gallery and upload it to FirebaseFirestore
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if (isAdding)
                        TextFormField(
                          initialValue: formValues['courseID'],
                          decoration: InputDecoration(labelText: "Course ID"),
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                          onSaved: (val) {
                            formValues['courseID'] = val;
                          },
                          validator: (val) {
                            if (val.isEmpty)
                              return 'Enter the course ID';
                            else
                              return null;
                          },
                        ),
                      if (isAdding)
                        SizedBox(
                          height: 10,
                        ),
                      TextFormField(
                        initialValue: formValues['name'],
                        decoration: InputDecoration(labelText: "Course Name"),
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
                        height: 10,
                      ),
                      TextFormField(
                        initialValue: formValues['description'],
                        maxLines: null,
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(labelText: "Description"),
                        onSaved: (val) {
                          formValues['description'] = val;
                        },
                        validator: (val) {
                          if (val.isEmpty)
                            return 'Enter a description';
                          else
                            return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              initialValue: formValues['minAge'],
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                              decoration: InputDecoration(
                                  labelText: "Min Participant Age"),
                              onSaved: (val) {
                                formValues['minAge'] = val;
                              },
                              validator: (val) {
                                var ma = int.tryParse(val);
                                if (ma == null)
                                  return 'Enter valid age';
                                else
                                  return null;
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              initialValue: formValues['maxAge'],
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                              onSaved: (val) {
                                formValues['maxAge'] = val;
                              },
                              validator: (val) {
                                var ma = int.tryParse(val);
                                if (ma == null)
                                  return 'Enter valid age';
                                else
                                  return null;
                              },
                              decoration: InputDecoration(
                                  labelText: "Max Participant Age"),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        keyboardType: TextInputType.number,
                        initialValue: formValues['mPrice'],
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(labelText: "Monthly price"),
                        onSaved: (val) {
                          formValues['mPrice'] = val;
                        },
                        validator: (val) {
                          var mp = double.tryParse(val);
                          if (mp == null)
                            return 'Enter monthly price';
                          else
                            return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        initialValue: formValues['yPrice'],
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(labelText: "Yearly price"),
                        onSaved: (val) {
                          formValues['yPrice'] = val;
                        },
                        validator: (val) {
                          var yp = double.tryParse(val);
                          if (yp == null)
                            return 'Enter yearly price';
                          else
                            return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
