import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../data/colors.dart';
import '../helpers/util.dart';
import '../providers/auth_service_provider.dart';
import '../widgets/confirm_settings_change.dart';
import 'change_password_screen.dart';

class UserProfileScreen extends StatefulWidget {
  static String routeName = '/user-profile';

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false; //Loading for the main screen
  var isLoading = false; //Loading for the reset password
  var isEdited =
      false; //Check Whether the user has edited any of the form's field
  var imageUrl = '';
  var first = true;
  File pickedImage;
  AuthServiceProvider auth;
  Map<String, dynamic> _authData = {
    'name': '',
    'surname': '',
    'email': '',
    'backupEmail': '',
  };

  Future<bool> _confirmSettingsChange(BuildContext context) async {
    bool result = await showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        context: context,
        builder: (_) {
          return ConfirmSettingsChange(true);
        });

    return result == null ? false : result;
  }

  Future<void> pickImage() async {
    //async function to get image profile from the user

    final _pickedImage = await ImagePicker().getImage(
        source: ImageSource.gallery, maxWidth: 300, imageQuality: 100);

    if (_pickedImage == null) return;

    setState(() {
      pickedImage = File(_pickedImage.path);
      isEdited = true;
    });
  }

  Future<void> saveForm() async {
    //async function to save user information to the database using user provider and notify

    FocusScope.of(context).unfocus();
    final valid = _formKey.currentState.validate();

    if (valid) {
      _formKey.currentState.save();
      try {
        setState(() {
          _isLoading = true;
        });

        //Send authentication email for parent approval prior to saving the user data to FirebaseFirestore.

        var result = await _confirmSettingsChange(context);
        if (result) {
          await auth.updateUserProfile(_authData, pickedImage);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: myOrange.withOpacity(0.8),
            content: Text(
              'Profile updated successfully',
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            duration: Duration(seconds: 3),
          ));

          Navigator.of(context).pop();
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } catch (err) {}
    }
  }

  @override
  void didChangeDependencies() {
    if (first) {
      var user = Provider.of<AuthServiceProvider>(context).user;
      _authData = {
        'name': user.name,
        'surname': user.surname,
        'email': user.email,
        'backupEmail': user.backupEmail,
        'profilePicURL': user.profilePicURL,
        'isVisibleOnSearch': user.isVisibleOnSearch,
      };
      imageUrl = user.profilePicURL;
      first = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthServiceProvider>(context, listen: false);
    print('Rebuild');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white54,
        leading: IconButton(
          icon: Icon(
            Icons.clear,
            color: myOrange,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          'My Profile',
        ),
        elevation: 0.0,
        actions: [
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : IconButton(
                  icon: Icon(
                    Icons.save,
                    color: myOrange,
                  ),
                  onPressed: isEdited ? saveForm : null,
                ),
          SizedBox(
            width: 10,
          ),
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
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (imageUrl == null && pickedImage == null)
                      CircleAvatar(
                        backgroundColor: myOrange.withOpacity(.7),
                        foregroundImage:
                            AssetImage('assets/images/profile.png'),
                        radius: 40,
                      ),
                    if (imageUrl != null && pickedImage == null)
                      CircleAvatar(
                        backgroundColor: myOrange.withOpacity(.7),
                        backgroundImage: NetworkImage(imageUrl),
                        radius: 40,
                      ),
                    if (pickedImage != null)
                      CircleAvatar(
                        backgroundColor: myOrange.withOpacity(.7),
                        backgroundImage: FileImage(pickedImage),
                        radius: 40,
                      ),
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: myOrange,
                      ),
                      onPressed: pickImage,
                    ), //Image picker to pick an image in the gallery and upload it to FirebaseFirestore
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          key: ValueKey('name'),
                          initialValue: _authData['name'],
                          cursorColor: myOrange,
                          style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w600, fontSize: 15),
                          decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            labelText: 'Name',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                          validator: (value) =>
                              value.isEmpty ? 'Enter a name' : null,
                          onSaved: (value) {
                            _authData['name'] = value.trim();
                          },
                          onChanged: (val) {
                            setState(() {
                              isEdited = true;
                            });
                          },
                        ),
                        Divider(),
                        TextFormField(
                          initialValue: _authData['surname'],
                          cursorColor: myOrange,
                          style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w600, fontSize: 15),
                          decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            labelText: 'Surname',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                          validator: (value) =>
                              value.isEmpty ? 'Enter a surname' : null,
                          onSaved: (value) {
                            _authData['surname'] = value;
                          },
                          onChanged: (val) {
                            setState(() {
                              isEdited = true;
                            });
                          },
                        ),
                        Divider(),
                        TextFormField(
                          initialValue: _authData['email'],
                          cursorColor: myOrange,
                          // enabled: false,
                          readOnly: true,
                          style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w600, fontSize: 15),
                          decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            labelText: 'E-Mail',
                            prefixIcon: Icon(Icons.email),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => Util.isValidEmail(value.trim())
                              ? null
                              : 'Enter a valid email',
                          onSaved: (value) {
                            _authData['email'] = value.trim();
                          },
                          onChanged: (val) {
                            setState(() {
                              isEdited = true;
                            });
                          },
                        ),
                        Divider(),
                        TextFormField(
                          initialValue: _authData['backupEmail'],
                          cursorColor: myOrange,
                          style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w600, fontSize: 15),
                          decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            labelText: 'Back up e-Mail',
                            prefixIcon: Icon(Icons.email),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => Util.isValidEmail(value.trim())
                              ? null
                              : 'Enter a valid email',
                          onSaved: (value) {
                            _authData['backupEmail'] = value.trim();
                          },
                          onChanged: (val) {
                            setState(() {
                              isEdited = true;
                            });
                          },
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(right: 10, bottom: 20),
                  child: TextButton.icon(
                    onPressed: () => Navigator.of(context)
                        .pushNamed(ChangePassWordScreen.routeName),
                    icon: Icon(Icons.lock),
                    label: Text('Change Password'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
