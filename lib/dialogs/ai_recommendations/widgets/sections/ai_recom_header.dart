import 'package:ai_cook_project/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';

class AiRecomHeader extends StatelessWidget {
  const AiRecomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Container(
        //   width: ResponsiveUtils.iconSize(context, ResponsiveIconSize.xl),
        //   height: ResponsiveUtils.iconSize(context, ResponsiveIconSize.xl),
        //   decoration: BoxDecoration(
        //     color: AppColors.mutedGreen,
        //     borderRadius: BorderRadius.circular(
        //       ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.md),
        //     ),
        //     boxShadow: [
        //       BoxShadow(
        //         color: AppColors.mutedGreen.withValues(alpha: 0.15),
        //         blurRadius: ResponsiveUtils.spacing(
        //           context,
        //           ResponsiveSpacing.sm,
        //         ),
        //         offset: const Offset(0, 4),
        //       ),
        //     ],
        //   ),
        //   child: Icon(
        //     CupertinoIcons.sparkles,
        //     size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.md),
        //     color:
        //         AppColors
        //             .white, // Changed from mutedGreen to white for visibility
        //   ),
        // ),
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
              style: AppTextStyles.casta(
                fontSize:
                    ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.title,
                    ) *
                    1.4,
                fontWeight: AppFontWeights.bold,
                color: AppColors.white,
                letterSpacing: 0.8,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
