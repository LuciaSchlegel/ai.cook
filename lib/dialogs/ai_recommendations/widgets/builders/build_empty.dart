import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/cupertino.dart';

class BuildEmpty extends StatelessWidget {
  const BuildEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.mutedGreen.withValues(alpha: 0.05),
            blurRadius: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: AppColors.mutedGreen.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Subtle gradient background
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.borderRadius(
                  context,
                  ResponsiveBorderRadius.lg,
                ),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.lightYellow.withValues(alpha: 0.02),
                  AppColors.mutedGreen.withValues(alpha: 0.02),
                ],
              ),
            ),
          ),
          // Main content with flexible layout
          Padding(
            padding: ResponsiveUtils.padding(context, ResponsiveSpacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon with background
                Container(
                  width:
                      ResponsiveUtils.iconSize(
                        context,
                        ResponsiveIconSize.xxl,
                      ) +
                      ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
                  height:
                      ResponsiveUtils.iconSize(
                        context,
                        ResponsiveIconSize.xxl,
                      ) +
                      ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.mutedGreen.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    CupertinoIcons.sparkles,
                    size: ResponsiveUtils.iconSize(
                      context,
                      ResponsiveIconSize.xl,
                    ),
                    color: AppColors.mutedGreen,
                  ),
                ),
                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.md,
                  ),
                ),
                // Title
                Text(
                  'AI Chef Ready',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.xxl,
                    ),
                    fontWeight: AppFontWeights.semiBold,
                    fontFamily: 'Compagnon',
                    color: AppColors.button,
                    letterSpacing: 0.3,
                    height: 1.4,
                  ),
                ),
                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.xs,
                  ),
                ),
                // Subtitle with flexible text
                Flexible(
                  child: Text(
                    'Set your preferences above and tap the button below to get personalized recipe recommendations',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        ResponsiveFontSize.md,
                      ),
                      color: AppColors.button.withValues(alpha: 0.7),
                      height: 1.4,
                      fontWeight: AppFontWeights.regular,
                      fontFamily: 'Inter',
                      letterSpacing: 0.2,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
