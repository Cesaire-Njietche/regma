import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/colors.dart';
import '../helpers/util.dart';
import '../providers/auth_service_provider.dart';
import '../screens/reset_password_screen.dart';

class Login extends StatefulWidget {
  final double cardWidth;
  final double cardHeight;
  Login({@required this.cardWidth, @required this.cardHeight});
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;

  void trySubmit(AuthServiceProvider auth) async {
    FocusScope.of(context).unfocus();
    //final auth = FirebaseAuth.instance;
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      final result =
          await auth.login(_authData['email'], _authData['password']);

      if (result != 'Signed In') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result, //Call the message attribute of err (err.message)
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

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthServiceProvider>(context);
    return Container(
      height: widget.cardHeight,
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    key: ValueKey('l_email'),
                    cursorColor: myOrange,
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
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(),
                  TextFormField(
                    key: ValueKey('l_password'),
                    cursorColor: myOrange,
                    style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w600, fontSize: 15),
                    decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      focusColor: myOrange,
                      labelText: 'Password',
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
                      _authData['password'] = value.trim();
                    },
                  ),
                  Divider(),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            right: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ResetPasswordScreen(),
                  ),
                );
              },
              child: Container(
                child: Text(
                  'Forget your password?',
                  style: TextStyle(color: myOrange, fontSize: 15),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -10,
            left: _isLoading ? widget.cardWidth / 2.5 : widget.cardWidth / 3,
            child: _isLoading
                ? CircularProgressIndicator()
                : GestureDetector(
                    onTap: () {
                      // Navigator.of(context)
                      //     .pushReplacementNamed(HomeScreen.routeName);
                      trySubmit(auth);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: myOrange.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text('Login', style: TextStyle(fontSize: 16)),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
