import 'package:dalil/ui/account/contact_with_us_screen1.dart';
import 'package:dalil/ui/account/contact_with_us_screen2.dart';
import 'package:dalil/ui/account/terms_and_rules_screen1.dart';
import 'package:dalil/ui/account/terms_and_rules_screen2.dart';
import 'package:dalil/ui/account/terms_and_rules_screen3.dart';
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

class MainDrawer extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {

    return new _MainDrawer();
  }
}

class _MainDrawer extends State<MainDrawer> {
  double _height = 0 , _width = 0;

  NavigationProvider _navigationProvider;
  AuthProvider _authProvider ;
  HomeProvider _homeProvider ;
  bool _initialRun = true;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _authProvider = Provider.of<AuthProvider>(context);
      _homeProvider = Provider.of<HomeProvider>(context);

      _initialRun = false;
    }
  }

  @override
  Widget build(BuildContext context) {



      return Drawer(
          elevation: 20,

          child: ListView(
            padding: EdgeInsets.zero,

            children: <Widget>[


              Container(
                decoration: new BoxDecoration(
                  image: new DecorationImage(image: new AssetImage("assets/images/drawer.png"), fit: BoxFit.cover,),
                ),
                alignment: Alignment.centerRight,
                padding: EdgeInsets.all(30),
              height: 114,


              ),

               Container(
                 color: hintColor,
                 height: 1,
                 margin: EdgeInsets.all(5),
                 width: _width,
               ),



              ListTile(
                onTap: (){
                  Navigator.pushReplacementNamed(context,  '/navigation');
                },
                dense:true,
                leading: Image.asset('assets/images/home.png',color: Color(0xff1DC473),),
                title: Text( "الرئيسية",style: TextStyle(
                    color: Colors.black,fontSize: 15
                ),),
              ),




              ListTile(
                onTap: ()=>    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AboutAppScreen())),
                dense:true,
                leading: Image.asset('assets/images/e1.png',color: Color(0xff1DC473),),
                title: Text( AppLocalizations.of(context).translate("about_app"),style: TextStyle(
                    color: Colors.black,fontSize: 15
                ),),
              ),


              ListTile(
                onTap: ()=>    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TermsAndRulesScreen1())),
                dense:true,
                leading: Image.asset('assets/images/e2.png',color: Color(0xff1DC473),),
                title: Text("كيف تعمل معنا",style: TextStyle(
                    color: Colors.black,fontSize: 15
                ),),
              ),



              ListTile(
                onTap: ()=>    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TermsAndRulesScreen2())),
                dense:true,
                leading: Image.asset('assets/images/e3.png',color: Color(0xff1DC473),),
                title: Text("لماذا دليل المهنيين المحترفين؟",style: TextStyle(
                    color: Colors.black,fontSize: 15
                ),),
              ),



              ListTile(
                onTap: ()=>    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TermsAndRulesScreen3())),
                dense:true,
                leading: Image.asset('assets/images/e4.png',color: Color(0xff1DC473),),
                title: Text("سياسة الخصوصية",style: TextStyle(
                    color: Colors.black,fontSize: 15
                ),),
              ),


              ListTile(
                onTap: ()=>    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TermsAndRulesScreen())),
                dense:true,
                leading: Image.asset('assets/images/e5.png',color: Color(0xff1DC473),),
                title: Text( AppLocalizations.of(context).translate("rules_and_terms"),style: TextStyle(
                    color: Colors.black,fontSize: 15
                ),),
              ),










              ListTile(
                onTap: ()=>    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ContactWithUsScreen())),
                dense:true,
                leading: Image.asset('assets/images/e6.png',color: Color(0xff1DC473),),
                title: Text("إتصل بنا ",style: TextStyle(
                    color: Colors.black,fontSize: 15
                ),),
              ),



              ListTile(
                onTap: ()=>    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ContactWithUsScreen2())),
                dense:true,
                leading: Image.asset('assets/images/e7.png',color: Color(0xff1DC473),),
                title: Text( " أضف مهنتك",style: TextStyle(
                    color: Colors.black,fontSize: 15
                ),),
              ),


              ListTile(
                onTap: ()=>    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ContactWithUsScreen1())),
                dense:true,
                leading: Image.asset('assets/images/e7.png',color: Color(0xff1DC473),),
                title: Text( "اضافة طلب",style: TextStyle(
                    color: Colors.black,fontSize: 15
                ),),
              ),






