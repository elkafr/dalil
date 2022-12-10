import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dalil/custom_widgets/buttons/custom_button.dart';
import 'package:dalil/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:dalil/custom_widgets/custom_text_form_field/validation_mixin.dart';
import 'package:dalil/custom_widgets/safe_area/page_container.dart';
import 'package:dalil/locale/app_localizations.dart';
import 'package:dalil/networking/api_provider.dart';
import 'package:dalil/providers/auth_provider.dart';
import 'package:dalil/utils/app_colors.dart';
import 'package:dalil/utils/commons.dart';
import 'package:dalil/utils/urls.dart';
import 'package:provider/provider.dart';
import 'package:dalil/custom_widgets/MainDrawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

class ContactWithUsScreen extends StatefulWidget {
  @override
  _ContactWithUsScreenState createState() => _ContactWithUsScreenState();
}

class _ContactWithUsScreenState extends State<ContactWithUsScreen> with ValidationMixin {
  double _height = 0, _width = 0;
  final _formKey = GlobalKey<FormState>();
   ApiProvider _apiProvider = ApiProvider();
 bool _isLoading = false;
bool _initialRun = true;
AuthProvider _authProvider;
 String _userName ='' ,_userEmail ='', _title ='' , _message ='';

  Widget _buildBodyItem() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            Image.asset(
              'assets/images/toplogo.png',cacheHeight: 100,width: 250,
            ),
            Container(
                margin: EdgeInsets.only(top: _height * 0.02),
                child: CustomTextFormField(


                  onChangedFunc: (text){
                    _userName = text;
                  },

                  hintTxt: AppLocalizations.of(context).translate('user_name'),
                  validationFunc: validateUserName
                
                )),
            Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.02),
              child: CustomTextFormField(


                onChangedFunc: (text){
                  _userEmail = text;
                },

                hintTxt: AppLocalizations.of(context).translate('email'),
                validationFunc: validateUserEmail
              ),
            ),


            Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.02),
              child: CustomTextFormField(


                  onChangedFunc: (text){
                    _title = text;
                  },

                  hintTxt: "عنوان الرسالة",
                  validationFunc: validateUserName
              ),
            ),


            CustomTextFormField(
              maxLines: 3,
              onChangedFunc: (text){
                _message = text;
              },
              hintTxt: AppLocalizations.of(context).translate('message'),
              validationFunc:  validateMsg,
            ),
            Container(
              margin: EdgeInsets.only(top: _height *0.02,bottom: _height *0.02),
              child: _buildSendBtn()
            ),



          ],
        ),
      ),
    );
  }

Widget _buildSendBtn() {
    return _isLoading
        ? Center(
            child:SpinKitFadingCircle(color: mainAppColor),
          )
        : CustomButton(
              btnLbl: AppLocalizations.of(context).translate('send'),
              onPressedFunction: () async {
                if (_formKey.currentState.validate()) {

                  setState(() {
                    _isLoading = true;
                  });
                 final results = await _apiProvider
                      .post("https://dalelalmahn.com/contact/api_index", body: {
                    "contact_name":  _userName,
                    "contact_email": _userEmail,
                    "contact_title": _title,
                    "contact_message":_message

                  });
               
            setState(() => _isLoading = false);
                  if (results['response'] == "1") {
                    Commons.showToast(context, message:results["message"]);
                    Navigator.pushReplacementNamed(context,  '/navigation');

                      
                  } else {
                    Commons.showError(context, results["message"]);

                  }
                   
                }
              },
            );
  }

 



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _authProvider = Provider.of<AuthProvider>(context);

     _initialRun = false;
    }
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
      title:    Text( AppLocalizations.of(context).translate('contact_us'),
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
