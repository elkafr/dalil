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
import 'package:dalil/custom_widgets/drop_down_list_selector/drop_down_list_selector.dart';
import 'dart:math' as math;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'package:dalil/providers/home_provider.dart';
import 'package:dalil/models/category.dart';
import 'package:dalil/models/city.dart';



import 'package:flutter/material.dart';

class ContactWithUsScreen2 extends StatefulWidget {
  @override
  _ContactWithUsScreen2State createState() => _ContactWithUsScreen2State();
}

class _ContactWithUsScreen2State extends State<ContactWithUsScreen2> with ValidationMixin {
  double _height = 0, _width = 0;
  final _formKey = GlobalKey<FormState>();
   ApiProvider _apiProvider = ApiProvider();
 bool _isLoading = false;
bool _initialRun = true;
  HomeProvider _homeProvider;
AuthProvider _authProvider;
 String _profs_name ='' ,_phone1 ='', _profs_cat_id ='' , _profs_city_id ='', _profs_about ='';


  Future<List<CategoryModel>> _categoryList;
  CategoryModel _selectedCategory;


  Future<List<City>> _cityList;
  City _selectedCity;



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
                    _profs_name= text;
                  },

                  hintTxt: "اسمك بالكامل",
                  validationFunc: validateUserName
                
                )),



          SizedBox(height: 15,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: _height * 0.04),
              width: _width,
              child: FutureBuilder<List<City>>(
                future: _cityList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.hasData) {
                      var cityList = snapshot.data.map((item) {
                        return new DropdownMenuItem<City>(
                          child: new Text(item.cityName),
                          value: item,
                        );
                      }).toList();
                      cityList.removeAt(0);

                      return DropDownListSelector(
                        dropDownList: cityList,
                        marg: .01,
                        hint: AppLocalizations.of(context).translate('choose_city'),
                        onChangeFunc: (newValue) {

                          setState(() {
                            _selectedCity = newValue;
                            _homeProvider.setSelectedCity(newValue);
                          });
                        },
                        value: _selectedCity,
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),


            SizedBox(height: 15,),

            Container(
              margin: EdgeInsets.symmetric(horizontal: _height * 0.04),
              width: _width,
              child: FutureBuilder<List<CategoryModel>>(
                future: _categoryList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.hasData) {
                      var categoryList = snapshot.data.map((item) {
                        return new DropdownMenuItem<CategoryModel>(
                          child: new Text(item.catName),
                          value: item,
                        );
                      }).toList();
                      categoryList.removeAt(0);
                      return DropDownListSelector(
                        dropDownList: categoryList,
                        hint: AppLocalizations.of(context).translate('choose_category'),
                        marg: .01,
                        onChangeFunc: (newValue) {
                          setState(() {
                            _selectedCategory = newValue;
                            _homeProvider.setAge(_selectedCategory.catId);


                          });
                        },
                        value: _selectedCategory,
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),


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


            SizedBox(height: 15,),







            CustomTextFormField(
              maxLines: 3,
              onChangedFunc: (text){
                _profs_about = text;
              },
              hintTxt: "ملاحظات ( اختياري )",
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
                      .post("https://dalelalmahn.com/proffessionals/api_addjob", body: {
                    "profs_name":  _profs_name,
                    "phone1": _phone1,
                     //"phone2": _phone2,
                    "profs_cat_id": _homeProvider.age,
                    "profs_city_id": _homeProvider.selectedCity.cityId,
                    "profs_about":_profs_about

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
      _homeProvider = Provider.of<HomeProvider>(context);
      _categoryList = _homeProvider.getCategoryList(categoryModel:  CategoryModel(isSelected:true ,catId: '0',catName:
      _homeProvider.currentLang=="ar"?"الكل":"All",catImage: 'assets/images/all.png'),enableSub: false);

      _cityList = _homeProvider.getCityList(city:  City(isSelected:true ,cityId: '0',cityName:
      _homeProvider.currentLang=="ar"?"الكل":"All"),enableCountry: false);

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
      title:    Text("أضف مهنتك",
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
