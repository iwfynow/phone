import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/themes/themes.dart';

class SettingViewModel extends ChangeNotifier with AppTheme{
  static final _instance = SettingViewModel._internal();
  SettingViewModel._internal();
  factory SettingViewModel(){
    return _instance;
  }

  SharedPreferences? prefs;
  final List<ThemeMode> _themeModeList = [ThemeMode.system, ThemeMode.light, ThemeMode.dark];
  int _themeIndex = 0;
  ThemeMode get currentThemeMode => _themeModeList[_themeIndex];
  String language = "";
  static const List<Locale> localeList = [Locale('ru'), Locale('en')];
  Locale currentLocal = localeList[0];

  int get themeIndex => _themeIndex;
  set themeIndex(int value){
    _themeIndex = value;
    prefs!.setInt('ThemeMode', value);
    notifyListeners();
  }

  Future<void> initSetting() async {
  try {
    prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs!.getBool('isFirstLaunch') ?? true;
    if (isFirstLaunch) {
      await prefs!.setBool('isFirstLaunch', false);
      await prefs!.setInt('ThemeMode', 0);
      await prefs!.setString('language', 'ru');
      log("First Setting Installed");
    } else {
      loadSetting();
      log("Settings already initialized");
    }
  } catch (e) {
    log("Error initializing SharedPreferences: $e");
  }
  }

  void changeLanguage(String local) async {
    if(local == 'ru'){
      language = local;
      currentLocal = localeList[0];
      await prefs!.setString('language', local);
    } else{
      language = local;
      currentLocal = localeList[1];
      await prefs!.setString('language', local);
    }
    notifyListeners();
  }

  Future<void> loadSetting() async {
    _themeIndex = prefs!.getInt('ThemeMode') ?? 0;
    language = prefs!.getString('language') ?? 'ru';
    if(language == 'ru'){
      currentLocal = localeList[0];
    } else{
      currentLocal = localeList[1];
    }
    notifyListeners();
  }

}