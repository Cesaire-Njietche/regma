import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

import '../data/colors.dart';
import '../models/media.dart';
//import '../helpers/util.dart';
import '../providers/media_provider.dart';

class AddNewMediaScreen extends StatefulWidget {
  static String routeName = '/add-new-media-screen';

  @override
  _AddNewMediaScreenState createState() => _AddNewMediaScreenState();
}

class _AddNewMediaScreenState extends State<AddNewMediaScreen> {
  bool isInit = true;
  bool isAdding = true;
  bool _isLoading = false;
  String mediaId;
  String mediaName = 'No Media Selected';
  File thumbnail;
  File mediaFile;
  bool isValidSize = true;
  Map<String, double> ds;

  final _form = GlobalKey<FormState>();
  Map<String, String> formValues = {
    'id': '',
    'title': '',
    'description': '',
    'imageUrl': '',
    'contentUrl': '',
    'mediaType': 'Book',
    'author': '',
    'price': '0.0',
    'length': '0',
  };
  var extensions = {
    'Book': ['ppt', 'pptx,' 'pdf', 'doc', 'docx'],
    'Event': ['mpg', 'mp4', 'mov', 'wmv', 'webm', 'mpeg', 'avi'],
    'Music': ['wav', 'mp3', 'ogg', 'aac', 'wave', 'wma'],
    'Movie': ['mpg', 'mp4', 'mov', 'wmv', 'webm', 'mpeg', 'avi'],
    'Podcast': [
      'mpg',
      'mp4',
      'mov',
      'wmv',
      'webm',
      'mpeg',
      'avi',
      'wav',
      'mp3',
      'ogg',
      'aac',
      'wave',
      'aif'
    ],
  };

  Future<void> pickMediaImage() async {
    final _pickedImage = await ImagePicker().getImage(
      source: ImageSource.gallery, //change this to gallery on production mode
    );

    if (_pickedImage == null) return;

    setState(() {
      thumbnail = File(_pickedImage.path);
    });
  }

