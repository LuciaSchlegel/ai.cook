import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';

class LoadingIndicator extends StatelessWidget {
  final Color? color;
  final String? message;

  const LoadingIndicator({super.key, this.color, this.message});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return Center(
          child: ResponsiveContainer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoActivityIndicator(
                  radius: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.md,
                  ),
                  color: color ?? AppColors.mutedGreen,
                ),
                if (message != null) ...[
                  ResponsiveSpacingWidget.vertical(ResponsiveSpacing.md),
                  ResponsiveText(
                    message!,
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.md,
                    ),
                    fontWeight: FontWeight.w500,
                    color: color ?? AppColors.mutedGreen,
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
