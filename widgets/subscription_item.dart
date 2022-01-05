import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/colors.dart';

class SubscriptionItem extends StatelessWidget {
  final String id;
  final String plan;
  final double price;
  final courseName;
  final DateTime subsDate;
  DateTime expiredDate;
  double width;

  SubscriptionItem({
    @required this.id,
    @required this.plan,
    @required this.price,
    @required this.courseName,
    this.expiredDate,
    @required this.subsDate,
    @required this.width,
  });

  @override
  Widget build(BuildContext context) {
    var isMonthly = plan == 'Monthly';
    var fontSizeRegma = width >= 410 ? 17.0 : 15.0;
    return LayoutBuilder(
      builder: (ctx, constraints) => Card(
        margin: EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 5,
            ),
            Text(
              plan,
              style: TextStyle(color: Colors.black.withOpacity(.6)),
            ),
            SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                text: '€${price.toStringAsFixed(2)}',
                style: TextStyle(
                  color: myOrange,
                  fontWeight: FontWeight.w700,
                ),
                children: <TextSpan>[
                  isMonthly
                      ? TextSpan(
                          text: ' per Month',
                          style: Theme.of(context).textTheme.bodyText2,
                        )
                      : TextSpan(text: ''),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Course name : ',
                    style: TextStyle(fontSize: fontSizeRegma),
                  ),
                  Text(
                    courseName,
                    style: TextStyle(fontSize: fontSizeRegma),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Enrollment date : ',
                    style: TextStyle(fontSize: fontSizeRegma),
                  ),
                  Expanded(
                    child: Text(
                      DateFormat.yMEd().format(subsDate),
                      style: TextStyle(fontSize: fontSizeRegma),
                      textAlign: TextAlign.right,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            if (isMonthly)
              Padding(
                padding: const EdgeInsets.only(
                  left: 5,
                  right: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FittedBox(
                      child: Text(
                        'Due date : ',
                        style: TextStyle(fontSize: fontSizeRegma),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        DateFormat.yMEd().format(expiredDate),
                        style: TextStyle(fontSize: fontSizeRegma),
                      ),
                    ),
                    TextButton(
                      onPressed: expiredDate.compareTo(DateTime.now()) > 0
                          ? null
                          : () {}, //Get the payment module interface to complete the payment
                      child: Text(
                        'Renew',
                        style: TextStyle(fontSize: fontSizeRegma),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
