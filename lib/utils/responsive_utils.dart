import 'package:flutter/material.dart';

/// Comprehensive responsive utility class optimized for iPhone and iPad
///
/// This system provides consistent responsive behavior across the app
/// with device-specific optimizations for iOS devices.
class ResponsiveUtils {
  ResponsiveUtils._();

  // ==================== DEVICE DETECTION ====================

  /// iPhone breakpoint (up to iPhone 14 Pro Max width: 430pt)
  static const double iPhoneMaxWidth = 440.0;

  /// iPad Mini breakpoint (768pt width in portrait)
  static const double iPadMiniWidth = 744.0;

  /// iPad Pro breakpoint (1024pt width in portrait)
  static const double iPadProWidth = 1032.0;

  // ==================== DEVICE TYPE DETECTION ====================

  /// Determines if the current device is an iPhone based on screen width
  static bool isIPhone(BuildContext context) {
    return MediaQuery.of(context).size.width <= iPhoneMaxWidth;
  }

  /// Determines if the current device is an iPad Mini based on screen width
  static bool isIPadMini(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > iPhoneMaxWidth && width <= iPadMiniWidth;
  }

  /// Determines if the current device is an iPad Pro based on screen width
  static bool isIPadPro(BuildContext context) {
    return MediaQuery.of(context).size.width > iPadMiniWidth;
  }

  /// Determines if the current device is any iPad
  static bool isIPad(BuildContext context) {
    return MediaQuery.of(context).size.width > iPhoneMaxWidth;
  }

