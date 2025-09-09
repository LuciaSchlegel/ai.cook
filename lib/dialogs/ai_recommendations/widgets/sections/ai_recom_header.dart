import 'package:ai_cook_project/dialogs/ai_recommendations/constants/dialog_constants.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AiRecomHeader extends StatelessWidget {
  const AiRecomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: DialogConstants.iconContainerDecoration(
            AppColors.mutedGreen,
          ).copyWith(
            borderRadius: BorderRadius.circular(DialogConstants.radiusMD),
            boxShadow: DialogConstants.lightShadow,
          ),
          child: Icon(
            CupertinoIcons.sparkles,
            size: 24,
            color: AppColors.mutedGreen,
          ),
        ),
        const SizedBox(width: DialogConstants.spacingSM),
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
            child: const Text(
              'AI Recipe Recommendations',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
