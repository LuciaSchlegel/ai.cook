import 'package:ai_cook_project/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';

class AiRecomHeader extends StatelessWidget {
  const AiRecomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: ResponsiveUtils.iconSize(context, ResponsiveIconSize.xl),
          height: ResponsiveUtils.iconSize(context, ResponsiveIconSize.xl),
          decoration: BoxDecoration(
            color: AppColors.mutedGreen,
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
            color:
                AppColors
                    .white, // Changed from mutedGreen to white for visibility
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
              'What would you like to cook today?',
              style: TextStyle(
                fontSize:
                    ResponsiveUtils.fontSize(context, ResponsiveFontSize.xxl) *
                    1.2,
                fontWeight: AppFontWeights.semiBold,
                fontFamily: 'Melodrama',
                color: AppColors.white,
                letterSpacing: 1.8,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