/*
              SizedBox(height: 25,),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: _width * 0.1, vertical: _height * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FutureBuilder<String>(
                        future: Provider.of<TermsProvider>(context,
                            listen: false)
                            .getTwitt() ,
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return Center(
                                child: SpinKitFadingCircle(color: mainAppColor),
                              );
                            case ConnectionState.active:
                              return Text('');
                            case ConnectionState.waiting:
                              return Center(
                                child: SpinKitFadingCircle(color: mainAppColor),
                              );
                            case ConnectionState.done:
                              if (snapshot.hasError) {
                                return Error(
                                  //  errorMessage: snapshot.error.toString(),
                                  errorMessage:  AppLocalizations.of(context).translate('error'),
                                );
                              } else {
                                return GestureDetector(
                                    onTap: () {
                                      launch(snapshot.data.toString());
                                    },
                                    child: Image.asset(
                                      'assets/images/twitter.png',
                                      height: 40,
                                      width: 40,
                                    ));
                              }
                          }
                          return Center(
                            child: SpinKitFadingCircle(color: mainAppColor),
                          );
                        })
                    ,
                    FutureBuilder<String>(
                        future: Provider.of<TermsProvider>(context,
                            listen: false)
                            .getLinkid() ,
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return Center(
                                child: SpinKitFadingCircle(color: mainAppColor),
                              );
                            case ConnectionState.active:
                              return Text('');
                            case ConnectionState.waiting:
                              return Center(
                                child: SpinKitFadingCircle(color: mainAppColor),
                              );
                            case ConnectionState.done:
                              if (snapshot.hasError) {
                                return Error(
                                  //  errorMessage: snapshot.error.toString(),
                                  errorMessage:  AppLocalizations.of(context).translate('error'),
                                );
                              } else {
                                return GestureDetector(
                                    onTap: () {
                                      launch(snapshot.data.toString());
                                    },
                                    child: Image.asset(
                                      'assets/images/linkedin.png',
                                      height: 40,
                                      width: 40,
                                    ));
                              }
                          }
                          return Center(
                            child: SpinKitFadingCircle(color: mainAppColor),
                          );
                        }),
                    FutureBuilder<String>(
                        future: Provider.of<TermsProvider>(context,
                            listen: false)
                            .getInst() ,
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return Center(
                                child: SpinKitFadingCircle(color: mainAppColor),
                              );
                            case ConnectionState.active:
                              return Text('');
                            case ConnectionState.waiting:
                              return Center(
                                child: SpinKitFadingCircle(color: mainAppColor),
                              );
                            case ConnectionState.done:
                              if (snapshot.hasError) {
                                return Error(
                                  //  errorMessage: snapshot.error.toString(),
                                  errorMessage:  AppLocalizations.of(context).translate('error'),
                                );
                              } else {
                                return GestureDetector(
                                    onTap: () {
                                      launch(snapshot.data.toString());
                                    },
                                    child: Image.asset(
                                      'assets/images/instagram.png',
                                      height: 40,
                                      width: 40,
                                    ));
                              }
                          }
                          return Center(
                            child: SpinKitFadingCircle(color: mainAppColor),
                          );
                        }),
                    FutureBuilder<String>(
                        future: Provider.of<TermsProvider>(context,
                            listen: false)
                            .getFace() ,
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return Center(
                                child: SpinKitFadingCircle(color: mainAppColor),
                              );
                            case ConnectionState.active:
                              return Text('');
                            case ConnectionState.waiting:
                              return Center(
                                child: SpinKitFadingCircle(color: mainAppColor),
                              );
                            case ConnectionState.done:
                              if (snapshot.hasError) {
                                return Error(
                                  //  errorMessage: snapshot.error.toString(),
                                  errorMessage:  AppLocalizations.of(context).translate('error'),
                                );
                              } else {
                                return GestureDetector(
                                    onTap: () {
                                      launch(snapshot.data.toString());
                                    },
                                    child: Image.asset(
                                      'assets/images/facebook.png',
                                      height: 40,
                                      width: 40,
                                    ));
                              }
                          }
                          return Center(
                            child: SpinKitFadingCircle(color: mainAppColor),
                          );
                        }),
                  ],
                ),
              ),
              */




              
              
              

            ],
          ));



  }
}
