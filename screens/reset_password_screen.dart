import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/colors.dart';
import '../helpers/util.dart';
import '../providers/auth_service_provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key key}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  var email = '';
  AuthServiceProvider auth;
  final GlobalKey<FormState> _formKey = GlobalKey();

  Future<void> sendRequest() async {
    final isValid = _formKey.currentState.validate();

    if (isValid) {
      _formKey.currentState.save();
      try {
        await auth.resetPwd(email);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 10),
            content: Text(
              'An Email has been send to $email. Follow the link to reset your password.',
            ),
            backgroundColor: Theme.of(context).accentColor.withOpacity(.95),
          ),
        );
        Navigator.of(context).pop();
      } catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 10),
            content: Text(
              err.message,
            ),
            backgroundColor: Theme.of(context).accentColor.withOpacity(.95),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthServiceProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: myOrange,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        title: Text('Reset Password'),
      ),
      body: Stack(children: [
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
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 10,
          ),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      cursorColor: myOrange,
                      style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w600, fontSize: 15),
                      decoration: InputDecoration(
                        labelText: 'Your email address',
                        prefixIcon: Icon(Icons.email),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: myOrange,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: myOrange,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => Util.isValidEmail(value)
                          ? null
                          : 'Enter a valid email',
                      onSaved: (value) => email = value.trim(),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: sendRequest,
                child: Text(
                  'Send Request',
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
