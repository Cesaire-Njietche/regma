import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:regma/models/subscription.dart';

import '../data/colors.dart';
import '../providers/courses_provider.dart';
import '../providers/purchase_provider.dart';
import '../screens/course_lessons_screen.dart';

class CourseDetailScreen extends StatefulWidget {
  static String routeName = '/course-detail-screen';

  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  var textStyle = TextStyle(
      color: Colors.black54, fontWeight: FontWeight.w600, fontSize: 15);
  bool paymentOptions = false;
  bool yearlySubscription = false;

  String id;
  Widget _enroll(Function() f, String msg, double price, bool isMonth) {
    return Card(
      color: myOrange.withOpacity(0.6),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            FittedBox(
              child: Text(
                msg,
                style: textStyle,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            FittedBox(
              child: RichText(
                text: TextSpan(
                  text: '€${price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  children: <TextSpan>[
                    isMonth
                        ? TextSpan(
                            text: ' Monthly',
                            style: Theme.of(context).textTheme.bodyText2,
                          )
                        : TextSpan(text: ''),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: f,
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.white, width: 2)),
                child: FittedBox(
                  child: Text(
                    'Enroll Now',
                    style: textStyle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showBottomSheet(BuildContext context, id, double h) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        backgroundColor: Colors.white.withOpacity(.95),
        context: context,
        builder: (_) {
          return FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Consumer<CoursesProvider>(
                  builder: (ctx, courses, _) => SingleChildScrollView(
                    child: Container(
                      height: h,
                      child: Column(
                        // height: h,
                        // margin: EdgeInsets.all(8.0),
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 3,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: myOrange.withOpacity(.6),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              )
                            ],
                          ),
                          Expanded(
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.all(10),
                              itemCount: courses.lessonItems.length,
                              itemBuilder: (context, ind) {
                                var lesson = courses.lessonItems[ind];
                                return ListTile(
                                  // subtitle: Text(
                                  //   lesson.content,
                                  // ),
                                  leading: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: myOrange,
                                    child: Text(
                                      '${ind + 1}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    lesson.name,
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                        //color: Colors.red,
                      ),
                    ),
                  ),
                );
              }
            },
            future: Provider.of<CoursesProvider>(context, listen: false)
                .findLessonsByCourseId(id),
          );
        });
  }

  @override
  void didChangeDependencies() {
    id = ModalRoute.of(context).settings.arguments as String;
    Provider.of<PurchaseProvider>(context, listen: false)
        .loadPurchases(id, ProductType.course);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var course =
        Provider.of<CoursesProvider>(context, listen: true).findCourseById(id);
    var screenHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    var purchase = Provider.of<PurchaseProvider>(context, listen: false);
    paymentOptions =
        Provider.of<CoursesProvider>(context, listen: false).paymentOptions;
    yearlySubscription =
        Provider.of<CoursesProvider>(context, listen: false).yearlySubscription;

    return Scaffold(
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
        // FutureBuilder(
        //   future:
        //   builder: (context, snapshot) =>
        CustomScrollView(physics: BouncingScrollPhysics(), slivers: [
          SliverAppBar(
            leading: IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: myOrange,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            expandedHeight: screenHeight * .5,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                course.name,
                style: Theme.of(context).textTheme.headline2,
              ),
              background: Hero(
                transitionOnUserGestures: true,
                tag: course.courseID,
                child: Image.network(
                  course.thumbnailURL,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // Container(
                //   height: screenHeight * .3,
                //   decoration:
                //       BoxDecoration(color: Colors.deepPurple.withOpacity(.2),borderRadius: ),
                // ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  //height: screenHeight * .3,
                  child: Material(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.white.withOpacity(.85),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            'What You Will Learn!',
                            style: TextStyle(color: myOrange, fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Text(
                            course.description,
                            maxLines: 20,
                            style: TextStyle(
                              color: Colors.black.withOpacity(.65),
                              // fontWeight: FontWeight.w600,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (course.isLock) //This course is not bought yet
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                    //height: screenHeight * .3,
                    child: Material(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.white.withOpacity(.85),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: yearlySubscription ? 60 : 0,
                          ),
                          if (yearlySubscription)
                            Padding(
                              padding: const EdgeInsets.only(top: 10, left: 10),
                              child: Transform(
                                transform: Matrix4.identity()..rotateZ(-45),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black45,
                                  ),
                                  child: Text(
                                    'Annually',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(.85),
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                          SizedBox(
                            height: yearlySubscription ? 5 : 10,
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(10.0),
                          //   child: Row(
                          //     //mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: _enroll(
                                  () async {
                                    await purchase.buy(
                                      course.courseID,
                                      ProductType.course,
                                      Plan.Yearly,
                                    );
                                  },
                                  yearlySubscription
                                      ? 'Get a 1 Year Full Access At'
                                      : 'One Year Access',
                                  course.yearlyPrice,
                                  false,
                                ),
                              ),
                              if (!yearlySubscription)
                                Expanded(
                                    child: _enroll(
                                  () async {
                                    await purchase.buy(
                                      course.courseID,
                                      ProductType.course,
                                      Plan.Monthly,
                                    );
                                  },
                                  'Pay as You Go',
                                  course.monthlyPrice,
                                  true,
                                )),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                if (!course.isLock && paymentOptions)
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                    child: Material(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: myOrange.shade800,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                'You have successfully bought this course'),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextButton(
                            child: Text('Tap here to go to your classroom'),
                            onPressed: () =>
                                Navigator.of(context).pushReplacementNamed(
                              CourseLessonsScreen.routeName,
                              arguments: {
                                'id': course.courseID,
                                'isEditing': false
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (!paymentOptions)
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                    child: Material(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: myOrange.shade800,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                            child: Text('Access to this course is free'),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextButton(
                            child: Text('Tap here to go to Classroom'),
                            onPressed: () =>
                                Navigator.of(context).pushReplacementNamed(
                              CourseLessonsScreen.routeName,
                              arguments: {
                                'id': course.courseID,
                                'isEditing': false
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () {
                    _showBottomSheet(
                        context, course.courseID, screenHeight * .6);
                  },
                  child: Text(
                    'See All Lessons',
                  ),
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.headline3,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.4,
                ),
              ],
            ),
          )
        ]),
      ]),
    );
  }
}
