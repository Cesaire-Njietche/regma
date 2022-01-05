import 'package:flutter/material.dart';

import '../screens/course_lessons_screen.dart';

class CourseClassRoomItem extends StatelessWidget {
  final String id;
  final String title;
  final String url;
  CourseClassRoomItem({
    this.id,
    this.title,
    this.url,
  });
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var fontSizeRegma = w >= 410 ? 16.0 : 15.0;

    return LayoutBuilder(
      builder: (ctx, constraint) => InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            CourseLessonsScreen.routeName,
            arguments: {
              'id': id,
              'isEditing': false,
            },
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FadeInImage(
                  placeholder: const AssetImage(
                      'assets/images/placeholder_course_regma.png'),
                  image: NetworkImage(url),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  //height: constraint.maxHeight,
                ),
              ),
              Positioned(
                bottom: constraint.maxHeight * .05,
                child: Container(
                  width: constraint.maxWidth,
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    width: constraint.maxWidth * .8,
                    child: Text(
                      title,
                      style: TextStyle(
                          fontSize: fontSizeRegma,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
