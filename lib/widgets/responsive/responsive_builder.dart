import 'package:flutter/material.dart';
import '../../utils/responsive_utils.dart';

/// A builder widget that provides responsive breakpoints for building
/// different layouts based on device type
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceType deviceType) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveUtils.getDeviceType(context);
    return builder(context, deviceType);
  }
}

/// A widget that shows different content based on device type
class ResponsiveWidget extends StatelessWidget {
  final Widget iPhone;
  final Widget? iPadMini;
  final Widget? iPadPro;

  const ResponsiveWidget({
    super.key,
    required this.iPhone,
    this.iPadMini,
    this.iPadPro,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveUtils.getDeviceType(context);

    return switch (deviceType) {
      DeviceType.iPhone => iPhone,
      DeviceType.iPadMini => iPadMini ?? iPhone,
      DeviceType.iPadPro => iPadPro ?? iPadMini ?? iPhone,
    };
  }
}

/// A responsive container that adapts its sizing and padding based on device type
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final ResponsiveSpacing padding;
  final ResponsiveBorderRadius? borderRadius;
  final Color? backgroundColor;
  final bool constrainWidth;
  final double? maxWidth;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding = ResponsiveSpacing.md,
    this.borderRadius,
    this.backgroundColor,
    this.constrainWidth = false,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final containerPadding = ResponsiveUtils.padding(context, padding);
    final radius =
        borderRadius != null
            ? ResponsiveUtils.borderRadius(context, borderRadius!)
            : null;

    Widget container = Container(
      padding: containerPadding,
      decoration:
          backgroundColor != null || radius != null
              ? BoxDecoration(
                color: backgroundColor,
                borderRadius:
                    radius != null ? BorderRadius.circular(radius) : null,
              )
              : null,
      child: child,
    );

    if (constrainWidth) {
      final optimalWidth =
          maxWidth ?? ResponsiveUtils.getOptimalContentWidth(context);
      container = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: optimalWidth),
        child: container,
      );
    }

    return container;
  }
}

/// A responsive text widget that adapts font size based on device type
class ResponsiveText extends StatelessWidget {
  final String text;
  final ResponsiveFontSize fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final String? fontFamily;
  final double? letterSpacing;
  final double? height;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final TextDecorationStyle? decorationStyle;
  final double? decorationThickness;

  const ResponsiveText(
    this.text, {
    super.key,
    this.fontSize = ResponsiveFontSize.md,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontFamily,
    this.letterSpacing,
    this.height,
    this.decoration,
    this.decorationColor,
    this.decorationStyle,
    this.decorationThickness,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontSize: ResponsiveUtils.fontSize(context, fontSize),
        fontWeight: fontWeight,
        color: color,
        fontFamily: fontFamily,
        letterSpacing: letterSpacing,
        height: height,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        decorationThickness: decorationThickness,
      ),
    );
  }
}

/// A responsive icon widget that adapts size based on device type
class ResponsiveIcon extends StatelessWidget {
  final IconData icon;
  final ResponsiveIconSize size;
  final Color? color;

  const ResponsiveIcon(
    this.icon, {
    super.key,
    this.size = ResponsiveIconSize.md,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: ResponsiveUtils.iconSize(context, size),
      color: color,
    );
  }
}

/// A responsive grid view that adapts column count based on device type
class ResponsiveGridView extends StatelessWidget {
  final List<Widget> children;
  final double? childAspectRatio;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const ResponsiveGridView({
    super.key,
    required this.children,
    this.childAspectRatio,
    this.mainAxisSpacing = 8.0,
    this.crossAxisSpacing = 8.0,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    final columns = ResponsiveUtils.getGridColumns(context);
    final aspectRatio =
        childAspectRatio ?? ResponsiveUtils.getCardAspectRatio(context);

    return GridView.count(
      crossAxisCount: columns,
      childAspectRatio: aspectRatio,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      children: children,
    );
  }
}

/// A responsive modal bottom sheet that adapts sizing based on device type
class ResponsiveModalBottomSheet extends StatelessWidget {
  final Widget Function(BuildContext context, ScrollController scrollController)
  builder;
  final bool isDismissible;
  final bool enableDrag;
  final ResponsiveModalConfig? customConfig;

  const ResponsiveModalBottomSheet({
    super.key,
    required this.builder,
    this.isDismissible = true,
    this.enableDrag = true,
    this.customConfig,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget Function(BuildContext, ScrollController) builder,
    bool isDismissible = true,
    bool enableDrag = true,
    ResponsiveModalConfig? customConfig,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      builder:
          (ctx) => ResponsiveModalBottomSheet(
            builder: builder,
            isDismissible: isDismissible,
            enableDrag: enableDrag,
            customConfig: customConfig,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = customConfig ?? ResponsiveUtils.getModalConfig(context);

    return DraggableScrollableSheet(
      initialChildSize: config.initialSize,
      minChildSize: config.minSize,
      maxChildSize: config.maxSize,
      snap: true,
      snapSizes: config.snapSizes,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: builder(context, scrollController),
        );
      },
    );
  }
}

/// A responsive spacing widget that provides consistent spacing
class ResponsiveSpacingWidget extends StatelessWidget {
  final ResponsiveSpacing size;
  final bool isVertical;

  const ResponsiveSpacingWidget(this.size, {super.key, this.isVertical = true});

  /// Creates vertical spacing
  const ResponsiveSpacingWidget.vertical(this.size, {super.key})
    : isVertical = true;

  /// Creates horizontal spacing
  const ResponsiveSpacingWidget.horizontal(this.size, {super.key})
    : isVertical = false;

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveUtils.spacing(context, size);

    if (isVertical) {
      return SizedBox(height: spacing);
    } else {
      return SizedBox(width: spacing);
    }
  }
}
