import 'package:dalil/ui/home/home_screen.dart';
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
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'package:flutter/material.dart';

class ContactWithUsScreen1 extends StatefulWidget {
  @override
  _ContactWithUsScreen1State createState() => _ContactWithUsScreen1State();
}

class _ContactWithUsScreen1State extends State<ContactWithUsScreen1> with ValidationMixin {
  double _height = 0, _width = 0;
  final _formKey = GlobalKey<FormState>();
   ApiProvider _apiProvider = ApiProvider();
 bool _isLoading = false;
bool _initialRun = true;
AuthProvider _authProvider;
 String _name ='' ,_phone1 ='', _phone2 ='' , _title ='', _content ='';

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'SA';
  PhoneNumber number = PhoneNumber(isoCode: 'SA');

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
    await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'SA');

    setState(() {
      this.number = number;
    });
  }

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
            SizedBox(height: 25,),
            Container(
                margin: EdgeInsets.only(top: _height * 0.02),
                child: CustomTextFormField(


                  onChangedFunc: (text){
                    _name= text;
                  },

                  hintTxt: "اسمك بالكامل",
                  validationFunc: validateUserName
                
                )),

        SizedBox(height: 15,),
        Container(
          margin: EdgeInsets.symmetric(horizontal: _height * 0.04),
          child:  InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber number) {
              print(number.phoneNumber);
              _phone1=number.phoneNumber;
            },
            onInputValidated: (bool value) {
              print(value);
            },
            selectorConfig: SelectorConfig(
              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
            ),
            ignoreBlank: false,

            selectorTextStyle: TextStyle(color: Colors.black),
            initialValue: number,
            textFieldController: controller,
            formatInput: false,



            inputDecoration: new InputDecoration(
              hintText:"رقم الهاتف",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.red,
                      width: 5.0),
                ),

              contentPadding:
              EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0,top: 10.0),
            ),

          ),
        ),






            Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.02),
              child: CustomTextFormField(


                  onChangedFunc: (text){
                    _title = text;
                  },

                  hintTxt: "عنوان الطلب",
                  validationFunc: validateUserName
              ),
            ),


            CustomTextFormField(
              maxLines: 3,
              onChangedFunc: (text){
                _content = text;
              },
              hintTxt: "تفاصيل الطلب",
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
                      .post("https://dalelalmahn.com/request/api_addRequest", body: {
                    "name":  _name,
                    "phone1": _phone1,
                     //"phone2": _phone2,
                    "title": _title,
                    "content":_content

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
      title:    Text("اضافة طلب",
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