  Future<void> pickMediaContent() async {
    final result = await FilePicker.platform.pickFiles(
      allowedExtensions: extensions[formValues['mediaType']],
      type: FileType.custom,
    );

    mediaFile = File(result.files.single.path);
    var length = await mediaFile.length();

    ds = await Provider.of<MediaProvider>(context, listen: false)
        .getDownloadSize();

    // print('Minimum size : ${ds['minimum'] * 1024 * 1024}');
    // print('File size : $length');
    // print('Maximum size : ${ds['maximum'] * 1024 * 1024}');
    if (length > ds['maximum'] * 1024 * 1024 ||
        length < ds['minimum'] * 1024 * 1024) {
      isValidSize = false;

      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: 'File size must be between ',
                style: GoogleFonts.quicksand(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            RichText(
              text: TextSpan(
                text: '${ds['minimum'].toStringAsFixed(2)} MB',
                style: GoogleFonts.quicksand(
                    color: myOrange, fontSize: 15, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: ' and ',
                    style: GoogleFonts.quicksand(
                        color: Colors.black, fontWeight: FontWeight.normal),
                  ),
                  TextSpan(
                    text: '${ds['maximum'].toStringAsFixed(2)} MB',
                    style: GoogleFonts.quicksand(
                        color: myOrange,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
        btnOkColor: myOrange,
        dismissOnTouchOutside: true,
        btnOkOnPress: () {
          return;
        },
      ).show();
      return;
    }

    isValidSize = true;
    // print('Minimum size : ${ds['minimum'] * 1024 * 1024}');
    // print('File size : $length');
    // print('Maximum size : ${ds['maximum'] * 1024 * 1024}');
    if (result == null) return;

    setState(() {
      mediaName = path.basename(result.files.single.path);
    });
  }

  Future<void> saveMedia() async {
    FocusScope.of(context).unfocus();
    if (_form.currentState.validate()) {
      if (thumbnail == null && isAdding) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red.withOpacity(0.85),
          content: Text(
            'Select an image for the media',
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          duration: Duration(seconds: 3),
        ));
        return; //Message to prompt the user to enter an image
      }
      if (mediaFile == null && isAdding) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red.withOpacity(0.85),
          content: Text(
            'Select a content for the media',
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          duration: Duration(seconds: 3),
        ));
        return; //
      }
      if (!isValidSize) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: 'File size must be between ',
                  style: GoogleFonts.quicksand(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              RichText(
                text: TextSpan(
                  text: '${ds['minimum'].toStringAsFixed(2)} MB',
                  style: GoogleFonts.quicksand(
                      color: myOrange,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: ' and ',
                      style: GoogleFonts.quicksand(
                          color: Colors.black, fontWeight: FontWeight.normal),
                    ),
                    TextSpan(
                      text: '${ds['maximum'].toStringAsFixed(2)} MB',
                      style: GoogleFonts.quicksand(
                          color: myOrange,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
          btnOkColor: myOrange,
          dismissOnTouchOutside: true,
          btnOkOnPress: () {
            return;
          },
        ).show();
        return; //
      }
      _form.currentState.save();
      setState(() {
        _isLoading = true;
      });
      Media media = Media(
        id: formValues['id'],
        title: formValues['title'],
        description: formValues['description'],
        type: formValues['mediaType'],
        imageUrl: formValues['imageUrl'],
        contentUrl: formValues['contentUrl'],
        length: int.parse(formValues['length']),
        author: formValues['author'],
        price: double.parse(formValues['price']),
        isBought: false,
        isFree: double.parse(formValues['price']) > 0.0 ? false : true,
      );

      await Provider.of<MediaProvider>(context, listen: false)
          .addNewMedia(media, thumbnail, mediaFile, isAdding);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: myOrange.withOpacity(0.9),
        content: Text(
          isAdding
              ? 'Media successfully created '
              : 'Media successfully updated ',
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
        mediaId = ModalRoute.of(context).settings.arguments as String;
        isAdding = false;
        var media = Provider.of<MediaProvider>(context, listen: false)
            .findMediaById(mediaId);
        formValues = {
          'id': media.id,
          'title': media.title,
          'description': media.description,
          'imageUrl': media.imageUrl,
          'contentUrl': media.contentUrl,
          'mediaType': media.type,
          'author': media.author,
          'price': media.price.toString(),
          'length': media.length.toString(),
        };
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var items = ['Book', 'Event', 'Music', 'Movie', 'Podcast'];

    // print(formValues['mediaType']);
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
          title: Text(isAdding ? 'Add New Media' : 'Edit Media'),
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
                    onPressed: saveMedia,
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
                                child: thumbnail == null
                                    ? Image.asset(
                                        'assets/images/placeholder_course_regma.png',
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        thumbnail,
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
                                child: thumbnail == null
                                    ? Image.network(
                                        formValues['imageUrl'],
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        thumbnail,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          SizedBox(
                            width: 10,
                          ),
                          TextButton.icon(
                            label: Text(
                              'Media Image',
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            icon: Icon(
                              Icons.photo,
                              color: myOrange,
                            ),
                            onPressed: pickMediaImage,
                          ), //Image picker to pick an image in the gallery and upload it to FirebaseFirestore
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 100,
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              color: myOrange.withOpacity(0.7),
                              child: Text(
                                isAdding
                                    ? mediaName
                                    : 'Your media is on file. You can still change It.',
                                style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            TextButton.icon(
                              label: Text(
                                'Media Content',
                                style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              icon: Icon(
                                Icons.subscriptions,
                                color: myOrange,
                              ),
                              onPressed: pickMediaContent,
                            ), //Im
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButton(
                        value: formValues['mediaType'],
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: myOrange,
                        ),
                        items: items.map((String item) {
                          return DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ));
                        }).toList(),
                        onChanged: (String newValue) {
                          setState(() {
                            formValues['mediaType'] = newValue;
                          });
                        },
                        underline: Container(
                          height: 2,
                          color: myOrange,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if (isAdding)
                        TextFormField(
                          initialValue: formValues['id'],
                          decoration: InputDecoration(labelText: "Media ID"),
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                          onSaved: (val) {
                            formValues['id'] = val;
                          },
                          validator: (val) {
                            if (val.isEmpty)
                              return 'Enter the media ID';
                            else
                              return null;
                          },
                        ),
                      if (isAdding)
                        SizedBox(
                          height: 10,
                        ),
                      TextFormField(
                        initialValue: formValues['title'],
                        decoration: InputDecoration(labelText: "Media Title"),
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                        onSaved: (val) {
                          formValues['title'] = val;
                        },
                        validator: (val) {
                          if (val.isEmpty)
                            return 'Enter a title';
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
                      TextFormField(
                        initialValue: formValues['author'],
                        maxLines: null,
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(labelText: "Author"),
                        onSaved: (val) {
                          formValues['author'] = val;
                        },
                        validator: (val) {
                          if (val.isEmpty)
                            return 'Enter an author';
                          else
                            return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        keyboardType: TextInputType.number,
                        initialValue: formValues['price'],
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(labelText: "Price"),
                        onSaved: (val) {
                          formValues['price'] = val;
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
                        initialValue: formValues['length'],
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(labelText: "Length"),
                        onSaved: (val) {
                          formValues['length'] = val;
                        },
                        validator: (val) {
                          var yp = double.tryParse(val);
                          if (yp == null)
                            return 'Enter a length';
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
