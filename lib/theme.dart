import 'package:flutter/material.dart';

class AppColors {
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const background = Color(0xFF284139);
  static const orange = Color(0xFFBB6830);
  static const button = Color(0xFF111A19);
  static const mutedGreen = Color(0xFF809076);
  static const lightYellow = Color(0xFFF8D794);
  static const gradientOrange = LinearGradient(
    colors: [Color(0xFFBB6830), Color(0xFFF8D794)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }
}

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.background,
  fontFamily: 'SFProDisplay', // Ej. 'SFProDisplay'

  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.white,
    ),
    bodyMedium: TextStyle(fontSize: 16, color: AppColors.white),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.red, width: 2),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.orange,
      foregroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  ),

  textSelectionTheme: TextSelectionThemeData(
    cursorColor: AppColors.orange,
    selectionColor: AppColors.orange,
    selectionHandleColor: AppColors.orange,
  ),
);
