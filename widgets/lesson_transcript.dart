import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/colors.dart';
import '../providers/media_provider.dart';

class LessonTranscript extends StatelessWidget {
  String content;
  LessonTranscript(this.content);

  @override
  Widget build(BuildContext context) {
    print(content);
    return Container(
        child: OpenButton(
      content: content,
    ));
  }
}

class OpenButton extends StatefulWidget {
  const OpenButton({
    Key key,
    @required this.content,
  }) : super(key: key);

  final String content;

  @override
  State<OpenButton> createState() => _OpenButtonState();
}

class _OpenButtonState extends State<OpenButton> {
  bool opening = false;

  @override
  Widget build(BuildContext context) {
    return opening
        ? Text(
            'Opening ...',
            style: TextStyle(color: myOrange, fontSize: 13),
          )
        : TextButton.icon(
            onPressed: () async {
              setState(() {
                opening = true;
              });
              await Provider.of<MediaProvider>(context, listen: false)
                  .openMedia(widget.content);
              setState(() {
                opening = false;
              });
            },
            icon: Icon(
              Icons.library_books,
              color: myOrange,
              size: 20,
            ),
            label: Text('Open Transcript'),
          );
  }
}
