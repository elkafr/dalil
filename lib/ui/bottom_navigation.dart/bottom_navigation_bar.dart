import 'dart:io';

import 'package:dalil/ui/request/request_screen.dart';
import 'package:dalil/ui/search/search_bottom_sheet.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:dalil/custom_widgets/connectivity/network_indicator.dart';
import 'package:dalil/locale/app_localizations.dart';
import 'package:dalil/models/user.dart';
import 'package:dalil/providers/auth_provider.dart';
import 'package:dalil/providers/navigation_provider.dart';
import 'package:dalil/shared_preferences/shared_preferences_helper.dart';
import 'package:dalil/ui/add_ad/widgets/add_ad_bottom_sheet.dart';
import 'package:dalil/utils/app_colors.dart';

import 'package:provider/provider.dart';


import 'package:dalil/ui/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dalil/utils/app_colors.dart';
import 'package:dalil/custom_widgets/dialogs/log_out_dialog.dart';
import 'package:dalil/custom_widgets/safe_area/page_container.dart';
import 'package:dalil/locale/app_localizations.dart';
import 'package:dalil/providers/auth_provider.dart';
import 'package:dalil/providers/home_provider.dart';
import 'package:dalil/providers/navigation_provider.dart';
import 'package:dalil/shared_preferences/shared_preferences_helper.dart';
import 'package:dalil/ui/account/about_app_screen.dart';
import 'package:dalil/ui/account/app_commission_screen.dart';
import 'package:dalil/ui/account/contact_with_us_screen.dart';
import 'package:dalil/ui/account/language_screen.dart';
import 'package:dalil/ui/account/personal_information_screen.dart';
import 'package:dalil/ui/account/terms_and_rules_Screen.dart';
import 'package:dalil/ui/my_ads/my_ads_screen.dart';
import 'package:dalil/ui/notification/notification_screen.dart';
import 'package:dalil/ui/favourite/favourite_screen.dart';
import 'package:dalil/ui/my_chats/my_chats_screen.dart';
import 'package:dalil/ui/home/home_screen.dart';
import 'package:dalil/ui/blacklist/blacklist_screen.dart';
import 'package:dalil/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dalil/custom_widgets/safe_area/page_container.dart';
import 'package:dalil/locale/app_localizations.dart';
import 'package:dalil/providers/auth_provider.dart';
import 'package:dalil/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:dalil/providers/terms_provider.dart';
import 'package:dalil/utils/error.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
 bool _initialRun = true;
   AuthProvider _authProvider;
 NavigationProvider _navigationProvider;
 HomeProvider _homeProvider ;

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  void _iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  void _firebaseCloudMessagingListeners() {
    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android, ios);
    _flutterLocalNotificationsPlugin.initialize(platform);
 
    if (Platform.isIOS) _iOSPermission();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        _showNotification(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');

        Navigator.pushNamed(context, '/notification_screen');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');

        Navigator.pushNamed(context, '/notification_screen');
      },
    );
  }


 Future onSelectNotification(String payload) async {

   if (payload != null) {

     Navigator.push(
       context,
       MaterialPageRoute(builder: (context) {
         return NotificationScreen();
       }),
     );

   }
   print("notificationClicked");


 }


  _showNotification(Map<String, dynamic> message) async {
    var android = new AndroidNotificationDetails(
      'channel id',
      "CHANNLE NAME",
      "channelDescription",
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await _flutterLocalNotificationsPlugin.show(
        0,
        message['notification']['title'],
        message['notification']['body'],
        platform);
  }



  Future<Null> _checkIsLogin() async {
    var userData = await SharedPreferencesHelper.read("user");
    if (userData != null) {
      _authProvider.setCurrentUser(User.fromJson(userData));
  _firebaseCloudMessagingListeners();
    }
   
  }
  


 

 @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) { 
      _authProvider = Provider.of<AuthProvider>(context);
      _homeProvider = Provider.of<HomeProvider>(context);
       _checkIsLogin();
       _initialRun = false;
      
    }
  }



  @override
  Widget build(BuildContext context) {
    _navigationProvider = Provider.of<NavigationProvider>(context);
    return NetworkIndicator(
        child: Scaffold(
      body: _navigationProvider.selectedContent,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/home.png',
            ),
            activeIcon: Image.asset(
              'assets/images/home.png',
            ) ,
            title: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  _authProvider.currentLang=="ar"?"الرئيسية":"Home",
                  style: TextStyle(fontSize: 13.0,color: Colors.black),
                )),
          ),
          BottomNavigationBarItem(
            icon:  Image.asset(
              'assets/images/profs.png',
            ),
             activeIcon:Image.asset(
               'assets/images/profs.png',
             ) ,
            title: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  _authProvider.currentLang=="ar"?"بحث عن مهنة":"Home",
                  style: TextStyle(fontSize: 13.0,color: Colors.black),
                )),
          ),



          BottomNavigationBarItem(
            icon:  Image.asset(
              'assets/images/request.png',
            ),
            activeIcon:Image.asset(
              'assets/images/request.png',
            ) ,
            title: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  _authProvider.currentLang=="ar"?"جميع الطلبات":"Home",
                  style: TextStyle(fontSize: 13.0,color: Colors.black),
                )),
          ),


        
        ],
        currentIndex: _navigationProvider.navigationIndex,
        selectedItemColor: mainAppColor,
        unselectedItemColor: Color(0xFFC4C4C4),
        onTap: (int index) {

          if(index == 1){
            showModalBottomSheet<dynamic>(
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                context: context,
                builder: (builder) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: SearchBottomSheet());
                });
          }else{
            _navigationProvider.upadateNavigationIndex(index);
          }

          
        },
        elevation: 5,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
      ),
    ));
  }
}
