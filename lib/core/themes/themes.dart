import 'package:flutter/material.dart';

mixin AppTheme {
    ThemeData lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0XFFF9F8FE),
      foregroundColor: Colors.black
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 0,
      backgroundColor: Color(0xFFEDEDF7),
      selectedIconTheme: IconThemeData(
        color: Colors.black
      ),
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.normal
      ),
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey
    ),
    tabBarTheme: const TabBarTheme(
          labelColor: Colors.black,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelColor: Colors.black,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: Colors.black, width: 2),
      ),
    ),
    searchBarTheme: const SearchBarThemeData(
      backgroundColor: WidgetStatePropertyAll(Color(0xFFEDEDF7)),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF505B93),
      foregroundColor: Colors.white
    ),
    expansionTileTheme: const ExpansionTileThemeData(
      backgroundColor: Color(0xFFEDEDF7),
      collapsedBackgroundColor: Color(0xFFF9F8FE),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30))
      )
    ),
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFFF9F8FE),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 17, color: Colors.black),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
    ),
  );



  ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blueGrey,
    scaffoldBackgroundColor: Colors.black,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 17, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
    ),
  );
}