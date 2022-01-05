import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/colors.dart';
import '../helpers/util.dart';
import '../providers/courses_provider.dart';
import '../screens/add_new_course_screen.dart';
import '../screens/course_lessons_screen.dart';

class ManageCoursesItem extends StatelessWidget {
  final String id;
  final String name;
  final String imageUrl;
  ManageCoursesItem(this.id, this.imageUrl, this.name);

  @override
  Widget build(BuildContext context) {
    var _style = GoogleFonts.quicksand(
      fontWeight: FontWeight.w600,
    );
    return Card(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed(CourseLessonsScreen.routeName, arguments: {
            'id': id,
            'isEditing': true,
          });
        },
        child: ListTile(
          leading: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: FadeInImage(
                placeholder: const AssetImage(
                    'assets/images/placeholder_course_regma.png'),
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            name,
            style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w500, fontSize: 15),
          ),
          subtitle: Text(''),
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
                          AddNewCourseScreen.routeName,
                          arguments: id);
                    }),
                Expanded(
                    child: DeleteButton(id: id, name: name, style: _style)),
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
            onPressed: () async {
              Util.rShowCupertinoDialog(
                "You are about to delete a course",
                "Deleted courses cannot be restored",
                () async {
                  setState(() {
                    isLoading = true;
                  });
                  await Provider.of<CoursesProvider>(context, listen: false)
                      .deleteCourseById(widget.id);
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
                                text: ' deleted successfully',
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
            },
          );
  }
}
