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

// Font weight constants for easy access
class AppFontWeights {
  static const light = FontWeight.w300;
  static const regular = FontWeight.w400;
  static const medium = FontWeight.w500;
  static const semiBold = FontWeight.w600;
  static const bold = FontWeight.w700;
}

// Custom TextStyle factory for Melodrama
class MelodramaTextStyles {
  static const String _fontFamily = 'Melodrama';

  // Light variants
  static TextStyle light({
    double? fontSize,
    Color? color,
    double? height,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
  }) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontWeight: AppFontWeights.light,
      fontSize: fontSize,
      color: color,
      height: height,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
    );
  }

  // Regular variants
  static TextStyle regular({
    double? fontSize,
    Color? color,
    double? height,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
  }) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontWeight: AppFontWeights.regular,
      fontSize: fontSize,
      color: color,
      height: height,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
    );
  }

  // Medium variants
  static TextStyle medium({
    double? fontSize,
    Color? color,
    double? height,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
  }) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontWeight: AppFontWeights.medium,
      fontSize: fontSize,
      color: color,
      height: height,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
    );
  }

  // SemiBold variants
  static TextStyle semiBold({
    double? fontSize,
    Color? color,
    double? height,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
  }) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontWeight: AppFontWeights.semiBold,
      fontSize: fontSize,
      color: color,
      height: height,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
    );
  }

  // Bold variants
  static TextStyle bold({
    double? fontSize,
    Color? color,
    double? height,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
  }) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontWeight: AppFontWeights.bold,
      fontSize: fontSize,
      color: color,
      height: height,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
    );
  }
}

// Updated theme with comprehensive text styles
final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.background,
  fontFamily: 'Melodrama',

  textTheme: TextTheme(
    // Display styles (largest)
    displayLarge: MelodramaTextStyles.bold(
      fontSize: 57,
      color: AppColors.white,
    ),
    displayMedium: MelodramaTextStyles.bold(
      fontSize: 45,
      color: AppColors.white,
    ),
    displaySmall: MelodramaTextStyles.bold(
      fontSize: 36,
      color: AppColors.white,
    ),

    // Headline styles
    headlineLarge: MelodramaTextStyles.semiBold(
      fontSize: 32,
      color: AppColors.white,
    ),
    headlineMedium: MelodramaTextStyles.semiBold(
      fontSize: 28,
      color: AppColors.white,
    ),
    headlineSmall: MelodramaTextStyles.semiBold(
      fontSize: 24,
      color: AppColors.white,
    ),

    // Title styles
    titleLarge: MelodramaTextStyles.medium(
      fontSize: 22,
      color: AppColors.white,
    ),
    titleMedium: MelodramaTextStyles.medium(
      fontSize: 16,
      color: AppColors.white,
    ),
    titleSmall: MelodramaTextStyles.medium(
      fontSize: 14,
      color: AppColors.white,
    ),

    // Body styles
    bodyLarge: MelodramaTextStyles.regular(
      fontSize: 16,
      color: AppColors.white,
    ),
    bodyMedium: MelodramaTextStyles.regular(
      fontSize: 14,
      color: AppColors.white,
    ),
    bodySmall: MelodramaTextStyles.regular(
      fontSize: 12,
      color: AppColors.white,
    ),

    // Label styles
    labelLarge: MelodramaTextStyles.medium(
      fontSize: 14,
      color: AppColors.white,
    ),
    labelMedium: MelodramaTextStyles.medium(
      fontSize: 12,
      color: AppColors.white,
    ),
    labelSmall: MelodramaTextStyles.medium(
      fontSize: 11,
      color: AppColors.white,
    ),
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
      textStyle: MelodramaTextStyles.medium(fontSize: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  ),

  textSelectionTheme: TextSelectionThemeData(
    cursorColor: AppColors.orange,
    selectionColor: AppColors.orange,
    selectionHandleColor: AppColors.orange,
  ),
);
