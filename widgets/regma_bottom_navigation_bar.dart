import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/colors.dart';
import '../providers/message_provider.dart';

class RegmaBottomNavigationBar extends StatefulWidget {
  // final Function(int) onChange;
  // final int currentIndex;
  RegmaBottomNavigationBar();

  @override
  _RegmaBottomNavigationBarState createState() =>
      _RegmaBottomNavigationBarState();
}

class _RegmaBottomNavigationBarState extends State<RegmaBottomNavigationBar> {
  var _selectedIndex = 0;
  var w = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _selectedIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    return Container(
      height: w >= 400 ? 50 : 40,
      decoration: BoxDecoration(
        // boxShadow: [
        //   BoxShadow(
        //     offset: Offset(1, 1),
        //     blurRadius: 1,
        //     color: Colors.transparent.withOpacity(0.3),
        //   ),
        //   BoxShadow(
        //     offset: Offset(-1, 1),
        //     blurRadius: 1,
        //     color: myOrange,
        //   ),
        // ],
        color: Colors.white38,
      ),
      child: Row(
        children: [
          _navBarItem(Icons.school, 'Courses', 0),
          _navBarItem(Icons.cast_for_education, 'Classroom', 1),
          _navBarItem(Icons.subscriptions, 'Media', 2),
          _navBarItem(Icons.chat, 'Message', 3),
          _navBarItem(Icons.settings, 'Settings', 4),
        ],
      ),
    );
  }

  Widget _navBarItem(IconData icon, String title, int index) {
    return Consumer<MessageProvider>(builder: (_, msg, __) {
      _selectedIndex = msg.selectedItem;
      return Expanded(
        child: InkWell(
          onTap: () {
            // widget.onChange(index);
            // setState(() {
            //   _selectedIndex = index;
            // });

            Provider.of<MessageProvider>(context, listen: false)
                .setSelectedItem(index);
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            decoration: BoxDecoration(
              border: index == _selectedIndex
                  ? Border(
                      top: BorderSide(width: 1, color: myOrange),
                    )
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: w >= 410 ? 24 : 15,
                  color:
                      index == _selectedIndex ? myOrange : Colors.grey.shade500,
                ),
                Text(
                  title,
                  style: TextStyle(
                      color: index == _selectedIndex
                          ? myOrange
                          : Colors.grey.shade500,
                      fontSize: w >= 410 ? 14 : 10),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
