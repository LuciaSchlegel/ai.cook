import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/cupertino.dart';

/// Modern Cupertino-style loading indicator
class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
        vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.xxl),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Cupertino-style circular spinner
          CupertinoActivityIndicator(radius: 20, color: AppColors.mutedGreen),

          SizedBox(
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.lg),
          ),

          // Loading text
          Text(
            'Loading recommendations...',
            style: TextStyle(
              fontSize: ResponsiveUtils.fontSize(
                context,
                ResponsiveFontSize.md,
              ),
              fontWeight: AppFontWeights.medium,
              fontFamily: 'Inter',
              color: AppColors.mutedGreen,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
