import 'package:flutter/material.dart';

// ignore: must_be_immutable
//
//
class RegmaAppBar extends AppBar {
  BuildContext context;
  Size size;
  Widget leading;
  Widget iconsRow;
  Widget bartitle;
  Color backgroundColor;
  double leadingWidth;
  Widget flexibleSpace;
  Widget topCenterWidget;
  List<Widget> actions;
  RegmaAppBar(
      {@required this.context,
      this.topCenterWidget,
      this.backgroundColor,
      this.leading,
      this.size,
      this.leadingWidth,
      this.flexibleSpace,
      this.iconsRow,
      this.bartitle,
      this.actions})
      : super(
          title: topCenterWidget,
          leadingWidth: leadingWidth,
          backgroundColor: backgroundColor,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          flexibleSpace: flexibleSpace,
          bottom: PreferredSize(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  bartitle,
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 50,
                  )
                ],
              ),
              preferredSize: size == null
                  ? Size(
                      MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.height / 7.5,
                    )
                  : size),
          elevation: 0.0,
          //automaticallyImplyLeading: false,
          leading: leading,
          actions: actions,
        );

  double get statusBarHeight => MediaQuery.of(context).padding.top;
  @override
  Size get preferredSize => size == null
      ? Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 7.5,
        )
      : size;
}
