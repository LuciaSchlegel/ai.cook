import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:flutter/cupertino.dart';

class RecipeTitle extends StatelessWidget {
  final String name;

  const RecipeTitle({required this.name, super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final text = name;
            final words = text.split(' ');

            String line1 = '';
            String line2 = '';

            if (words.length == 1) {
              line1 = text;
            } else {
              int splitIndex = (words.length / 2).ceil();
              line1 = words.take(splitIndex).join(' ');
              line2 = words.skip(splitIndex).join(' ');
            }

            // Responsive width calculation
            final availableWidth = switch (deviceType) {
              DeviceType.iPhone => constraints.maxWidth * 0.95,
              DeviceType.iPadMini => constraints.maxWidth * 0.92,
              DeviceType.iPadPro => constraints.maxWidth * 0.90,
            };

            final textStyle = _calculateResponsiveTextStyle(
              context,
              words,
              deviceType,
            );

            return Padding(
              padding: ResponsiveUtils.horizontalPadding(
                context,
                ResponsiveSpacing.sm,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: availableWidth,
                    child: Text(
                      line1,
                      style: textStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (line2.isNotEmpty) ...[
                    ResponsiveSpacingWidget.vertical(ResponsiveSpacing.xxs),
                    SizedBox(
                      width: availableWidth,
                      child: Text(
                        line2,
                        style: textStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Calculate responsive text style based on device type and content
  TextStyle _calculateResponsiveTextStyle(
    BuildContext context,
    List<String> words,
    DeviceType deviceType,
  ) {
    const int longWordThreshold = 12;
    const double scaleFactor = 0.9;

    // Get base font size from responsive system
    final baseFontSize = switch (deviceType) {
      DeviceType.iPhone =>
        ResponsiveUtils.fontSize(context, ResponsiveFontSize.xxl) * 1.6,
      DeviceType.iPadMini =>
        ResponsiveUtils.fontSize(context, ResponsiveFontSize.display) * 1.6,
      DeviceType.iPadPro =>
        ResponsiveUtils.fontSize(context, ResponsiveFontSize.display) * 1.8,
    };

    // Apply scaling for long words
    bool hasLongWord = words.any((word) => word.length > longWordThreshold);
    final finalFontSize =
        hasLongWord ? baseFontSize * scaleFactor : baseFontSize;

    // Responsive letter spacing
    final letterSpacing = switch (deviceType) {
      DeviceType.iPhone => 1.2,
      DeviceType.iPadMini => 1.4,
      DeviceType.iPadPro => 1.8,
    };

    return AppTextStyles.casta(
      fontSize: finalFontSize,
      height: 1.1,
      letterSpacing: letterSpacing,
      fontWeight: AppFontWeights.bold,
      color: AppColors.button,
    );
  }
}