  /// Gets the device type as an enum for easier switching
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width <= iPhoneMaxWidth) {
      return DeviceType.iPhone;
    } else if (width <= iPadMiniWidth) {
      return DeviceType.iPadMini;
    } else {
      return DeviceType.iPadPro;
    }
  }

  // ==================== SPACING SYSTEM ====================

  /// Base spacing constants
  static const double _spacingXXS = 4.0;
  static const double _spacingXS = 8.0;
  static const double _spacingSM = 12.0;
  static const double _spacingMD = 16.0;
  static const double _spacingLG = 24.0;
  static const double _spacingXL = 32.0;
  static const double _spacingXXL = 48.0;

  /// Responsive spacing that adapts to device type
  static double spacing(BuildContext context, ResponsiveSpacing size) {
    final deviceType = getDeviceType(context);
    final baseSpacing = _getBaseSpacing(size);

    return switch (deviceType) {
      DeviceType.iPhone => baseSpacing * 0.85, // Slightly smaller for iPhone
      DeviceType.iPadMini => baseSpacing, // Base spacing for iPad Mini
      DeviceType.iPadPro => baseSpacing * 1.25, // Larger for iPad Pro
    };
  }

  static double _getBaseSpacing(ResponsiveSpacing size) {
    return switch (size) {
      ResponsiveSpacing.xxs => _spacingXXS,
      ResponsiveSpacing.xs => _spacingXS,
      ResponsiveSpacing.sm => _spacingSM,
      ResponsiveSpacing.md => _spacingMD,
      ResponsiveSpacing.lg => _spacingLG,
      ResponsiveSpacing.xl => _spacingXL,
      ResponsiveSpacing.xxl => _spacingXXL,
    };
  }

  // ==================== PADDING SYSTEM ====================

  /// Responsive padding that adapts to screen size and safe areas
  static EdgeInsets padding(
    BuildContext context,
    ResponsiveSpacing size, {
    bool includeSafeArea = false,
  }) {
    final baseSpacing = spacing(context, size);
    final deviceType = getDeviceType(context);

    EdgeInsets basePadding = EdgeInsets.all(baseSpacing);

    // Adjust padding based on device type
    basePadding = switch (deviceType) {
      DeviceType.iPhone => basePadding,
      DeviceType.iPadMini => EdgeInsets.all(baseSpacing * 1.1),
      DeviceType.iPadPro => EdgeInsets.all(baseSpacing * 1.2),
    };

    if (includeSafeArea) {
      final mediaQuery = MediaQuery.of(context);
      final safePadding = EdgeInsets.only(
        top: mediaQuery.padding.top,
        bottom: mediaQuery.padding.bottom,
      );
      return EdgeInsets.only(
        left: basePadding.left + safePadding.left,
        top: basePadding.top + safePadding.top,
        right: basePadding.right + safePadding.right,
        bottom: basePadding.bottom + safePadding.bottom,
      );
    }

    return basePadding;
  }

  /// Responsive horizontal padding
  static EdgeInsets horizontalPadding(
    BuildContext context,
    ResponsiveSpacing size,
  ) {
    final baseSpacing = spacing(context, size);
    return EdgeInsets.symmetric(horizontal: baseSpacing);
  }

  /// Responsive vertical padding
  static EdgeInsets verticalPadding(
    BuildContext context,
    ResponsiveSpacing size,
  ) {
    final baseSpacing = spacing(context, size);
    return EdgeInsets.symmetric(vertical: baseSpacing);
  }

  // ==================== FONT SIZE SYSTEM ====================

  /// Base font sizes
  static const double _fontXS = 12.0;
  static const double _fontSM = 14.0;
  static const double _fontMD = 16.0;
  static const double _fontLG = 18.0;
  static const double _fontXL = 20.0;
  static const double _fontXXL = 24.0;
  static const double _fontTitle = 28.0;
  static const double _fontTitle2 = 42.0;
  static const double _fontDisplay = 34.0;
  static const double _fontDisplay2 = 85.0;

  /// Responsive font size that adapts to device type
  static double fontSize(BuildContext context, ResponsiveFontSize size) {
    final deviceType = getDeviceType(context);
    final baseFontSize = _getBaseFontSize(size);

    return switch (deviceType) {
      DeviceType.iPhone => baseFontSize, // Base size for iPhone
      DeviceType.iPadMini =>
        baseFontSize * 1.1, // Slightly larger for iPad Mini
      DeviceType.iPadPro => baseFontSize * 1.2, // Larger for iPad Pro
    };
  }

  static double _getBaseFontSize(ResponsiveFontSize size) {
    return switch (size) {
      ResponsiveFontSize.xs => _fontXS,
      ResponsiveFontSize.sm => _fontSM,
      ResponsiveFontSize.md => _fontMD,
      ResponsiveFontSize.lg => _fontLG,
      ResponsiveFontSize.xl => _fontXL,
      ResponsiveFontSize.xxl => _fontXXL,
      ResponsiveFontSize.title => _fontTitle,
      ResponsiveFontSize.title2 => _fontTitle2,
      ResponsiveFontSize.display => _fontDisplay,
      ResponsiveFontSize.display2 => _fontDisplay2,
    };
  }

  // ==================== ICON SIZE SYSTEM ====================

  /// Base icon sizes
  static const double _iconXS = 16.0;
  static const double _iconSM = 20.0;
  static const double _iconMD = 24.0;
  static const double _iconLG = 28.0;
  static const double _iconXL = 32.0;
  static const double _iconXXL = 40.0;

  /// Responsive icon size
  static double iconSize(BuildContext context, ResponsiveIconSize size) {
    final deviceType = getDeviceType(context);
    final baseIconSize = _getBaseIconSize(size);

    return switch (deviceType) {
      DeviceType.iPhone => baseIconSize, // Base size for iPhone
      DeviceType.iPadMini =>
        baseIconSize * 1.1, // Slightly larger for iPad Mini
      DeviceType.iPadPro => baseIconSize * 1.25, // Larger for iPad Pro
    };
  }

  static double _getBaseIconSize(ResponsiveIconSize size) {
    return switch (size) {
      ResponsiveIconSize.xs => _iconXS,
      ResponsiveIconSize.sm => _iconSM,
      ResponsiveIconSize.md => _iconMD,
      ResponsiveIconSize.lg => _iconLG,
      ResponsiveIconSize.xl => _iconXL,
      ResponsiveIconSize.xxl => _iconXXL,
    };
  }

  // ==================== BORDER RADIUS SYSTEM ====================

  /// Base border radius values
  static const double _radiusXS = 6.0;
  static const double _radiusSM = 8.0;
  static const double _radiusMD = 12.0;
  static const double _radiusLG = 16.0;
  static const double _radiusXL = 20.0;
  static const double _radiusXXL = 24.0;
  static const double _radiusXXXL = 28.0; // 2xl
  /// Responsive border radius
  static double borderRadius(
    BuildContext context,
    ResponsiveBorderRadius size,
  ) {
    final deviceType = getDeviceType(context);
    final baseBorderRadius = _getBaseBorderRadius(size);

    return switch (deviceType) {
      DeviceType.iPhone => baseBorderRadius, // Base size for iPhone
      DeviceType.iPadMini => baseBorderRadius, // Same for iPad Mini
      DeviceType.iPadPro =>
        baseBorderRadius * 1.1, // Slightly larger for iPad Pro
    };
  }

  static double _getBaseBorderRadius(ResponsiveBorderRadius size) {
    return switch (size) {
      ResponsiveBorderRadius.xs => _radiusXS,
      ResponsiveBorderRadius.sm => _radiusSM,
      ResponsiveBorderRadius.md => _radiusMD,
      ResponsiveBorderRadius.lg => _radiusLG,
      ResponsiveBorderRadius.xl => _radiusXL,
      ResponsiveBorderRadius.xxl => _radiusXXL,
      ResponsiveBorderRadius.xxxl => _radiusXXXL,
    };
  }

  // ==================== MODAL & DIALOG SIZING ====================

  /// Responsive modal/dialog sizing optimized for iOS devices
  static ResponsiveModalConfig getModalConfig(BuildContext context) {
    final deviceType = getDeviceType(context);

    return switch (deviceType) {
      DeviceType.iPhone => const ResponsiveModalConfig(
        initialSize: 0.85,
        minSize: 0.6,
        maxSize: 0.95,
        snapSizes: [0.6, 0.85, 0.95],
      ),
      DeviceType.iPadMini => const ResponsiveModalConfig(
        initialSize: 0.75,
        minSize: 0.5,
        maxSize: 0.9,
        snapSizes: [0.5, 0.75, 0.9],
      ),
      DeviceType.iPadPro => const ResponsiveModalConfig(
        initialSize: 0.7,
        minSize: 0.45,
        maxSize: 0.85,
        snapSizes: [0.45, 0.7, 0.85],
      ),
    };
  }

  // ==================== LAYOUT HELPERS ====================

  /// Get optimal content width for readability
  static double getOptimalContentWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final deviceType = getDeviceType(context);

    return switch (deviceType) {
      DeviceType.iPhone => screenWidth * 0.9, // Use most of the width
      DeviceType.iPadMini => screenWidth * 0.8, // Leave more margin
      DeviceType.iPadPro => (screenWidth * 0.7).clamp(
        0,
        700,
      ), // Max width for readability
    };
  }

  /// Get number of columns for grid layouts
  static int getGridColumns(BuildContext context) {
    final deviceType = getDeviceType(context);

    return switch (deviceType) {
      DeviceType.iPhone => 2, // 2 columns on iPhone
      DeviceType.iPadMini => 3, // 3 columns on iPad Mini
      DeviceType.iPadPro => 4, // 4 columns on iPad Pro
    };
  }

  /// Get aspect ratio for cards/tiles
  static double getCardAspectRatio(BuildContext context) {
    final deviceType = getDeviceType(context);

    return switch (deviceType) {
      DeviceType.iPhone => 0.8, // Taller cards on iPhone
      DeviceType.iPadMini => 0.9, // Square-ish on iPad Mini
      DeviceType.iPadPro => 1.0, // Square on iPad Pro
    };
  }

  // ==================== SAFE AREA HELPERS ====================

  /// Get bottom safe area with additional padding for scrollable content
  static double getScrollBottomPadding(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomSafeArea = mediaQuery.padding.bottom;
    final additionalPadding = spacing(context, ResponsiveSpacing.lg);

    return bottomSafeArea + additionalPadding;
  }

  /// Get top safe area with additional padding for dialog content
  static double getDialogTopPadding(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topSafeArea = mediaQuery.padding.top;
    final additionalPadding = spacing(context, ResponsiveSpacing.md);

    return topSafeArea + additionalPadding;
  }
}

// ==================== ENUMS ====================

enum DeviceType { iPhone, iPadMini, iPadPro }

enum ResponsiveSpacing { xxs, xs, sm, md, lg, xl, xxl }

enum ResponsiveFontSize {
  xs,
  sm,
  md,
  lg,
  xl,
  xxl,
  title,
  title2,
  display,
  display2,
}

enum ResponsiveIconSize { xs, sm, md, lg, xl, xxl }

enum ResponsiveBorderRadius { xs, sm, md, lg, xl, xxl, xxxl } // 2xl

// ==================== DATA CLASSES ====================

class ResponsiveModalConfig {
  final double initialSize;
  final double minSize;
  final double maxSize;
  final List<double> snapSizes;

  const ResponsiveModalConfig({
    required this.initialSize,
    required this.minSize,
    required this.maxSize,
    required this.snapSizes,
  });
}
