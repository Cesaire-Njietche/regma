import 'package:flutter/material.dart';

import '../data/colors.dart';

class CenterNoHistory extends StatelessWidget {
  final String text;
  CenterNoHistory(this.text);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory,
            color: myOrange.withOpacity(.8),
            size: 80,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black.withOpacity(.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
