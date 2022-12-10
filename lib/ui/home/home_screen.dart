

import 'package:dalil/models/profs.dart';
import 'package:dalil/ui/account/contact_with_us_screen1.dart';
import 'package:dalil/ui/account/contact_with_us_screen2.dart';
import 'package:dalil/ui/account/more_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dalil/custom_widgets/ad_item/ad_item.dart';
import 'package:dalil/custom_widgets/no_data/no_data.dart';
import 'package:dalil/custom_widgets/safe_area/page_container.dart';
import 'package:dalil/locale/app_localizations.dart';
import 'package:dalil/custom_widgets/buttons/custom_button.dart';
import 'package:dalil/models/ad.dart';
import 'package:dalil/models/category.dart';
import 'package:dalil/models/city.dart';
import 'package:dalil/models/marka.dart';
import 'package:dalil/models/model.dart';
import 'package:dalil/providers/home_provider.dart';
import 'package:dalil/providers/navigation_provider.dart';
import 'package:dalil/ui/ad_details/ad_details_screen.dart';
import 'package:dalil/ui/home/widgets/category_item.dart';
import 'package:dalil/ui/home/widgets/map_widget.dart';
import 'package:dalil/ui/search/search_bottom_sheet.dart';
import 'package:dalil/providers/my_ads_provider.dart';
import 'package:dalil/utils/app_colors.dart';
import 'package:dalil/ui/account/account_screen.dart';
import 'package:provider/provider.dart';
import 'package:dalil/utils/error.dart';
import 'package:dalil/providers/navigation_provider.dart';
import 'package:dalil/providers/auth_provider.dart';
import 'package:dalil/custom_widgets/drop_down_list_selector/drop_down_list_selector.dart';
import 'package:dalil/custom_widgets/MainDrawer.dart';
import 'package:dalil/ui/search/search_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  double _height = 0, _width = 0;
  NavigationProvider _navigationProvider;

 Future<List<CategoryModel>> _subList;
  bool _initialRun = true;
  HomeProvider _homeProvider;
  AnimationController _animationController;
  AuthProvider _authProvider;


  Future<List<CategoryModel>> _categoryList;
  CategoryModel _selectedCategory;

  Future<List<City>> _cityList;
  City _selectedCity;

  Future<List<Marka>> _markaList;
  Marka _selectedMarka;

  Future<List<Model>> _modelList;
  Model _selectedModel;

  CategoryModel _selectedSub;
  String _selectedCat;
  bool _isLoading = false;

  String _xx=null;
  String omar="";

  @override
  void initState() {
    _animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    super.initState();

  }
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


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildBodyItem() {
    return ListView(

      children: <Widget>[


        Image.asset(
          'assets/images/a1.png',
        ),


       Container(
         width: _width,
         margin: EdgeInsets.all(10),
         child:  Row(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: <Widget>[


             Container(

               width: _width*.33,
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
                         marg: .01,
                         hint: AppLocalizations.of(context).translate('choose_city'),
                         onChangeFunc: (newValue) {
                           setState(() {
                             _selectedCity = newValue;
                           });
                           _homeProvider.setSelectedCity(_selectedCity);
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




             Container(

               width: _width*.33,
               child: FutureBuilder<List<CategoryModel>>(
                 future: _categoryList,
                 builder: (context, snapshot) {
                   if (snapshot.hasData) {
                     if (snapshot.hasData) {
                       var categoryList = snapshot.data.map((item) {
                         return new DropdownMenuItem<CategoryModel>(
                           child: new Column(
                             children: <Widget>[
                               Text(item.catName),
                               Container(
                                 height: 1,
                                 color: Colors.grey,
                               )
                             ],
                           ),
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
               ),
             ),


             CustomButton(

               height: 30,

               btnLbl:  AppLocalizations.of(context).translate('search'),
               onPressedFunction: () {
                 _homeProvider.setEnableSearch(true);
                 _homeProvider.updateSelectedCategory(_selectedCategory);
                 _homeProvider.setAge(_selectedCategory.catId);
                 _homeProvider.setSelectedSub(_selectedSub);
                 _homeProvider.setSelectedCity(_selectedCity);
                // Navigator.pop(context);
                 Navigator.pushReplacement(
                     context,
                     MaterialPageRoute(
                         builder: (context) =>
                             SearchScreen()));

               },
               borderColor: Color(0xffF8CD63),
             ),

           ],
         ),
       ),

     SizedBox(height: 8,),
      Container(
        alignment: Alignment.topCenter,
        child:  Text("ابحث عن مهنيين محترفين في 3 خطوات فقط",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),)
      ),
        SizedBox(height: 8,),

        Image.asset(
          'assets/images/a2.png',
        ),

        GestureDetector(
          child: Image.asset(
            'assets/images/a3.png',
          ),
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ContactWithUsScreen2()));
          },
        ),

        Image.asset(
          'assets/images/a4.png',
        ),

        GestureDetector(
          child: Image.asset(
            'assets/images/a5.png',
          ),
          onTap: (){
         Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ContactWithUsScreen1()));
          },
        ),




        Container(
            height: _height * 0.40,
            padding: EdgeInsets.fromLTRB(5,5,5,0),
            child: FutureBuilder<List<Profs>>(
                future:  Provider.of<MyAdsProvider>(context,
                    listen: true)
                    .getAdsFeatured() ,
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
                          errorMessage: "حدث خطأ ما ",
                        );
                      } else {
                        if (snapshot.data.length > 0) {
                          return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {

                                return Consumer<HomeProvider>(
                                    builder: (context, homeProvider, child) {
                                      return InkWell(
                                        onTap: (){


                                          _homeProvider.setMoreId(int.parse(snapshot.data[index].profsId));
                                          _homeProvider.setMoreTitle(snapshot.data[index].moreTitle);

                                          print(_homeProvider.moreId);

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => MoreScreen()));


                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Color(0xffFFF3D6),
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(15),
                                                bottomRight: Radius.circular(15),
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15),
                                            ),),
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.all(10),

                                          width: _width * 0.45,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[

                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(100.0),
                                                child: Image.network(
                                                  snapshot.data[index].photo,
                                                  height:100,
                                                  width: 100,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                          SizedBox(height: 10,),
                                          RichText(
                                          overflow: TextOverflow.ellipsis,
                                            maxLines: 1, // this will show dots(...) after 2 lines
                                            strutStyle: StrutStyle(fontSize: 13.0),
                                            text: TextSpan(
                                                style: TextStyle(fontSize: 13,color: Colors.black,fontWeight: FontWeight.bold,),
                                                text: snapshot.data[index].profsName
                                            ),
                                          ),


                                              Flexible(child: RichText(
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1, // this will show dots(...) after 2 lines
                                                strutStyle: StrutStyle(fontSize: 11.0),
                                                text: TextSpan(
                                                    style: TextStyle(fontSize: 12,color: mainAppColor),
                                                    text: snapshot.data[index].profsAbout
                                                ),
                                              )),


                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(Icons.person,size: 11,color: Colors.black,),
                                                  Padding(padding: EdgeInsets.all(1)),
                                                  Flexible(
                                                    child: RichText(
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 2, // this will show dots(...) after 2 lines
                                                      strutStyle: StrutStyle(fontSize: 11.0),
                                                      text: TextSpan(
                                                          style: TextStyle(fontSize: 11,color: Colors.black),
                                                          text: snapshot.data[index].catName
                                                      ),
                                                    ),
                                                  )
                                                  ,

                                                ],
                                              ),


                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(Icons.pin_drop,size: 11,color: Colors.black,),
                                                  Padding(padding: EdgeInsets.all(1)),
                                                  Flexible(
                                                    child: RichText(
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 2, // this will show dots(...) after 2 lines
                                                      strutStyle: StrutStyle(fontSize: 11.0),
                                                      text: TextSpan(
                                                          style: TextStyle(fontSize: 11,color: Colors.black),
                                                          text: snapshot.data[index].cityName
                                                      ),
                                                    ),
                                                  )
                                                  ,
                                                  

                                                ],
                                              )

                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              });
                        } else {
                          return NoData(message: 'لاتوجد نتائج');
                        }
                      }
                  }
                  return Center(
                    child: SpinKitFadingCircle(color: mainAppColor),
                  );
                })),






      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _navigationProvider = Provider.of<NavigationProvider>(context);
    _authProvider = Provider.of<AuthProvider>(context);

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
      title:Image.asset("assets/images/toplogo.png"),
      actions: <Widget>[
        GestureDetector(
            onTap: () {
              showModalBottomSheet<dynamic>(
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  context: context,
                  builder: (builder) {
                    return Container(
                        width: _width,
                        height: _height * 0.9,
                        child: SearchBottomSheet());
                  });
            },
            child: Image.asset('assets/images/search.png')),


      ],
    );
    _height = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _navigationProvider = Provider.of<NavigationProvider>(context);

    return PageContainer(
      child: Scaffold(
        appBar: appBar,
        drawer: MainDrawer(),
        body: _buildBodyItem(),
      ),
    );
  }
}
