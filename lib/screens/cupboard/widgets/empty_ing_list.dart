import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';

class EmptyIngredientListMessage extends StatelessWidget {
  const EmptyIngredientListMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return ResponsiveContainer(
          child: Center(
            child: ResponsiveText(
              'No ingredients match your filters',
              color: AppColors.white,
              fontFamily: 'Melodrama',
              fontWeight: AppFontWeights.medium,
              fontSize:
                  ResponsiveUtils.fontSize(context, ResponsiveFontSize.title) *
                  1.2,
              letterSpacing: 1.8,
              height: 1.5,
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}
