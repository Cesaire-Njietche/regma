// @dart=2.9

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:provider/provider.dart';

import 'data/colors.dart';
import 'helpers/custom_route.dart';
import 'providers/auth_service_provider.dart';
import 'providers/cart_provider.dart';
//Providers
import 'providers/courses_provider.dart';
import 'providers/friend_provider.dart';
// import 'providers/m_user_provider.dart';
import 'providers/media_provider.dart';
import 'providers/message_provider.dart';
import 'providers/purchase_provider.dart';
import 'providers/subscriptions_provider.dart';
import 'screens/add_new_course_screen.dart';
import 'screens/add_new_lesson_screen.dart';
import 'screens/add_new_media_screen.dart';
import 'screens/add_new_question_screen.dart';
//Screens
import 'screens/cart_screen.dart';
import 'screens/change_password_screen.dart';
import 'screens/chat_room_screen.dart';
import 'screens/classroom_lesson_screen.dart';
import 'screens/course_detail_screen.dart';
import 'screens/course_lessons_screen.dart';
import 'screens/home_screen.dart';
import 'screens/lesson_questions_screen.dart';
import 'screens/login_signup_screen.dart';
import 'screens/manage_connections_screen.dart';
import 'screens/manage_courses_screen.dart';
import 'screens/media_detail_screen.dart';
import 'screens/media_screen.dart';
import 'screens/paid_media_screen.dart';
import 'screens/search_peer_screen.dart';
import 'screens/start_screen.dart';
import 'screens/start_screen_two.dart';
import 'screens/subscriptions_screen.dart';
import 'screens/test_screen.dart';
import 'screens/user_profile_screen.dart';
import 'screens/verify_email_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (defaultTargetPlatform == TargetPlatform.android)
    InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  await Firebase.initializeApp();
  // Stripe.publishableKey =
  //     'pk_test_51J0NZvAOdk9ESAI2otjYxRuksTYrqHoFhIIumXfrrITDbkmYitSpDoTKilDZ55lzERWt98NWmzTHsUNGCTwJ9UZs00PtifwGXY';
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initFirebaseSdk = Firebase.initializeApp();
  final _navigatorKey = new GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => CoursesProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => MediaProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SubscriptionsProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AuthServiceProvider(
            media: ctx.read<MediaProvider>(),
            courses: ctx.read<CoursesProvider>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => PurchaseProvider(
            courses: ctx.read<CoursesProvider>(),
            media: ctx.read<MediaProvider>(),
            subscriptions: ctx.read<SubscriptionsProvider>(),
            authService: ctx.read<AuthServiceProvider>(),
            cart: ctx.read<CartProvider>(),
          ),
        ),
        // ChangeNotifierProxyProvider<AuthServiceProvider, MUserProvider>(
        //   create: (ctx) => MUserProvider(),
        //   update: (ctx, auth, previousMUser) =>
        //       previousMUser..updateUser(auth.isAdmin),
        // ),
        ChangeNotifierProvider(
          create: (ctx) => FriendProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => MessageProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: _navigatorKey,
        title: 'Regma',
        theme: ThemeData(
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            },
          ),
          // tabBarTheme: TabBarTheme(
          // ),
          appBarTheme: AppBarTheme(
            toolbarTextStyle: GoogleFonts.quicksand(
              color: Colors.black87,
              fontSize: 17,
              //fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.w600,
            ),
            titleTextStyle: GoogleFonts.quicksand(
              color: Colors.black87,
              fontSize: 17,
              //fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.w600,
            ),
            textTheme: TextTheme(
              headline6: GoogleFonts.quicksand(
                color: Colors.black87,
                fontSize: 17,
                //fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: Colors.white70,
            toolbarHeight: 50,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              textStyle: MaterialStateProperty.resolveWith<TextStyle>(
                (Set<MaterialState> states) {
                  return TextStyle(
                    foreground: Paint()..color = Colors.white,
                    decorationColor: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    fontFamily: GoogleFonts.quicksand().fontFamily,
                  ); // Use the component's default.
                },
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  return Color.fromRGBO(
                      255, 161, 74, 1); // Use the component's default.
                },
              ),
            ),
          ),
          /*cupertinoOverrideTheme: CupertinoThemeData(
                //primaryColor: Constants.kPrimaryOrange,
                ),*/

          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.black54,
          ),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: new TextStyle(color: const Color(0xFF424242)),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            hintStyle: TextStyle(color: Colors.black38),
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black12,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            focusColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black38, width: 2.0),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          textTheme: ThemeData.light().textTheme.copyWith(
                bodyText1: GoogleFonts.quicksand(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontSize: 25,
                  //fontFamily: 'Raleway',
                  fontWeight: FontWeight.w900,
                ),
                bodyText2: GoogleFonts.quicksand(
                  color: Colors.black54,
                  fontSize: 17,
                  //fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.w600,
                ),
                headline1: GoogleFonts.quicksand(
                  fontSize: 20,
                  //fontFamily: 'Quicksand',
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontWeight: FontWeight.w700,
                ),
                headline2: GoogleFonts.quicksand(
                  fontSize: 20,
                  //fontFamily: 'Quicksand',
                  color: Colors.black54,
                  fontWeight: FontWeight.w700,
                ),
                headline3: GoogleFonts.quicksand(
                  fontSize: 15,
                  //fontFamily: 'Quicksand',
                  color: myOrange,
                  fontWeight: FontWeight.w800,
                ),
              ),
          primaryColor: Color(0xFFF5F8FF),
          scaffoldBackgroundColor: Color(0xFFF5F8FF),
          primarySwatch: myOrange,
          // colorScheme: ColorScheme(
          //   secondary: Color.fromRGBO(255, 161, 74, 1),
          // ),
          accentColor: Color.fromRGBO(255, 161, 74, 1),
        ),
        home: _home(),
        routes: {
          StartScreen.routeName: (ctx) => StartScreen(),
          StartScreenTwo.routeName: (ctx) => StartScreenTwo(),
          LoginSignUpScreen.routeName: (ctx) => LoginSignUpScreen(),
          HomeScreen.routeName: (ctx) => HomeScreen(),
          CourseDetailScreen.routeName: (ctx) => CourseDetailScreen(),
          TestScreen.routeName: (ctx) => TestScreen(),
          MediaDetailScreen.routeName: (ctx) => MediaDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          UserProfileScreen.routeName: (ctx) => UserProfileScreen(),
          ChangePassWordScreen.routeName: (ctx) => ChangePassWordScreen(),
          PaidMediaScreen.routeName: (ctx) => PaidMediaScreen(),
          SubscriptionScreen.routeName: (ctx) => SubscriptionScreen(),
          AddNewCourseScreen.routeName: (ctx) => AddNewCourseScreen(),
          ManageCoursesScreen.routeName: (ctx) => ManageCoursesScreen(),
          CourseLessonsScreen.routeName: (ctx) => CourseLessonsScreen(),
          AddNewLessonScreen.routeName: (ctx) => AddNewLessonScreen(),
          LessonQuestionsScreen.routeName: (ctx) => LessonQuestionsScreen(),
          AddNewQuestionScreen.routeName: (ctx) => AddNewQuestionScreen(),
          ClassroomLessonScreen.routeName: (ctx) => ClassroomLessonScreen(),
          AddNewMediaScreen.routeName: (ctx) => AddNewMediaScreen(),
          MediaScreen.routeName: (ctx) => MediaScreen(),
          SearchPeerScreen.routeName: (ctx) => SearchPeerScreen(),
          ManageConnectionsScreen.routeName: (ctx) => ManageConnectionsScreen(),
          ChatRoomScreen.routeName: (ctx) => ChatRoomScreen(),
        },
      ),
    );
  }

  Widget _home() {
    var token = '';
    return FutureBuilder(
        future: Future.delayed(
          Duration(microseconds: 100),
        ),
        builder: (context, snapshot) {
          //if (snapshot.hasError) return ErrorScreen();

          if (snapshot.connectionState == ConnectionState.done) {
            // Assign listener after the SDK is initialized successfully
            FirebaseAuth.instance.userChanges().listen((User user) {
              if (user == null) {
                _navigatorKey.currentState
                    .pushReplacementNamed(StartScreen.routeName);
                token = '';
              } else {
                if (user.emailVerified) {
                  // Changing password and verifying email lead to this condition

                  // _navigatorKey.currentState
                  //     .pushReplacementNamed(HomeScreen.routeName);
                  // var auth = Provider.of<AuthService>(context, listen: false);
                  //
                  // if (!auth.stopRefreshing) {
                  //   auth.refreshing(true);
                  if (token == '') {
                    //Stop directing the user to the home screen after every 1
                    // hour
                    user.getIdTokenResult().then((value) {
                      token = value.token;
                    });
                    _navigatorKey.currentState.pushNamedAndRemoveUntil(
                        HomeScreen.routeName, (route) => false);
                  }
                } else
                  _navigatorKey.currentState.pushReplacement(MaterialPageRoute(
                    builder: (context) => VerifyEmailScreen(),
                  ));
                // _navigatorKey.currentState
                //     .pushReplacementNamed(HomeScreen.routeName);
              }
            });
          }

          return Scaffold(
            backgroundColor: Color(0XFFffffff),
            body: Center(child: Image.asset('assets/images/regma.png')),
          );
        });
  }
}
