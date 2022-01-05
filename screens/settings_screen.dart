import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:regma/screens/subscriptions_screen.dart';
import 'package:regma/widgets/custom_dialog.dart';

import '../data/colors.dart';
import '../models/user.dart';
import '../providers/auth_service_provider.dart';
import '../providers/courses_provider.dart';
import '../providers/media_provider.dart';
import '../providers/message_provider.dart';
import '../services/regma_services.dart';
import '../widgets/confirm_settings_change.dart';
// import '../providers/m_user_provider.dart';
import 'manage_courses_screen.dart';
import 'media_screen.dart';
//import 'manage_media_screen.dart';
import 'paid_media_screen.dart';
import 'user_profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isVisible = true;
  bool paymentOptions = true;
  bool yearlySubscription = true;
  bool enablingP = true;
  bool enablingYS = true;
  bool isConstructing = true;

  Future<bool> _confirmSettingsChange(BuildContext context) async {
    bool result = await showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        context: context,
        builder: (_) {
          return ConfirmSettingsChange(true);
        });

    return result;
  }

  void showAbout(BuildContext context) {
    showAboutDialog(
        context: context,
        // applicationName: 'Regma',
        applicationIcon: Icon(
          Icons.book,
          color: myOrange,
        ),
        applicationVersion: 'V 1.0.0');
  }

  void showTermsAndConditions(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            width: MediaQuery.of(context).size.width * .9,
            height: MediaQuery.of(context).size.height * .7,
            content: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Text(
                'Regma terms and conditions',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          );
        });
  }

  void showPrivacy(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            width: MediaQuery.of(context).size.width * .9,
            height: MediaQuery.of(context).size.height * .7,
            content: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Text(
                'Regma Privacy',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    var auth = Provider.of<AuthServiceProvider>(context, listen: false);
    auth.constructUser().then((_) => setState(() {
          isConstructing = false;
        }));
    paymentOptions =
        Provider.of<CoursesProvider>(context, listen: false).paymentOptions;
    yearlySubscription =
        Provider.of<CoursesProvider>(context, listen: false).yearlySubscription;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // = Provider.of<MUserProvider>(context).user;
    var auth = Provider.of<AuthServiceProvider>(context);

    MUser user;
    if (!isConstructing) {
      user = auth.user;
    }

    bool isAdmin = false;
    if (user != null) {
      isAdmin = user.isAdmin;
      print(isAdmin);
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Settings',
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
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (user != null) _buildHeader(user),
                    if (isConstructing)
                      Center(child: CupertinoActivityIndicator()),
                    Text(
                      'Account Settings',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    _buildAccountSettings(context, isConstructing, user),
                    if (isAdmin)
                      Text(
                        'Admin',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    if (isAdmin) _buildAdmin(),
                    Text(
                      'Support',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    _buildSupport(),
                    Container(
                      alignment: Alignment.center,
                      child: TextButton(
                        child: Text(
                          'Sign Out',
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        onPressed: () async {
                          Provider.of<MessageProvider>(context, listen: false)
                              .setSelectedItem(0);
                          await auth.signOut();
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.only(bottom: 20),
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Regma v1.0.0',
                        style: GoogleFonts.quicksand(
                          color: Colors.black.withOpacity(.7),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget buildItem(String item, int index) {
    //index to route to the appropriate screen
    // Paid Media == 1
    // My Subscriptions == 2
    // Notification == 3
    // About Regma == 4
    // Terms and Conditions == 5
    // Regma Privacy == 6
    return InkWell(
      onTap: () {
        switch (index) {
          case 1:
            Navigator.of(context).pushNamed(PaidMediaScreen.routeName);
            break;
          case 2:
            Navigator.of(context).pushNamed(SubscriptionScreen.routeName);
            break;
          case 4:
            showAbout(context);
            break;
          case 5:
            showTermsAndConditions(context);
            break;
          case 6:
            showPrivacy(context);
            break;
          case 7:
            Navigator.of(context).pushNamed(ManageCoursesScreen.routeName);
            break;
          case 8:
            Navigator.of(context).pushNamed(
              MediaScreen.routeName,
              arguments: {
                'isEditing': true,
              },
            );
            break;
          default:
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item,
              style: GoogleFonts.quicksand(
                  color: Colors.black.withOpacity(.7), fontSize: 15),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.black.withOpacity(.7),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(MUser user) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user.profilePicURL == null)
              CircleAvatar(
                backgroundColor: myOrange.withOpacity(.7),
                foregroundImage: AssetImage('assets/images/profile.png'),
                radius: 35,
              ),
            if (user.profilePicURL != null)
              CircleAvatar(
                backgroundColor: myOrange.withOpacity(.7),
                backgroundImage: NetworkImage(user.profilePicURL),
                radius: 40,
              ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(UserProfileScreen.routeName);
                    },
                    child: Text(
                      'View Profile',
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      user.name + ' ' + user.surname,
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(.8),
                        fontSize: 15,
                      ),
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      user.email,
                      style: GoogleFonts.quicksand(
                        color: Colors.black.withOpacity(.4),
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget _buildAccountSettings(
      BuildContext context, bool isConstructing, MUser user) {
    return Column(
      children: [
        if (user != null)
          SwitchListTile.adaptive(
            value: user.isVisibleOnSearch,
            onChanged: (val) async {
              var result = await _confirmSettingsChange(context);
              if (result) {
                setState(() {
                  isVisible = val;
                });
                await Provider.of<AuthServiceProvider>(context, listen: false)
                    .setIsVisibleOnSearch(val);
              }
            },
            title: Text(
              'Enable visibility in search',
              style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),
        if (isConstructing) CupertinoActivityIndicator(),
        if (paymentOptions) buildItem('Paid Media', 1),
        if (paymentOptions) buildItem('My Subscriptions', 2),
        // buildItem('Notifications', 3),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _buildSupport() {
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        buildItem('About Regma', 4),
        buildItem('Terms and Conditions', 5),
        buildItem('Regma Privacy', 6),
      ],
    );
  }

  Widget _buildAdmin() {
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        buildItem('Manage Courses', 7),
        buildItem('Manage Media', 8),
        SwitchListTile.adaptive(
          value: paymentOptions,
          onChanged: (val) async {
            setState(() {
              paymentOptions = val;
            });
            await RegmaServices().setPaymentOptions(val);
            Provider.of<CoursesProvider>(context, listen: false)
                .setPaymentOptions(val);
            Provider.of<MediaProvider>(context, listen: false)
                .setPaymentOptions(val);
          },
          title: Text(
            'Enable Payment Options',
            style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
        SwitchListTile.adaptive(
          value: yearlySubscription,
          onChanged: (val) async {
            setState(() {
              yearlySubscription = val;
            });
            await RegmaServices().setYearlySubscription(val);
            Provider.of<CoursesProvider>(context, listen: false)
                .setYearlySubscription(val);
          },
          title: Text(
            'Enable Yearly Subscription Only',
            style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
