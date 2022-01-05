import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:regma/data/colors.dart';

class Badge extends StatelessWidget {
  const Badge({
    Key key,
    @required this.child,
    @required this.value,
    this.color,
  }) : super(key: key);

  final Widget child;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 9,
          top: 9,
          child: Container(
            padding: EdgeInsets.all(2.0),
            // color: Theme.of(context).accentColor,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white.withOpacity(.9),
              boxShadow: [
                BoxShadow(
                  color: myOrange.withOpacity(.7),
                  blurRadius: 15,
                  offset: Offset(-2, 2),
                ),
              ],
            ),
            constraints: BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: Color(0Xff13232e).withOpacity(.7),
                fontFamily: GoogleFonts.quicksand().fontFamily,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
    );
  }
}
