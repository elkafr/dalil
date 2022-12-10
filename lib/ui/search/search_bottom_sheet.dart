import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dalil/custom_widgets/buttons/custom_button.dart';
import 'package:dalil/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:dalil/custom_widgets/custom_text_form_field/validation_mixin.dart';
import 'package:dalil/custom_widgets/drop_down_list_selector/drop_down_list_selector.dart';
import 'package:dalil/locale/app_localizations.dart';
import 'package:dalil/models/category.dart';
import 'package:dalil/models/city.dart';
import 'package:dalil/models/country.dart';
import 'package:dalil/providers/home_provider.dart';
import 'package:dalil/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:dalil/ui/search/search_screen.dart';

class SearchBottomSheet extends StatefulWidget {
  const SearchBottomSheet({Key key}) : super(key: key);
  @override
  _SearchBottomSheetState createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> with ValidationMixin
  {
  String _searchKey = '';
  String _priceFrom = '';
  String _priceTo = '';
  Future<List<City>> _cityList;
  Future<List<CategoryModel>> _categoryList;
  Future<List<CategoryModel>> _subList;
  City _selectedCity;
  Country _selectedCountry;
  CategoryModel _selectedCategory;
  bool _initialRun = true;
  HomeProvider _homeProvider;
  CategoryModel _selectedSub;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _homeProvider = Provider.of<HomeProvider>(context);
      _categoryList = _homeProvider.getCategoryList(categoryModel:  CategoryModel(isSelected:true ,catId: '0',catName:
      _homeProvider.currentLang=="ar"?"الكل":"All",catImage: 'assets/images/all.png'),enableSub: false);




      _cityList = _homeProvider.getCityList(city:  City(isSelected:true ,cityId: '0',cityName:
      _homeProvider.currentLang=="ar"?"الكل":"All"),enableCountry: false);
      _initialRun = false;
    }
  }

  Widget build(BuildContext context) {


    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus( FocusNode());
            },
            child: Container(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: ListView(children: <Widget>[

                Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      color: Color(0xff1DC473),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                    ),
                    child: Text(
                      "بحث عن مهنة",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    )),

                SizedBox(height: 35,),



                Container(
                    margin: EdgeInsets.symmetric(
                        vertical: constraints.maxHeight * 0.04),
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
                              marg: .07,
                              onChangeFunc: (newValue) {
                                setState(() {
                                  _selectedCategory = newValue;
                                  _homeProvider.setAge(_selectedCategory.catId);
                                  _subList = _homeProvider.getSubList(enableSub: true,catId:_homeProvider.age!=''?_homeProvider.age:"6");

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
                    )),



                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: constraints.maxHeight * 0.04),
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
                          return DropDownListSelector(
                            dropDownList: cityList,
                            marg: .07,
                            hint: AppLocalizations.of(context).translate('choose_city'),
                            onChangeFunc: (newValue) {
                              setState(() {
                                _selectedCity = newValue;
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







                CustomButton(
                  btnLbl:  AppLocalizations.of(context).translate('search'),
                  onPressedFunction: () {

                    _homeProvider.setEnableSearch(true);
                    _homeProvider.updateSelectedCategory(_selectedCategory);
                    _homeProvider.setAge(_selectedCategory.catId);
                    _homeProvider.setSelectedSub(_selectedSub);
                    _homeProvider.setSelectedCity(_selectedCity);
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SearchScreen()));


                  },
                ),
              ]),
            ),
          ));
    });
  }
}
