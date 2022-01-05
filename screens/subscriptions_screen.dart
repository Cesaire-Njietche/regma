import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/colors.dart';
import '../models/course_model.dart';
import '../models/subscription.dart';
import '../providers/courses_provider.dart';
import '../providers/subscriptions_provider.dart';
import '../widgets/center_no_history.dart';
import '../widgets/subscription_item.dart';

class SubscriptionScreen extends StatelessWidget {
  static String routeName = '/subscriptions';
  @override
  Widget build(BuildContext context) {
    var allCourses = Provider.of<CoursesProvider>(context, listen: false);
    var courses = <CourseModel>[];
    var prices = <double>[];
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Subscriptions'),
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: myOrange,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
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
          FutureBuilder(
              future: Provider.of<SubscriptionsProvider>(context, listen: false)
                  .fetchSubscriptions(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Consumer<SubscriptionsProvider>(
                      //Implement a future builder that will fetch data from Firebase and notify all the listeners along with CircularProgressIndicator
                      builder: (ctx, subscriptionsList, _) {
                    var subscriptions = subscriptionsList.subscriptions;
                    subscriptions.forEach((subscription) {
                      var course =
                          allCourses.findCourseById(subscription.courseId);
                      courses.add(course);
                      if (subscription.plan == Plan.Monthly)
                        prices.add(course.monthlyPrice);
                      else
                        prices.add(course.yearlyPrice);
                    });
                    return subscriptionsList.subscriptions.length == 0
                        ? CenterNoHistory('No Subscriptions Yet!')
                        : ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (ctx, ind) {
                              var subs = subscriptions[ind];
                              var course = courses[ind];
                              var price = prices[ind];
                              return SubscriptionItem(
                                id: subs.id,
                                plan: planToString(subs.plan),
                                price: price,
                                courseName: course.name,
                                subsDate: subs.startDate,
                                expiredDate: subs.endDate,
                                width: w,
                              );
                            },
                            itemCount: subscriptions.length,
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 10),
                          );
                  });
                }
              })
        ],
      ),
    );
  }

  String planToString(Plan plan) {
    if (plan == Plan.Monthly)
      return 'Monthly';
    else
      return 'Yearly';
  }
}
