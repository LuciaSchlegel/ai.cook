import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';

/// A responsive dialog that safely handles keyboard interactions and device constraints
///
/// Features:
/// - Responsive sizing based on device type
/// - Safe keyboard handling that prevents content overflow
/// - Device-specific padding and styling
/// - Automatic height constraints based on available space
/// - Removes view insets to prevent double keyboard padding
class SafeConstrainedDialog extends StatelessWidget {
  final Widget child;
  final double maxHeightFactor;
  final double minHeight;
  final EdgeInsets? insetPadding;
  final Color? backgroundColor;
  final ShapeBorder? shape;
  final ResponsiveModalConfig? customConfig;

  const SafeConstrainedDialog({
    super.key,
    required this.child,
    this.maxHeightFactor = 0.90,
    this.minHeight = 280,
    this.insetPadding,
    this.backgroundColor,
    this.shape,
    this.customConfig,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        final mq = MediaQuery.of(context);

        // Use responsive padding instead of hardcoded values
        final defaultInsetPadding = ResponsiveUtils.padding(
          context,
          ResponsiveSpacing.md,
        );

        // Calculate safe usable height accounting for keyboard and safe areas
        final usableHeight = _calculateUsableHeight(mq);

        // Use responsive max height factor based on device type
        final responsiveMaxHeightFactor = switch (deviceType) {
          DeviceType.iPhone => maxHeightFactor,
          DeviceType.iPadMini => (maxHeightFactor * 0.95).clamp(0.7, 0.9),
          DeviceType.iPadPro => (maxHeightFactor * 0.9).clamp(0.6, 0.85),
        };

        final maxH = (usableHeight * responsiveMaxHeightFactor).clamp(
          minHeight,
          mq.size.height - mq.padding.vertical,
        );

        return Dialog(
          insetPadding: insetPadding ?? defaultInsetPadding,
          backgroundColor: backgroundColor ?? CupertinoColors.systemBackground,
          shape:
              shape ??
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.borderRadius(
                    context,
                    ResponsiveBorderRadius.md,
                  ),
                ),
              ),
          clipBehavior: Clip.antiAlias,
          child: SafeArea(
            top: true,
            bottom: true,
            // Critical: Remove view insets to prevent double keyboard padding
            child: MediaQuery.removeViewInsets(
              removeBottom: true,
              context: context,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: maxH.toDouble(),
                  maxWidth: ResponsiveUtils.getOptimalContentWidth(context),
                ),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }

  /// Calculate usable height accounting for safe areas and keyboard
  double _calculateUsableHeight(MediaQueryData mediaQuery) {
    return mediaQuery.size.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom -
        mediaQuery.viewInsets.bottom;
  }
}

/// Enhanced version with additional responsive features
class ResponsiveSafeDialog extends StatelessWidget {
  final Widget child;
  final String? title;
  final List<Widget>? actions;
  final ResponsiveModalConfig? customConfig;
  final EdgeInsets? contentPadding;

  const ResponsiveSafeDialog({
    super.key,
    required this.child,
    this.title,
    this.actions,
    this.customConfig,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        final defaultContentPadding = ResponsiveUtils.padding(
          context,
          ResponsiveSpacing.lg,
        );

        return SafeConstrainedDialog(
          customConfig: customConfig,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title section with responsive spacing
              if (title != null) ...[
                Padding(
                  padding: ResponsiveUtils.padding(
                    context,
                    ResponsiveSpacing.lg,
                  ),
                  child: Text(
                    title!,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        ResponsiveFontSize.title,
                      ),
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.label,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Divider(
                  height: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.xs,
                  ),
                  thickness: 0.5,
                ),
              ],

              // Content section
              Flexible(
                child: Padding(
                  padding: contentPadding ?? defaultContentPadding,
                  child: child,
                ),
              ),

              // Actions section with responsive spacing
              if (actions != null && actions!.isNotEmpty) ...[
                Divider(
                  height: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.xs,
                  ),
                  thickness: 0.5,
                ),
                Padding(
                  padding: ResponsiveUtils.padding(
                    context,
                    ResponsiveSpacing.md,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: actions!,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
