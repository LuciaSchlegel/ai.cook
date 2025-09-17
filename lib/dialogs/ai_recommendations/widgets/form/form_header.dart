import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/cupertino.dart';

class FormHeader extends StatelessWidget {
  const FormHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: ResponsiveUtils.iconSize(context, ResponsiveIconSize.lg),
          height: ResponsiveUtils.iconSize(context, ResponsiveIconSize.lg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.mutedGreen, AppColors.lightYellow],
            ),
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.md),
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
            CupertinoIcons.slider_horizontal_3,
            size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.md),
            color: AppColors.white,
          ),
        ),
        SizedBox(width: ResponsiveUtils.spacing(context, ResponsiveSpacing.md)),
        Expanded(
          child: Text(
            'Customize Your Preferences',
            style: TextStyle(
              fontSize: ResponsiveUtils.fontSize(
                context,
                ResponsiveFontSize.lg,
              ),
              fontWeight: AppFontWeights.semiBold,
              fontFamily: 'Inter',
              color: AppColors.button,
              letterSpacing: 0.2,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
