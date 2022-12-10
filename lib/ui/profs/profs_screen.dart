


import 'package:dalil/custom_widgets/MainDrawer.dart';
import 'package:dalil/custom_widgets/buttons/custom_button.dart';
import 'package:dalil/models/profs.dart';
import 'package:dalil/models/request.dart';
import 'package:dalil/ui/account/more_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dalil/custom_widgets/no_data/no_data.dart';
import 'package:dalil/custom_widgets/safe_area/page_container.dart';
import 'package:dalil/locale/app_localizations.dart';
import 'package:dalil/models/ad.dart';
import 'package:dalil/providers/auth_provider.dart';
import 'package:dalil/providers/my_ads_provider.dart';
import 'package:dalil/providers/navigation_provider.dart';
import 'package:dalil/providers/home_provider.dart';
import 'package:dalil/ui/my_ads/widgets/my_ad_item.dart';
import 'package:dalil/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:dalil/utils/error.dart';
import 'package:dalil/ui/add_ad/widgets/add_ad_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dalil/ui/ad_details/ad_details_screen.dart';


import 'dart:math' as math;
class ProfsScreen extends StatefulWidget {
  @override
  _ProfsScreenState createState() => _ProfsScreenState();
}

class _ProfsScreenState extends State<ProfsScreen>  with TickerProviderStateMixin{
double _height = 0 , _width = 0;
NavigationProvider _navigationProvider;
HomeProvider _homeProvider;
AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


Widget _buildBodyItem(){
  return ListView(
    children: <Widget>[
         SizedBox(
            height: 20,
          ),
              Container(
          height: _height - 80,
          width: _width,
          child:  FutureBuilder<List<Profs>>(
                  future:  Provider.of<MyAdsProvider>(context,
                          listen: true)
                      .getMyAdsList1() ,
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
                            errorMessage: AppLocalizations.of(context).translate('error'),
                            
                          );
                        } else {
                          if (snapshot.data.length > 0) {
                     return     ListView.builder(
            itemCount: snapshot.data.length,
             itemBuilder: (BuildContext context, int index) {
               var count = snapshot.data.length;
                      var animation = Tween(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: Interval((1 / count) * index, 1.0,
                              curve: Curves.fastOutSlowIn),
                        ),
                      );
                      _animationController.forward();
               return Container(
                 height: 230,
                 width: _width,
                 child: Container(
                   margin: EdgeInsets.fromLTRB(10,0,10,15),
                   padding:  EdgeInsets.all(10),
                   decoration: BoxDecoration(

                     border: Border.all(width: 1.0, color: Color(0xffDCDCDC)),
                     borderRadius: BorderRadius.all(Radius.circular(15.0)),
                     color: Color(0xffF5F5F5),
                     boxShadow: [
                       BoxShadow(
                         color: Colors.grey.withOpacity(0.4),

                         blurRadius: 2,
                       ),
                     ],

                   ),
                   child: Column(
                     children: <Widget>[
                       Row(
                         children: <Widget>[
                           Text("الاسم :  ",style: TextStyle(color: Color(0xff1DC473),fontSize: 14,fontWeight: FontWeight.bold),),
                           Text(snapshot.data[index].profsName)
                         ],
                       ),

                       Row(
                         children: <Widget>[
                           Text("المدينة :  ",style: TextStyle(color: Color(0xff1DC473),fontSize: 14,fontWeight: FontWeight.bold),),
                           Text(snapshot.data[index].cityName)
                         ],
                       ),

                       Row(
                         children: <Widget>[
                           Text("المهنة :  ",style: TextStyle(color: Color(0xff1DC473),fontSize: 14,fontWeight: FontWeight.bold),),
                           Text(snapshot.data[index].catName)
                         ],
                       ),


                       Row(
                         children: <Widget>[
                           Text("رقم لجوال :  ",style: TextStyle(color: Color(0xff1DC473),fontSize: 14,fontWeight: FontWeight.bold),),
                           GestureDetector(
                             child: Text(snapshot.data[index].profsPhone),
                             onTap: (){
                               launch("tel://${snapshot.data[index].profsPhone}");
                             },
                           )
                         ],
                       ),

                       Row(

                         children: <Widget>[
                           Text("ملاحظات :  ",style: TextStyle(color: Color(0xff1DC473),fontSize: 14,fontWeight: FontWeight.bold),),


                           Flexible(child: RichText(
                             overflow: TextOverflow.ellipsis,
                             maxLines: 1, // this will show dots(...) after 2 lines
                             strutStyle: StrutStyle(fontSize: 16.0),
                             text: TextSpan(
                                 style: TextStyle(fontSize: 16,color: Colors.black),
                                 text: snapshot.data[index].profsAbout
                             ),
                           )),

                         ],
                       ),

                       snapshot.data[index].moreId!="false"?Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(


                            width: _width*.37,
                            height: 50,
                            child:  CustomButton(

                              btnLbl: "المزيد",
                              btnColor: mainAppColor,
                              onPressedFunction: (){


                                _homeProvider.setMoreId(int.parse(snapshot.data[index].profsId));
                                _homeProvider.setMoreTitle(snapshot.data[index].moreTitle);

                                print(_homeProvider.moreId);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MoreScreen()));

                              },
                            ),
                          )
                        ],
                      ):Text("")
                     ],
                   ),
                 ));
             }
          );
                          } else {
                            return NoData(message: AppLocalizations.of(context).translate('no_results'));
                          }
                        }
                    }
                    return Center(
                      child: SpinKitFadingCircle(color: mainAppColor),
                    );
                  })
        
        )
    ],
  );
}


@override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _navigationProvider = Provider.of<NavigationProvider>(context);
    _homeProvider = Provider.of<HomeProvider>(context);


    final appBar = AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Image.asset("assets/images/menu.png"),
          onPressed: () => Scaffold.of(context).openDrawer(),
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
      ),
      title:    Text("جميع المهن",
          style: Theme.of(context).textTheme.headline1),
    );



    return PageContainer(
      child: Scaffold(
          appBar: appBar,
          drawer: MainDrawer(),
          body: Stack(

        children: <Widget>[
          _buildBodyItem(),


        ],
      )),
    );
  }
}