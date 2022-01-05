import 'package:flutter/material.dart';

class MessageProvider with ChangeNotifier {
  int selectedItem = 0; //to select Message page after a push notification

  void setSelectedItem(int val) {
    selectedItem = val;
    notifyListeners();
  }
}
