import 'package:flutter/cupertino.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/theme.dart';

class AIConclusionSection extends StatelessWidget {
  final String conclusion;

  const AIConclusionSection({super.key, required this.conclusion});

  @override
  Widget build(BuildContext context) {
    final displayText =
        conclusion.isNotEmpty
            ? conclusion
            : 'Happy cooking! Let me know if you need any help with these recipes! 👨‍🍳✨';

    return Container(
      margin: EdgeInsets.only(
        bottom: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
      ),
      padding: ResponsiveUtils.padding(context, ResponsiveSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.white, AppColors.orange.withValues(alpha: 0.03)],
        ),
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.orange.withValues(alpha: 0.08),
            blurRadius: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: AppColors.orange.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: ResponsiveUtils.iconSize(context, ResponsiveIconSize.lg),
            height: ResponsiveUtils.iconSize(context, ResponsiveIconSize.lg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.orange, AppColors.lightYellow],
              ),
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.borderRadius(
                  context,
                  ResponsiveBorderRadius.md,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.orange.withValues(alpha: 0.2),
                  blurRadius: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.xs,
                  ),
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              CupertinoIcons.heart_fill,
              size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.md),
              color: AppColors.white,
            ),
          ),
          SizedBox(
            width: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
          ),
          Expanded(
            child: Text(
              displayText,
              style: TextStyle(
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  ResponsiveFontSize.md,
                ),
                fontWeight: AppFontWeights.medium,
                fontFamily: 'Inter',
                color: AppColors.button,
                letterSpacing: 0.2,
                height: 1.4,
              ).copyWith(fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}
