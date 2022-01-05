import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/colors.dart';
import '../providers/auth_service_provider.dart';
import '../widgets/confirm_settings_change.dart';

class ChangePassWordScreen extends StatefulWidget {
  static String routeName = '/change-password';
  @override
  _ChangePassWordScreenState createState() => _ChangePassWordScreenState();
}

class _ChangePassWordScreenState extends State<ChangePassWordScreen> {
  var _isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();
  var _newPasswordController = TextEditingController();
  AuthServiceProvider auth;

  String newPassword = '';

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

  Future<void> changePassword() async {
    //async function to Change password using the user provider
    FocusScope.of(context).unfocus();
    final valid = formKey.currentState.validate();

    //Check first if the old password is the real current password

    if (valid) {
      formKey.currentState.save();
      try {
        setState(() {
          _isLoading = true;
        });
        var result = await _confirmSettingsChange(context);

        if (result) {
          await auth.updatePassword(newPassword);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Password Successfully Changed'),
              backgroundColor: Theme.of(context).accentColor,
            ),
          );
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } catch (err) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                err.message,
              ),
              backgroundColor: Theme.of(context).errorColor,
            ),
          );
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthServiceProvider>(context, listen: false);
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
          'Change Password',
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
                  onPressed: changePassword,
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
            child: Container(
              alignment: Alignment.centerRight,
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _newPasswordController,
                      cursorColor: myOrange,
                      style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w600, fontSize: 15),
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        focusColor: myOrange,
                        labelText: 'New Password',
                        prefixIcon: Icon(Icons.lock),
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
                      obscureText: true,
                      validator: (value) {
                        if (value.isEmpty || value.length < 7) {
                          return 'Password is short. 7 characters at least';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        newPassword = value;
                      },
                    ),
                    Divider(),
                    TextFormField(
                      cursorColor: myOrange,
                      style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w600, fontSize: 15),
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        focusColor: myOrange,
                        labelText: 'Re-Enter',
                        prefixIcon: Icon(Icons.lock),
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
                      obscureText: true,
                      validator: (value) => value != _newPasswordController.text
                          ? 'Passwords do not match'
                          : null,
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    super.dispose();
  }
}
