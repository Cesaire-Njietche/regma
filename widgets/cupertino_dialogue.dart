import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MCupertinoDialog extends StatefulWidget {
  String title;
  String content;
  Function onContinue;
  BuildContext context;
  MCupertinoDialog(Key key, this.title, this.content, this.onContinue)
      : super(key: key);
  MCupertinoDialogViewState lw = MCupertinoDialogViewState();

  @override
  MCupertinoDialogViewState createState() {
    return this.lw = new MCupertinoDialogViewState();
  }
}

class MCupertinoDialogViewState extends State<MCupertinoDialog> {
  List<Widget> paragraphList = [];
  initSate() {}
  @override
  initState() {
    super.initState();
  }

  mShowCupertinoDialog(
      String title, String content, Function onContinue, BuildContext context) {
    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title
                /*"You are about to delete a question!"*/),
            content: Text(content
                /*"Deleted questions cannot be restored."*/),
            actions: [
              TextButton(
                  onPressed: () {
                    onContinue();
                  },
                  child: Text("Continue")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"))
            ],
          );
        });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return mShowCupertinoDialog(
        widget.title, widget.content, widget.onContinue, context);
  }
}
