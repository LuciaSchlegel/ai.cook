import 'package:ai_cook_project/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';

class AiRecomHeader extends StatelessWidget {
  const AiRecomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          height: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          decoration: BoxDecoration(color: AppColors.mutedGreen).copyWith(
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.md),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.mutedGreen.withValues(alpha: 0.15),
                blurRadius: ResponsiveUtils.spacing(
                  context,
                  ResponsiveSpacing.sm,
                ),
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            CupertinoIcons.sparkles,
            size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.md),
            color: AppColors.mutedGreen,
          ),
        ),
        SizedBox(width: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm)),
        Expanded(
          child: ShaderMask(
            shaderCallback:
                (bounds) => LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.button,
                    AppColors.mutedGreen,
                    AppColors.button,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ).createShader(bounds),
            child: Text(
              'AI Recipe Recommendations',
              style: TextStyle(
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  ResponsiveFontSize.md,
                ),
                fontWeight: FontWeight.w700,
                color: AppColors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
