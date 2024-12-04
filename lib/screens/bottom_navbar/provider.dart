import 'package:flutter/material.dart';

class BottomNavBarProvider with ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void changeTheIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}