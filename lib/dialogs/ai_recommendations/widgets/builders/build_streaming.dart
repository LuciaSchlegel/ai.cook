import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/cupertino.dart';

/// Clean, minimal Apple-style loading indicator for AI generation
/// Displays a loading state while recommendations are being generated
class BuildStreaming extends StatelessWidget {
  const BuildStreaming({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
        vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.xxl),
      ),
      padding: ResponsiveUtils.padding(context, ResponsiveSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.mutedGreen.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.xl),
        ),
        border: Border.all(
          color: AppColors.mutedGreen.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Cupertino spinner
          CupertinoActivityIndicator(
            radius: 18,
            color: AppColors.mutedGreen,
          ),

          SizedBox(
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.lg),
          ),

          // Simple status text
          Text(
            'Generating recommendations',
            style: TextStyle(
              fontSize: ResponsiveUtils.fontSize(
                context,
                ResponsiveFontSize.lg,
              ),
              fontWeight: AppFontWeights.semiBold,
              fontFamily: 'Inter',
              color: AppColors.mutedGreen,
              letterSpacing: -0.3,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
          ),

          // Subtitle
          Text(
            'This may take a few seconds',
            style: TextStyle(
              fontSize: ResponsiveUtils.fontSize(
                context,
                ResponsiveFontSize.sm,
              ),
              fontWeight: AppFontWeights.medium,
              fontFamily: 'Inter',
              color: AppColors.mutedGreen.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

