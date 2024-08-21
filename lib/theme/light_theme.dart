import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,

  
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor:
        Colors.white, 
    selectedItemColor: Colors.black, 
    unselectedItemColor: Colors.grey, 
  ),

  
  cardTheme: CardTheme(
    color: Colors.white, 
  ),
  colorScheme: ColorScheme.light(
    background: Colors.white,
    primary: Colors.white,
    secondary: Colors.black,
    onPrimary: Colors.white, 
    onSecondary: Colors.grey, 
  ),

  textTheme: TextTheme(
    bodyLarge: TextStyle(
      color: Colors.black,
    ),
  ),
);
