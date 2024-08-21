import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors
        .grey[900]!, 
    selectedItemColor: Colors.white, 
    unselectedItemColor: Colors.grey, 
  ),

  cardTheme: CardTheme(
    color: Colors.grey[900]!,
  ),

  colorScheme: ColorScheme.dark(
    background: Colors.black,
    primary: Colors.grey[900]!,
    secondary: Colors.grey[800]!,
    onPrimary: Colors.white, 
    onSecondary: Colors.grey, 
  ),
  
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      color: Colors.white,
    ),
  ),
);
