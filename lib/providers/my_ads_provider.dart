import 'package:dalil/models/profs.dart';
import 'package:dalil/models/request.dart';
import 'package:flutter/material.dart';
import 'package:dalil/models/ad.dart';
import 'package:dalil/models/user.dart';
import 'package:dalil/networking/api_provider.dart';
import 'package:dalil/providers/auth_provider.dart';
import 'package:dalil/utils/urls.dart';

  class MyAdsProvider extends ChangeNotifier {
    ApiProvider _apiProvider = ApiProvider();
  User _currentUser;
  String _currentLang;

  void update(AuthProvider authProvider) {
    _currentUser = authProvider.currentUser;
    _currentLang =  authProvider.currentLang;
  }
     Future<List<Request>> getMyAdsList() async {

    final response = await _apiProvider.get("https://dalelalmahn.com/request/api_index");
    List<Request> adsList = List<Request>();
    if (response['response'] == '1') {
      Iterable iterable = response['results'];
      adsList = iterable.map((model) => Request.fromJson(model)).toList();
    }

    return adsList;
  }

    Future<List<Profs>> getMyAdsList1() async {

      final response = await _apiProvider.get("https://dalelalmahn.com/proffessionals/api_index");
      List<Profs> adsList = List<Profs>();
      if (response['response'] == '1') {
        Iterable iterable = response['results'];
        adsList = iterable.map((model) => Profs.fromJson(model)).toList();
      }

      return adsList;
    }


    Future<List<Profs>> getAdsFeatured() async {

      final response = await _apiProvider.get("https://dalelalmahn.com/proffessionals/api_featured");
      List<Profs> adsList = List<Profs>();
      if (response['response'] == '1') {
        Iterable iterable = response['results'];
        adsList = iterable.map((model) => Profs.fromJson(model)).toList();
      }

      return adsList;
    }


  }