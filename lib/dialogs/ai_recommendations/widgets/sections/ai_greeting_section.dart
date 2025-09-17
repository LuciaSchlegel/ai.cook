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
      padding: ResponsiveUtils.padding(context, ResponsiveSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.white, AppColors.orange.withValues(alpha: 0.02)],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            decoration: BoxDecoration(color: AppColors.mutedGreen),
            child: Icon(
              CupertinoIcons.person_fill,
              size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.md),
              color: AppColors.mutedGreen,
            ),
          ),
          SizedBox(
            width: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          ),
          Expanded(
            child: Text(
              greeting,
              style: TextStyle(
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  ResponsiveFontSize.md,
                ),
                fontWeight: FontWeight.w500,
                color: AppColors.mutedGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
