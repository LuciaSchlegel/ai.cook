import 'package:ai_cook_project/theme.dart';
import 'package:flutter/material.dart';

/// Design system constants for AI Recommendations Dialog
class DialogConstants {
  DialogConstants._();

  // Spacing Constants
  static const double spacingXXS = 8.0;
  static const double spacingXS = 12.0;
  static const double spacingSM = 16.0;
  static const double spacingMD = 24.0;
  static const double spacingLG = 32.0;
  static const double spacingXL = 40.0;

  // Font Size Constants
  static const double fontSizeXS = 12.0;
  static const double fontSizeSM = 14.0;
  static const double fontSizeMD = 16.0;
  static const double fontSizeLG = 18.0;
  static const double fontSizeXL = 20.0;
  static const double fontSizeXXL = 22.0;
  static const double fontSizeTitle = 30.0;

  // Icon Size Constants
  static const double iconSizeXXS = 10.0;
  static const double iconSizeXS = 14.0;
  static const double iconSizeSM = 16.0;
  static const double iconSizeMD = 18.0;
  static const double iconSizeLG = 24.0;
  static const double iconSizeXL = 26.0;
  static const double iconSizeXXL = 40.0;

  // Border Radius Constants
  static const double radiusXXS = 6.0;
  static const double radiusSM = 12.0;
  static const double radiusMD = 16.0;
  static const double radiusLG = 20.0;
  static const double radiusXL = 24.0;
  static const double radiusXXL = 28.0;

  // Alpha Values for Consistency
  static const double alphaLight = 0.05;
  static const double alphaMedium = 0.1;
  static const double alphaStrong = 0.2;

  // Shadow Configurations
  static List<BoxShadow> get lightShadow => [
    BoxShadow(
      color: AppColors.mutedGreen.withValues(alpha: 0.06),
      blurRadius: 12,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get mediumShadow => [
    BoxShadow(
      color: AppColors.mutedGreen.withValues(alpha: 0.08),
      blurRadius: 16,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get strongShadow => [
    BoxShadow(
      color: AppColors.mutedGreen.withValues(alpha: 0.12),
      blurRadius: 24,
      offset: const Offset(0, 6),
      spreadRadius: 0,
    ),
  ];

  // Main Dialog Shadow
  static List<BoxShadow> get dialogShadow => [
    BoxShadow(
      color: AppColors.mutedGreen.withValues(alpha: 0.08),
      blurRadius: 32,
      offset: const Offset(0, -8),
    ),
    BoxShadow(
      color: AppColors.mutedGreen.withValues(alpha: 0.04),
      blurRadius: 16,
      offset: const Offset(0, -4),
      spreadRadius: 2,
    ),
  ];

  // Section Decorations
  static BoxDecoration get sectionDecoration => BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(radiusLG),
    boxShadow: lightShadow,
    border: Border.all(
      color: AppColors.mutedGreen.withValues(alpha: alphaMedium),
      width: 1,
    ),
  );

  // Gradient Configurations (Simplified)
  static LinearGradient get primaryGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.mutedGreen.withValues(alpha: alphaLight),
      AppColors.lightYellow.withValues(alpha: alphaLight),
    ],
  );

  static LinearGradient get accentGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.lightYellow.withValues(alpha: alphaLight),
      AppColors.mutedGreen.withValues(alpha: alphaLight),
    ],
  );

  // Icon Container Decoration
  static BoxDecoration iconContainerDecoration(Color baseColor) =>
      BoxDecoration(
        gradient: LinearGradient(
          colors: [
            baseColor.withValues(alpha: alphaStrong),
            AppColors.lightYellow.withValues(alpha: alphaMedium),
          ],
        ),
        borderRadius: BorderRadius.circular(radiusMD),
      );

  // Text Styles
  static TextStyle get sectionTitleStyle => TextStyle(
    fontSize: DialogConstants.fontSizeLG,
    fontWeight: FontWeight.w700,
    color: AppColors.button,
    letterSpacing: 0.3,
  );

  static TextStyle get bodyTextStyle => TextStyle(
    fontSize: DialogConstants.fontSizeMD,
    height: 1.5,
    color: AppColors.button.withValues(alpha: 0.85),
    fontWeight: FontWeight.w400,
  );

  static TextStyle get captionTextStyle => TextStyle(
    fontSize: DialogConstants.fontSizeSM,
    height: 1.4,
    color: AppColors.button.withValues(alpha: 0.7),
  );

  // Recipe Card Colors
  static const Color readyCardBorder = Colors.green;
  static const Color almostReadyCardBorder = Colors.orange;
  static const Color missingCardBorder = Colors.red;

  // Responsive Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;

  // Adaptive Spacing
  static double adaptiveSpacing(BuildContext context, double baseSpacing) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < mobileBreakpoint) {
      return baseSpacing * 0.8;
    } else if (screenWidth < tabletBreakpoint) {
      return baseSpacing;
    } else {
      return baseSpacing * 1.2;
    }
  }

  // Adaptive Padding
  static EdgeInsets adaptivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < mobileBreakpoint) {
      return const EdgeInsets.all(spacingSM);
    } else if (screenWidth < tabletBreakpoint) {
      return const EdgeInsets.all(spacingMD);
    } else {
      return const EdgeInsets.all(spacingLG);
    }
  }

  // Safe Area Aware Bottom Padding for Scrollable Content
  static double safeScrollBottomPadding(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomSafeArea = mediaQuery.padding.bottom;
    final baseSpacing = adaptiveSpacing(context, spacingMD);

    // Ensure minimum spacing even on devices without bottom safe area
    return bottomSafeArea > 0
        ? bottomSafeArea + baseSpacing
        : baseSpacing * 1.5; // Extra space for devices without home indicator
  }

  // Top safe area for dialog content (close button area)
  static double dialogTopSafeArea(BuildContext context) {
    // Ensure enough space so content doesn't get cut off at the top
    final baseSpacing = adaptiveSpacing(context, spacingXL);
    final extraPadding = adaptiveSpacing(context, spacingMD);
    return baseSpacing + extraPadding; // More generous top spacing
  }
}
