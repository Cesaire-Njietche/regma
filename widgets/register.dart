import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/colors.dart';
import '../helpers/util.dart';
import '../providers/auth_service_provider.dart';
import '../services/regma_services.dart';

class Register extends StatefulWidget {
  final double cardWidth;
  final double cardHeight;
  Register({@required this.cardWidth, @required this.cardHeight});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();
  Map<String, dynamic> _authData = {
    'name': '',
    'surname': '',
    'email': '',
    'backupEmail': '',
    'isVisibleOnSearch': true,
  };
  var _isLoading = false;

  void trySubmit(AuthServiceProvider auth) async {
    FocusScope.of(context).unfocus();
    bool isAdmin = false;
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      //Register using FirebaseAuth

      setState(() {
        _isLoading = true;
      });

      final authResult =
          await auth.register(_authData['email'], _authData['password']);

      if (authResult == 'Signed Up') {
        await RegmaServices().saveUser({
          'name': _authData['name'],
          'surname': _authData['surname'],
          'email': _authData['email'],
          'backupEmail': _authData['backupEmail'],
          'isVisibleOnSearch': true,
          'parentalCode': _authData['password'],
        }, true);
        await auth.constructUser();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authResult, //Call the message attribute of err (err.message)
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
  void dispose() {
    super.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthServiceProvider>(context);
    return Container(
      padding: const EdgeInsets.all(10.0),
      height: widget.cardHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    key: ValueKey('name'),
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
                    validator: (value) => value.isEmpty ? 'Enter a name' : null,
                    onSaved: (value) {
                      _authData['name'] = value.trim();
                    },
                  ),
                  Divider(),
                  TextFormField(
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
                  ),
                  Divider(),
                  TextFormField(
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
                  Divider(),
                  TextFormField(
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
                  ),
                  Divider(),
                  TextFormField(
                    controller: _passwordController,
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
                      _authData['password'] = value;
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
                    validator: (value) => value != _passwordController.text
                        ? 'Passwords do not match'
                        : null,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -10,
            left:
                _isLoading ? widget.cardWidth / 2.5 : widget.cardWidth / 3 - 10,
            child: GestureDetector(
              onTap: () {
                // Navigator.of(context).pushReplacementNamed(
                //     HomeScreen.routeName); //For test purpose.
                trySubmit(auth);
              },
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: myOrange.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Register',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
