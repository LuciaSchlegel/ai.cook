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
      padding: ResponsiveUtils.padding(context, ResponsiveSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.button.withValues(alpha: 0.04),
            blurRadius: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppColors.button.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width:
                ResponsiveUtils.iconSize(context, ResponsiveIconSize.xxl) +
                ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
            height:
                ResponsiveUtils.iconSize(context, ResponsiveIconSize.xxl) +
                ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.button.withValues(alpha: 0.06),
              shape: BoxShape.circle,
            ),
            child: Icon(
              CupertinoIcons.sparkles,
              size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.xl),
              color: AppColors.button.withValues(alpha: 0.35),
            ),
          ),
          SizedBox(
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
          ),
          Text(
            'No Perfect Matches Yet',
            style: AppTextStyles.casta(
              fontSize: ResponsiveUtils.fontSize(
                context,
                ResponsiveFontSize.title,
              ),
              fontWeight: AppFontWeights.semiBold,
              color: AppColors.button,
              letterSpacing: 0.4,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          ),
          Text(
            "We couldn't find recipes matching your preferences.",
            style: AppTextStyles.inter(
              fontSize: ResponsiveUtils.fontSize(
                context,
                ResponsiveFontSize.sm,
              ),
              fontWeight: AppFontWeights.regular,
              color: AppColors.button.withValues(alpha: 0.5),
              letterSpacing: 0.2,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
          ),
          Container(
            padding: ResponsiveUtils.padding(context, ResponsiveSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.lightYellow.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.borderRadius(
                  context,
                  ResponsiveBorderRadius.md,
                ),
              ),
              border: Border.all(
                color: AppColors.orange.withValues(alpha: 0.15),
                width: 1,
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
                      color: AppColors.orange,
                    ),
                    SizedBox(
                      width: ResponsiveUtils.spacing(
                        context,
                        ResponsiveSpacing.xs,
                      ),
                    ),
                    Text(
                      'Try this:',
                      style: AppTextStyles.inter(
                        fontSize: ResponsiveUtils.fontSize(
                          context,
                          ResponsiveFontSize.sm,
                        ),
                        fontWeight: AppFontWeights.semiBold,
                        color: AppColors.button.withValues(alpha: 0.7),
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
                _buildSuggestion(context, 'Add more items to your pantry'),
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
                color: AppColors.button.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(
            width: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
          ),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.inter(
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  ResponsiveFontSize.sm,
                ),
                fontWeight: AppFontWeights.regular,
                color: AppColors.button.withValues(alpha: 0.6),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
