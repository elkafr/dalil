import 'package:flutter/material.dart';
import 'package:dalil/networking/api_provider.dart';
import 'package:dalil/providers/auth_provider.dart';
import 'package:dalil/utils/urls.dart';



class AboutAppProvider extends ChangeNotifier{
   ApiProvider _apiProvider = ApiProvider();
 String _currentLang;


  void update(AuthProvider authProvider) {
 
    _currentLang = authProvider.currentLang;
  }
  Future<String> getAboutApp() async {
    final response =
        await _apiProvider.get("https://dalelalmahn.com/request/api_about");
    String aboutApp = '';
    if (response['response'] == '1') {
      aboutApp = response['content'];
    }
    return aboutApp;
  }
}