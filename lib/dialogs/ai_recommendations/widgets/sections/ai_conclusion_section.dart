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
              CupertinoIcons.heart_fill,
              size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.md),
              color: AppColors.mutedGreen,
            ),
          ),
          SizedBox(
            width: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          ),
          Expanded(
            child: Text(
              displayText,
              style: TextStyle(
                fontStyle: FontStyle.italic,
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
