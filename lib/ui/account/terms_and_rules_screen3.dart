import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dalil/custom_widgets/safe_area/page_container.dart';
import 'package:dalil/locale/app_localizations.dart';
import 'package:dalil/providers/auth_provider.dart';
import 'package:dalil/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:dalil/providers/terms_provider.dart';
import 'package:dalil/utils/error.dart';
import 'dart:math' as math;

import 'package:dalil/custom_widgets/MainDrawer.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

class TermsAndRulesScreen3 extends StatefulWidget {
  @override
  _TermsAndRulesScreen3State createState() => _TermsAndRulesScreen3State();
}

class _TermsAndRulesScreen3State extends State<TermsAndRulesScreen3> {
double _height = 0 , _width = 0;


Widget _buildBodyItem(){
  return ListView(
   
    children: <Widget>[
      SizedBox(
        height: 80,
      ),
  Image.asset(
  'assets/images/toplogo.png',cacheHeight: 100,width: 250,
  ),

        Container(
            margin: EdgeInsets.symmetric(horizontal: _width *0.04),
            child: Divider(),
         ),

      SizedBox(
        height: 20,
      ),

      FutureBuilder<String>(
          future: Provider.of<TermsProvider>(context,
              listen: false)
              .getTerms3() ,
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
                  return Container(
                      margin:
                      EdgeInsets.symmetric(horizontal: _width * 0.04),
                      child: Html(data: snapshot.data));
                }
            }
            return Center(
              child: SpinKitFadingCircle(color: mainAppColor),
            );
          })

        
    ],
  );
}

@override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;

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
      title:    Text("سياسة الخصوصية",
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