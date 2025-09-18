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
    return color.withValues(alpha: opacity);
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

// Centralized font family management
class AppFontFamilies {
  static const compagnon = 'Compagnon';
  static const melodrama = 'Melodrama';
  static const inter = 'Inter'; // System font fallback

  // Primary font for UI elements (readable, professional)
  static const primary = compagnon;

  // Secondary font for headers and emphasis (decorative)
  static const secondary = melodrama;

  // Tertiary font for forms and technical content (clean, minimal)
  static const tertiary = inter;
}

// Simplified TextStyle factory - let Flutter handle font weights automatically
class AppTextStyles {
  // === COMPAGNON STYLES (Primary - UI Elements) ===
  static TextStyle compagnon({
    FontWeight? fontWeight,
    double? fontSize,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
  }) => TextStyle(
    fontFamily: AppFontFamilies.compagnon,
    fontWeight: fontWeight ?? AppFontWeights.regular,
    fontSize: fontSize,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
    decoration: decoration,
    decorationColor: decorationColor,
    decorationStyle: decorationStyle,
    decorationThickness: decorationThickness,
  );

  // === MELODRAMA STYLES (Secondary - Headers & Emphasis) ===
  static TextStyle melodrama({
    FontWeight? fontWeight,
    double? fontSize,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
  }) => TextStyle(
    fontFamily: AppFontFamilies.melodrama,
    fontWeight: fontWeight ?? AppFontWeights.regular,
    fontSize: fontSize,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
    decoration: decoration,
    decorationColor: decorationColor,
    decorationStyle: decorationStyle,
    decorationThickness: decorationThickness,
  );

  // === INTER STYLES (Tertiary - Forms & Technical) ===
  static TextStyle inter({
    FontWeight? fontWeight,
    double? fontSize,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
  }) => TextStyle(
    fontFamily: AppFontFamilies.inter,
    fontWeight: fontWeight ?? AppFontWeights.regular,
    fontSize: fontSize,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
    decoration: decoration,
    decorationColor: decorationColor,
    decorationStyle: decorationStyle,
    decorationThickness: decorationThickness,
  );
}

// Legacy support - keeping CompagnonTextStyles for backward compatibility
class CompagnonTextStyles {
  static const String _fontFamily = AppFontFamilies.compagnon;

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
  fontFamily: AppFontFamilies.primary,

  textTheme: TextTheme(
    // Display styles (largest) - Use Melodrama for impact
    displayLarge: AppTextStyles.melodrama(
      fontWeight: AppFontWeights.bold,
      fontSize: 57,
      color: AppColors.white,
    ),
    displayMedium: AppTextStyles.melodrama(
      fontWeight: AppFontWeights.bold,
      fontSize: 45,
      color: AppColors.white,
    ),
    displaySmall: AppTextStyles.melodrama(
      fontWeight: AppFontWeights.bold,
      fontSize: 36,
      color: AppColors.white,
    ),

    // Headline styles - Use Melodrama for headers
    headlineLarge: AppTextStyles.melodrama(
      fontWeight: AppFontWeights.semiBold,
      fontSize: 32,
      color: AppColors.white,
    ),
    headlineMedium: AppTextStyles.melodrama(
      fontWeight: AppFontWeights.semiBold,
      fontSize: 28,
      color: AppColors.white,
    ),
    headlineSmall: AppTextStyles.melodrama(
      fontWeight: AppFontWeights.semiBold,
      fontSize: 24,
      color: AppColors.white,
    ),

    // Title styles - Use Compagnon for readability
    titleLarge: AppTextStyles.compagnon(
      fontWeight: AppFontWeights.medium,
      fontSize: 22,
      color: AppColors.white,
    ),
    titleMedium: AppTextStyles.compagnon(
      fontWeight: AppFontWeights.medium,
      fontSize: 16,
      color: AppColors.white,
    ),
    titleSmall: AppTextStyles.compagnon(
      fontWeight: AppFontWeights.medium,
      fontSize: 14,
      color: AppColors.white,
    ),

    // Body styles - Use Compagnon for body text
    bodyLarge: AppTextStyles.compagnon(fontSize: 16, color: AppColors.white),
    bodyMedium: AppTextStyles.compagnon(fontSize: 14, color: AppColors.white),
    bodySmall: AppTextStyles.compagnon(fontSize: 12, color: AppColors.white),

    // Label styles - Use Inter for forms/technical
    labelLarge: AppTextStyles.inter(
      fontWeight: AppFontWeights.medium,
      fontSize: 14,
      color: AppColors.white,
    ),
    labelMedium: AppTextStyles.inter(
      fontWeight: AppFontWeights.medium,
      fontSize: 12,
      color: AppColors.white,
    ),
    labelSmall: AppTextStyles.inter(
      fontWeight: AppFontWeights.medium,
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
      textStyle: AppTextStyles.compagnon(
        fontWeight: AppFontWeights.medium,
        fontSize: 16,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  ),

  textSelectionTheme: TextSelectionThemeData(
    cursorColor: AppColors.orange,
    selectionColor: AppColors.orange,
    selectionHandleColor: AppColors.orange,
  ),
);
