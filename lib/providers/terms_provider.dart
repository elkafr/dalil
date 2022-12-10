import 'package:flutter/material.dart';
import 'package:dalil/networking/api_provider.dart';
import 'package:dalil/utils/urls.dart';

import 'auth_provider.dart';

class TermsProvider extends ChangeNotifier{
   ApiProvider _apiProvider = ApiProvider();
    
 String _currentLang;


  void update(AuthProvider authProvider) {
 
    _currentLang = authProvider.currentLang;
  }
  Future<String> getTerms() async {
    final response =
        await _apiProvider.get("https://dalelalmahn.com/request/api_terms");
    String terms = '';
    if (response['response'] == '1') {
      terms = response['content'];
    }
    return terms;
  }


   Future<String> getTerms1() async {
     final response =
     await _apiProvider.get("https://dalelalmahn.com/request/api_how");
     String terms = '';
     if (response['response'] == '1') {
       terms = response['content'];
     }
     return terms;
   }

   Future<String> getTerms2() async {
     final response =
     await _apiProvider.get("https://dalelalmahn.com/request/api_why");
     String terms = '';
     if (response['response'] == '1') {
       terms = response['content'];
     }
     return terms;
   }

   Future<String> getTerms3() async {
     final response =
     await _apiProvider.get("https://dalelalmahn.com/request/api_privacy");
     String terms = '';
     if (response['response'] == '1') {
       terms = response['content'];
     }
     return terms;
   }




   Future<String> getFace() async {
     final response =
     await _apiProvider.get(Urls.Social +"?api_lang=$_currentLang");
     String terms = '';
     if (response['response'] == '1') {
       terms = response['setting_face'];
     }
     return terms;
   }

   Future<String> getTwitt() async {
     final response =
     await _apiProvider.get(Urls.Social +"?api_lang=$_currentLang");
     String terms = '';
     if (response['response'] == '1') {
       terms = response['setting_twitt'];
     }
     return terms;
   }

   Future<String> getSnap() async {
     final response =
     await _apiProvider.get(Urls.Social +"?api_lang=$_currentLang");
     String terms = '';
     if (response['response'] == '1') {
       terms = response['setting_snap'];
     }
     return terms;
   }


   Future<String> getLinkid() async {
     final response =
     await _apiProvider.get(Urls.Social +"?api_lang=$_currentLang");
     String terms = '';
     if (response['response'] == '1') {
       terms = response['setting_linkid'];
     }
     return terms;
   }

   Future<String> getInst() async {
     final response =
     await _apiProvider.get(Urls.Social +"?api_lang=$_currentLang");
     String terms = '';
     if (response['response'] == '1') {
       terms = response['setting_inst'];
     }
     return terms;
   }


   Future<String> getAppstore() async {
     final response =
     await _apiProvider.get(Urls.Social +"?api_lang=$_currentLang");
     String terms = '';
     if (response['response'] == '1') {
       terms = response['setting_appstore'];
     }
     return terms;
   }



   Future<String> getGoogleplay() async {
     final response =
     await _apiProvider.get(Urls.Social +"?api_lang=$_currentLang");
     String terms = '';
     if (response['response'] == '1') {
       terms = response['setting_googleplay'];
     }
     return terms;
   }



}

