import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../data/colors.dart';

class PaidMediaItem extends StatelessWidget {
  final String id;
  final String name;
  final String image;
  final double price;
  final DateTime date;

  PaidMediaItem({
    @required this.id,
    @required this.image,
    @required this.name,
    @required this.price,
    @required this.date,
  });

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var fontSizeRegma = w >= 410 ? 16.0 : 14.0;
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: myOrange.withOpacity(.3),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Image.network(image),
              ),
            ),
            title: Text(
              name,
              style: GoogleFonts.quicksand(
                  fontSize: fontSizeRegma, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              '€${(price).toStringAsFixed(2)}',
              style: GoogleFonts.quicksand(
                  fontSize: fontSizeRegma,
                  color: myOrange,
                  fontWeight: FontWeight.w700),
            ),
            trailing: Text(
              DateFormat.yMd().format(date),
              style: GoogleFonts.quicksand(fontSize: fontSizeRegma),
            ),
          ),
        ],
      ),
    );
  }
}
