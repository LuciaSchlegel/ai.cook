import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/cupertino.dart';

class BuildNoResults extends StatelessWidget {
  const BuildNoResults({super.key});

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
            color: AppColors.mutedGreen.withValues(alpha: 0.06),
            blurRadius: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: AppColors.mutedGreen.withValues(alpha: 0.15),
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
                  AppColors.mutedGreen.withValues(alpha: 0.03),
                  AppColors.lightYellow.withValues(alpha: 0.02),
                ],
              ),
            ),
          ),
          // Main content
          Padding(
            padding: ResponsiveUtils.padding(context, ResponsiveSpacing.lg),
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
                    color: AppColors.mutedGreen.withValues(alpha: 0.1),
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
                // Friendly title
                Text(
                  'No Perfect Matches Yet',
                  style: AppTextStyles.casta(
                    fontSize:
                        ResponsiveUtils.fontSize(
                          context,
                          ResponsiveFontSize.title,
                        ) *
                        1.1,
                    fontWeight: AppFontWeights.semiBold,
                    color: AppColors.button,
                    letterSpacing: 0.6,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.md,
                  ),
                ),
                // Friendly message
                Text(
                  "We couldn't find recipes that match all your preferences right now.",
                  style: TextStyle(
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.md,
                    ),
                    color: AppColors.button.withValues(alpha: 0.75),
                    height: 1.5,
                    fontWeight: AppFontWeights.medium,
                    fontFamily: 'Inter',
                    letterSpacing: 0.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.md,
                  ),
                ),
                // Helpful suggestions
                Container(
                  padding: ResponsiveUtils.padding(
                    context,
                    ResponsiveSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightYellow.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.borderRadius(
                        context,
                        ResponsiveBorderRadius.md,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.lightbulb,
                            size: ResponsiveUtils.iconSize(
                              context,
                              ResponsiveIconSize.sm,
                            ),
                            color: AppColors.button.withValues(alpha: 0.7),
                          ),
                          SizedBox(
                            width: ResponsiveUtils.spacing(
                              context,
                              ResponsiveSpacing.xs,
                            ),
                          ),
                          Text(
                            'Try this:',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.fontSize(
                                context,
                                ResponsiveFontSize.sm,
                              ),
                              fontWeight: AppFontWeights.semiBold,
                              fontFamily: 'Inter',
                              color: AppColors.button.withValues(alpha: 0.8),
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: ResponsiveUtils.spacing(
                          context,
                          ResponsiveSpacing.sm,
                        ),
                      ),
                      _buildSuggestion(context, 'Relax time or difficulty constraints'),
                      _buildSuggestion(context, 'Try different cuisine tags'),
                      _buildSuggestion(context, 'Browse all available recipes'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestion(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs) * 0.5,
            ),
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.button.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(width: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  ResponsiveFontSize.sm,
                ),
                fontFamily: 'Inter',
                color: AppColors.button.withValues(alpha: 0.7),
                height: 1.4,
                letterSpacing: 0.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
