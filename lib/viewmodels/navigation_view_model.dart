import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NavigationViewModel with ChangeNotifier {
  static final _instance = NavigationViewModel._internal();
  NavigationViewModel._internal();
  factory NavigationViewModel(){
    return NavigationViewModel._instance;
  }

  int _currentIndexPage = 2;

  int get currentIndexPage => _currentIndexPage;

  void updateIndex(int index) {
    _currentIndexPage = index;
    notifyListeners();
  }
}