import 'package:dalil/models/profs.dart';
import 'package:flutter/material.dart';
import 'package:dalil/models/ad.dart';
import 'package:dalil/models/category.dart';
import 'package:dalil/models/city.dart';
import 'package:dalil/models/country.dart';
import 'package:dalil/models/marka.dart';
import 'package:dalil/models/model.dart';
import 'package:dalil/models/blacklist.dart';
import 'package:dalil/models/user.dart';
import 'package:dalil/networking/api_provider.dart';
import 'package:dalil/providers/auth_provider.dart';
import 'package:dalil/utils/urls.dart';

class HomeProvider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();
  User _currentUser;

  String _currentLang;

  void update(AuthProvider authProvider) {
    _currentUser = authProvider.currentUser;
    _currentLang = authProvider.currentLang;
  }

  String get currentLang => _currentLang;

  bool _enableSearch = false;

  void setEnableSearch(bool enableSearch) {
    _enableSearch = enableSearch;
    notifyListeners();
  }

  bool get enableSearch => _enableSearch;

  List<CategoryModel> _categoryList = List<CategoryModel>();

  List<CategoryModel> get categoryList => _categoryList;

  CategoryModel _lastSelectedCategory;

  void updateChangesOnCategoriesList(int index) {
    if (lastSelectedCategory != null) {
      _lastSelectedCategory.isSelected = false;
    }
    _categoryList[index].isSelected = true;
    _lastSelectedCategory = _categoryList[index];
    notifyListeners();
  }

  void updateSelectedCategory(CategoryModel categoryModel) {
    _lastSelectedCategory.isSelected = false;
    for (int i = 0; i < _categoryList.length; i++) {
      if (categoryModel.catId == _categoryList[i].catId) {
        _lastSelectedCategory = _categoryList[i];
        _lastSelectedCategory.isSelected = true;
      }
      notifyListeners();
    }
  }

  CategoryModel get lastSelectedCategory => _lastSelectedCategory;

  Future<List<CategoryModel>> getCategoryList(
      {CategoryModel categoryModel,@required bool enableSub, String catId}) async {
    var response;
    if (enableSub) {
      response = await _apiProvider.get("https://dalelalmahn.com/request/api_getCat");
    } else {
      response = await _apiProvider.get("https://dalelalmahn.com/request/api_getCat");
    }



    if (response['response'] == '1') {
      Iterable iterable = response['results'];
      _categoryList =
          iterable.map((model) => CategoryModel.fromJson(model)).toList();

      if (!_enableSearch) {

                _categoryList.insert(0, categoryModel);
        _lastSelectedCategory = _categoryList[0];
      }
      else{
        categoryModel.isSelected = false;
          _categoryList.insert(0, categoryModel);
           for (int i = 0; i < _categoryList.length; i++) {
      if (lastSelectedCategory.catId == _categoryList[i].catId) {
        _categoryList[i].isSelected = true;
      }
      }
      }
    }
    return _categoryList;
  }



  Future<List<CategoryModel>> getSubList(
      {@required bool enableSub, String catId}) async {
    var response;
    if (enableSub) {
      response = await _apiProvider.get(Urls.MAIN_CATEGORY_URL +
          "?api_lang=$_currentLang" +
          "&cat_id=$catId");
    } else {
      response = await _apiProvider.get(Urls.MAIN_CATEGORY_URL+
          "?api_lang=$_currentLang");
    }

    List subList = List<CategoryModel>();
    if (response['response'] == '1') {
      Iterable iterable = response['cat'];
      subList = iterable.map((model) => CategoryModel.fromJson(model)).toList();
    }
    return subList;
  }

  Future<List<City>> getCityList(
      {City city,@required bool enableCountry, String countryId}) async {
    var response;
    if (enableCountry) {
      response = await _apiProvider.get("https://dalelalmahn.com/request/api_getCity");
    } else {
      response = await _apiProvider.get("https://dalelalmahn.com/request/api_getCity");
    }

    List cityList = List<City>();
    if (response['response'] == '1') {
      Iterable iterable = response['results'];
      cityList = iterable.map((model) => City.fromJson(model)).toList();
      cityList.insert(0, city);
    }
    return cityList;
  }

  Future<List<Country>> getCountryList() async {
    final response = await _apiProvider
        .get(Urls.GET_COUNTRY_URL + "?api_lang=$_currentLang");
    List<Country> countryList = List<Country>();
    if (response['response'] == '1') {
      Iterable iterable = response['country'];
      countryList = iterable.map((model) => Country.fromJson(model)).toList();
    }
    return countryList;
  }

  Future<List<Marka>> getMarkaList() async {
    final response = await _apiProvider
        .get(Urls.GET_MARKA_URL + "?api_lang=$_currentLang");
    List<Marka> markaList = List<Marka>();
    if (response['response'] == '1') {
      Iterable iterable = response['marka'];
      markaList = iterable.map((model) => Marka.fromJson(model)).toList();
    }
    return markaList;
  }


  Future<List<Model>> getModelList() async {
    final response = await _apiProvider
        .get(Urls.GET_MODEL_URL + "?api_lang=$_currentLang");
    List<Model> modelList = List<Model>();
    if (response['response'] == '1') {
      Iterable iterable = response['model'];
      modelList = iterable.map((model) => Model.fromJson(model)).toList();
    }
    return modelList;
  }

  Future<List<Ad>> getAdsList() async {
    final response = await _apiProvider
        .post(Urls.SEARCH_URL + "?api_lang=$_currentLang", body: {
      "ads_cat":
          _lastSelectedCategory == null ? '0' : _lastSelectedCategory.catId,
      "fav_user_id": _currentUser == null ? '' : _currentUser.userId
    });
    List<Ad> adsList = List<Ad>();
    if (response['response'] == '1') {
      Iterable iterable = response['results'];
      adsList = iterable.map((model) => Ad.fromJson(model)).toList();
    }
    return adsList;
  }

  Future<List<Profs>> getAdsSearchList() async {



    final response = await _apiProvider.get("https://dalelalmahn.com/proffessionals/api_index_search?city_id=${_selectedCity.cityId}&cat_id=$_age");

    List<Profs> adsList = List<Profs>();
    if (response['response'] == '1') {
      Iterable iterable = response['results'];
      adsList = iterable.map((model) => Profs.fromJson(model)).toList();
    }
    return adsList;
  }


  Future<List<Blacklist>> getBlacklist(String tt) async {
    final response = await _apiProvider
        .post(Urls.BLACKLIST_URL , body: {
      "s_value": tt
    });

    List<Blacklist> adsList = List<Blacklist>();
    if (response['response'] == '1') {
      Iterable iterable = response['results'];
      adsList = iterable.map((model) => Blacklist.fromJson(model)).toList();
    }
    return adsList;
  }

  String _searchKey = '';

  void setSearchKey(String searchKey) {
    _searchKey = searchKey;
    notifyListeners();
  }

  String get searchKey => _searchKey;



  String _omarKey = '';

  void setOmarKey(String omarKey) {
    _omarKey = omarKey;
    notifyListeners();
  }

  String get omarKey => _omarKey;


  String _checkedValue = '';

  void setCheckedValue(String checkedValue) {
    _checkedValue = checkedValue;
    notifyListeners();
  }

  String get checkedValue => _checkedValue;



  int _moreId = 0;

  void setMoreId(int moreId) {
    _moreId = moreId;
    notifyListeners();
  }

  int get moreId => _moreId;




  String _moreTitle = '';

  void setMoreTitle(String moreTitle) {
    _moreTitle = moreTitle;
    notifyListeners();
  }

  String get moreTitle => _moreTitle;



  String _moreContent = '';

  void setMoreContent(String moreContent) {
    _moreContent = moreContent;
    notifyListeners();
  }

  String get moreContent => _moreContent;


  String _searchKeyBlacklist = '';

  void setSearchKeyBlacklist(String searchKeyBlacklist) {
    _searchKeyBlacklist = searchKeyBlacklist;
    notifyListeners();
  }

  String get searchKeyBlacklist => _searchKeyBlacklist;


  String _priceFrom = '';

  void setPriceFrom(String priceFrom) {
    _priceFrom = priceFrom;
    notifyListeners();
  }

  String get priceFrom => _priceFrom;

  String _priceTo = '';

  void setPriceTo(String priceTo) {
    _priceTo = priceTo;
    notifyListeners();
  }

  String get priceTo => _priceTo;

  Country _selectedCountry;

  void setSelectedCountry(Country country) {
    _selectedCountry = country;
    notifyListeners();
  }

  Country get selectedCountry => _selectedCountry;


  Marka _selectedMarka;

  void setSelectedMarka(Marka marka) {
    _selectedMarka = marka;
    notifyListeners();
  }

  Marka get selectedMarka => _selectedMarka;


  Model _selectedModel;

  void setSelectedModel(Model model) {
    _selectedModel = model;
    notifyListeners();
  }

  Model get selectedModel => _selectedModel;


  CategoryModel _selectedSub;

  void setSelectedSub(CategoryModel sub) {
    _selectedSub = sub;
    notifyListeners();
  }

  CategoryModel get selectedSub => _selectedSub;


  CategoryModel _selectedCat;

  void setSelectedCat(CategoryModel Cat) {
    _selectedCat = Cat;
    notifyListeners();
  }

  CategoryModel get selectedCat => _selectedCat;



  String _currentAds = '';

  void setCurrentAds(String currentAds) {
    _currentAds = currentAds;
    notifyListeners();
  }

  String get currentAds => _currentAds;


  // current seller
  String _currentSeller = '';
  void setCurrentSeller(String currentSeller) {
    _currentSeller = currentSeller;
    notifyListeners();
  }
  String get currentSeller => _currentSeller;



  // current seller Name
  String _currentSellerName = '';
  void setCurrentSellerName(String currentSellerName) {
    _currentSellerName = currentSellerName;
    notifyListeners();
  }
  String get currentSellerName => _currentSellerName;


  // current seller Phone
  String _currentSellerPhone = '';
  void setCurrentSellerPhone(String currentSellerPhone) {
    _currentSellerPhone = currentSellerPhone;
    notifyListeners();
  }
  String get currentSellerPhone => _currentSellerPhone;

  // current seller Photo
  String _currentSellerPhoto = '';
  void setCurrentSellerPhoto(String currentSellerPhoto) {
    _currentSellerPhoto = currentSellerPhoto;
    notifyListeners();
  }
  String get currentSellerPhoto => _currentSellerPhoto;


  City _selectedCity;

  void setSelectedCity(City city) {
    _selectedCity = city;
    notifyListeners();
  }

  City get selectedCity => _selectedCity;

  String _age = '';

  void setAge(String age) {
    _age = age;
    notifyListeners();
  }

  String get age => _age;

  String _selectedGender = '';

  void setSelectedGender(String gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  String get selectedGender => _selectedGender;





  Future<String> getUnreadMessage() async {
    final response =
    await _apiProvider.get("https://arab-zone.net/api/get_unread_message?user_id=${_currentUser.userId}");
    String messages = '';
    if (response['response'] == '1') {
      messages = response['Number'];
    }
    return messages;
  }

  Future<String> getUnreadNotify() async {
    final response =
    await _apiProvider.get("https://arab-zone.net/api/get_unread_notify?user_id=${_currentUser.userId}");
    String messages = '';
    if (response['response'] == '1') {
      messages = response['Number'];
    }
    return messages;
  }


  Future<String> getOmar() async {
    final response =
    await _apiProvider.get("https://arab-zone.net/api/social");
    String messages = '';
    if (response['response'] == '1') {
      messages = response['setting_omar'];
    }
    return messages;
  }



  Future<String> getMore(int x) async {
    final response =
    await _apiProvider.get("https://dalelalmahn.com/proffessionals/api_moreinfo/$x");
    String messages = '';
    if (response['response'] == '1') {
      messages = response['results']['profsmeta_content'];
    }
    return messages;
  }



}
