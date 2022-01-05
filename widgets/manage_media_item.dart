import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/colors.dart';
import '../helpers/util.dart';
import '../providers/media_provider.dart';
import '../screens/add_new_media_screen.dart';

class ManageMediaItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final String type;
  ManageMediaItem({this.id, this.title, this.imageUrl, this.type});

  @override
  Widget build(BuildContext context) {
    var _style = GoogleFonts.quicksand(
      fontWeight: FontWeight.w600,
    );
    return Card(
      color: Colors.white,
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
          title,
          style:
              GoogleFonts.quicksand(fontWeight: FontWeight.w500, fontSize: 15),
        ),
        subtitle: Text(
          type,
          style:
              GoogleFonts.quicksand(fontWeight: FontWeight.w400, fontSize: 14),
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
                    Navigator.of(context)
                        .pushNamed(AddNewMediaScreen.routeName, arguments: id);
                  }),
              Expanded(
                  child: DeleteButton(id: id, title: title, style: _style)),
            ],
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
    @required this.title,
    @required TextStyle style,
  })  : _style = style,
        super(key: key);

  final String id;
  final String title;
  final TextStyle _style;

  @override
  _DeleteButtonState createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {
  var isLoading = false;
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
                "You are about to delete a media",
                "Deleted media cannot be restored",
                () async {
                  setState(() {
                    isLoading = true;
                  });
                  await Provider.of<MediaProvider>(context, listen: false)
                      .deleteMediaById(widget.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: RichText(
                        text: TextSpan(
                            text: widget.title,
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
