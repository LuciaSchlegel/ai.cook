import 'package:ai_cook_project/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';

class AIGreetingSection extends StatelessWidget {
  final String greeting;

  const AIGreetingSection({super.key, required this.greeting});

  @override
  Widget build(BuildContext context) {
    if (greeting.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(
        bottom: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
      ),
      padding: ResponsiveUtils.padding(context, ResponsiveSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.white,
            AppColors.mutedGreen.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.mutedGreen.withValues(alpha: 0.08),
            blurRadius: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: AppColors.mutedGreen.withValues(alpha: 0.12),
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
              color: AppColors.mutedGreen,
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.borderRadius(
                  context,
                  ResponsiveBorderRadius.md,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.mutedGreen.withValues(alpha: 0.2),
                  blurRadius: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.xs,
                  ),
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              CupertinoIcons.person_fill,
              size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.md),
              color: AppColors.white,
            ),
          ),
          SizedBox(
            width: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
          ),
          Expanded(
            child: Text(
              greeting,
              style: TextStyle(
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  ResponsiveFontSize.md,
                ),
                fontFamily: 'Inter',
                fontWeight: AppFontWeights.medium,
                color: AppColors.button,
                letterSpacing: 0.2,
                height: 1.4,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
