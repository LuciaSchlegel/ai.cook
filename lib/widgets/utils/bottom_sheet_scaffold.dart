import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';

/// Enhanced bottom sheet scaffold with responsive design and proper keyboard handling
///
/// Features:
/// - Device-specific sizing using ResponsiveUtils
/// - Proper keyboard behavior across all device types
/// - Consistent with app's responsive design system
/// - Optimized snap points and sizing for each device type
Future<T?> showDraggableModalBottomSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext, ScrollController) builder,
  bool isDismissible = true,
  bool enableDrag = true,
  double? minChildSize,
  double? initialChildSize,
  double? maxChildSize,
  List<double>? snapSizes,
  ResponsiveModalConfig? customConfig,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    builder: (ctx) {
      final mq = MediaQuery.of(ctx);
      final deviceType = ResponsiveUtils.getDeviceType(ctx);

      // Use custom config or get device-appropriate config
      final modalConfig = customConfig ?? ResponsiveUtils.getModalConfig(ctx);

      // Apply custom overrides if provided, otherwise use responsive defaults
      final responsiveMinSize = minChildSize ?? modalConfig.minSize;
      final responsiveInitialSize = initialChildSize ?? modalConfig.initialSize;
      final responsiveMaxSize = maxChildSize ?? modalConfig.maxSize;
      final responsiveSnapSizes = snapSizes ?? modalConfig.snapSizes;

      return AnimatedPadding(
        // Enhanced keyboard handling with smooth animation
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutCubic,
        padding: EdgeInsets.only(
          bottom: _getKeyboardPadding(ctx, mq, deviceType),
        ),
        child: DraggableScrollableSheet(
          expand: false,
          minChildSize: responsiveMinSize,
          initialChildSize: responsiveInitialSize,
          maxChildSize: responsiveMaxSize,
          snap: true,
          snapSizes: responsiveSnapSizes,
          builder: (context, scrollController) {
            return ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(
                  ResponsiveUtils.borderRadius(ctx, ResponsiveBorderRadius.xl),
                ),
              ),
              child: Material(
                color: CupertinoColors.systemBackground,
                child: builder(ctx, scrollController),
              ),
            );
          },
        ),
      );
    },
  );
}

/// Convenience method that uses ResponsiveModalBottomSheet for consistency
/// This provides the same API but leverages the app's responsive system
Future<T?> showResponsiveBottomSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext, ScrollController) builder,
  bool isDismissible = true,
  bool enableDrag = true,
  ResponsiveModalConfig? customConfig,
}) {
  return ResponsiveModalBottomSheet.show<T>(
    context: context,
    builder: builder,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    customConfig: customConfig,
  );
}

/// Calculate appropriate keyboard padding based on device type and keyboard state
double _getKeyboardPadding(
  BuildContext context,
  MediaQueryData mediaQuery,
  DeviceType deviceType,
) {
  final keyboardHeight = mediaQuery.viewInsets.bottom;
  final baseSpacing = switch (deviceType) {
    DeviceType.iPhone => ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
    DeviceType.iPadMini => ResponsiveUtils.spacing(
      context,
      ResponsiveSpacing.sm,
    ),
    DeviceType.iPadPro => ResponsiveUtils.spacing(
      context,
      ResponsiveSpacing.md,
    ),
  };

  // Add extra padding when keyboard is visible for better UX
  final keyboardPadding = keyboardHeight > 0 ? baseSpacing * 1.5 : baseSpacing;

  return keyboardHeight + keyboardPadding;
}
