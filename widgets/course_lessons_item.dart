import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/colors.dart';
import '../helpers/util.dart';
import '../providers/courses_provider.dart';
import '../screens/add_new_lesson_screen.dart';
import '../screens/lesson_questions_screen.dart';

class CourseLessonsItem extends StatelessWidget {
  String id;
  int ind;
  String name;
  CourseLessonsItem(this.id, this.ind, this.name);

  @override
  Widget build(BuildContext context) {
    var _style = GoogleFonts.quicksand(
      fontWeight: FontWeight.w600,
    );
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed(LessonQuestionsScreen.routeName, arguments: id);
        },
        child: ListTile(
          leading: CircleAvatar(
            radius: 15,
            backgroundColor: myOrange,
            child: Text(
              '$ind',
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          title: Text(
            name,
            style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w500, fontSize: 15),
          ),
          trailing: Container(
            width: 100,
            child: Row(
              children: [
                IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: myOrange,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                          AddNewLessonScreen.routeName,
                          arguments: {'ID': id, 'adding': false});
                    }),
                Expanded(child: DeleteButton(id: id, name: name, style: _style)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DeleteButton extends StatefulWidget {
  const DeleteButton({
    Key key,
    @required this.id,
    @required this.name,
    @required TextStyle style,
  })  : _style = style,
        super(key: key);

  final String id;
  final String name;
  final TextStyle _style;

  @override
  _DeleteButtonState createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : IconButton(
            icon: Icon(
              Icons.delete,
              color: myOrange,
            ),
            onPressed: () {
              Util.rShowCupertinoDialog(
                "You are about to delete a lesson",
                "Deleted lessons cannot be restored",
                () async {
                  setState(() {
                    isLoading = true;
                  });
                  await Provider.of<CoursesProvider>(context, listen: false)
                      .deleteLessonById(widget.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: RichText(
                        text: TextSpan(
                            text: widget.name,
                            style: GoogleFonts.quicksand(
                              color: myOrange,
                            ),
                            children: [
                              TextSpan(
                                style: GoogleFonts.quicksand(
                                  color: Colors.white,
                                ),
                                text: ' successfully deleted',
                              )
                            ]),
                      ),
                      duration: Duration(seconds: 3),
                    ),
                  );
                },
                context,
                widget._style,
              );
            });
  }
}
