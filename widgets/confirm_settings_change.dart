import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/colors.dart';
import '../models/user.dart';
import '../services/regma_services.dart';

class ConfirmSettingsChange extends StatefulWidget {
  bool settings;
  ConfirmSettingsChange(this.settings);

  @override
  _ConfirmSettingsChangeState createState() => _ConfirmSettingsChangeState();
}

class _ConfirmSettingsChangeState extends State<ConfirmSettingsChange> {
  final _controller = TextEditingController();
  bool isLoading = false;

  MUser user;
  Future<bool> _applyChange() async {
    setState(() {
      isLoading = true;
    });
    var code = await RegmaServices().getParentalCode();
    if (code.compareTo(_controller.text) == 0) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 250,
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.quicksand(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  isLoading
                      ? CircularProgressIndicator()
                      : TextButton(
                          child: Text(
                            'Apply',
                            style: GoogleFonts.quicksand(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            var result = await _applyChange();
                            if (!result) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: Duration(milliseconds: 700),
                                  content: Text('Wrong password'),
                                  backgroundColor: Theme.of(context)
                                      .errorColor
                                      .withOpacity(.9),
                                ),
                              );
                            }
                            Navigator.of(context).pop(result);
                          },
                        ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                widget.settings
                    ? 'Enter password to apply change'
                    : 'Enter password to confirm',
                style: GoogleFonts.quicksand(
                  color: Colors.black.withOpacity(.7),
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              TextField(
                obscureText: true,
                cursorColor: myOrange,
                decoration: InputDecoration(
                  // fillColor: Colors.black87,
                  focusColor: myOrange,
                  labelText: 'Password',
                  labelStyle: TextStyle(fontSize: 15),
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
                style: TextStyle(color: Colors.black87),
                controller: _controller,
              ),
              Divider(
                thickness: 1,
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
