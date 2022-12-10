import 'package:dalil/ui/profs/profs_screen.dart';
import 'package:dalil/ui/request/request_screen.dart';
import 'package:flutter/material.dart';
import 'package:dalil/ui/my_chats/my_chats_screen.dart';
import 'package:dalil/ui/add_ad/add_ad_screen.dart';
import 'package:dalil/ui/favourite/favourite_screen.dart';
import 'package:dalil/ui/home/home_screen.dart';
import 'package:dalil/ui/notification/notification_screen.dart';

class NavigationProvider extends ChangeNotifier {
  int _navigationIndex = 0;

  void upadateNavigationIndex(int value) {
    _navigationIndex = value;
    notifyListeners();
  }

  int get navigationIndex => _navigationIndex;

  List<Widget> _screens = [
    HomeScreen() ,
    ProfsScreen(),
    RequestScreen()
  ];

  Widget get selectedContent => _screens[_navigationIndex];

  bool _mapIsActive = false;

  void setMapIsActive(bool value) {
    _mapIsActive = value;
    notifyListeners();
  }

  bool get mapIsActive => _mapIsActive;
}
