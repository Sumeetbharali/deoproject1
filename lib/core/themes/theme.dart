import 'package:classwix_orbit/core/constants/colors.dart';
import 'package:flutter/material.dart';

ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.white,
 
  ),
  inputDecorationTheme: const InputDecorationTheme(
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey), 
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
          color: Color.fromARGB(255, 65, 105, 225),
          width: 2), 
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red), 
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide:
          BorderSide(color: Colors.red, width: 2), 
    ),
    hintStyle: TextStyle(color: Colors.grey), 
    labelStyle: TextStyle(color: Colors.blueAccent), 
  ),

  
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Color.fromARGB(255, 77, 107, 199), // Cursor color
    selectionColor:  Color.fromARGB(149, 117, 142, 218), // Background of selected text
    selectionHandleColor: Color.fromARGB(255, 0, 0, 139), // Handles used to adjust selection
  ),
);
