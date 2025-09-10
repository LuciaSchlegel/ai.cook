import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:flutter/cupertino.dart';

class QuantityField extends StatelessWidget {
  final TextEditingController controller;

  const QuantityField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return CupertinoTextField(
          controller: controller,
          keyboardType: TextInputType.number,
          placeholder: 'Quantity',
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          ),
          placeholderStyle: TextStyle(
            color: AppColors.button.withValues(alpha: 0.5),
            fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.md),
          ),
          style: TextStyle(
            color: AppColors.button,
            fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.md),
          ),
          decoration: null,
          cursorColor: AppColors.mutedGreen,
        );
      },
    );
  }
}

class IngredientNameField extends StatelessWidget {
  final String name;

  const IngredientNameField({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return ResponsiveContainer(
          padding: ResponsiveSpacing.sm,
          child: CupertinoTextField(
            controller: TextEditingController(text: name),
            enabled: false,
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.spacing(
                context,
                ResponsiveSpacing.md,
              ),
              vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
            ),
            style: TextStyle(
              color: AppColors.button,
              fontSize: ResponsiveUtils.fontSize(
                context,
                ResponsiveFontSize.md,
              ),
            ),
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey6.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.borderRadius(
                  context,
                  ResponsiveBorderRadius.lg,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ControlledIngNameField extends StatelessWidget {
  final TextEditingController controller;

  const ControlledIngNameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return Container(
          decoration: BoxDecoration(
            color: CupertinoColors.white,
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.md),
            ),
            border: Border.all(color: AppColors.button.withValues(alpha: 0.3)),
          ),
          child: CupertinoTextField(
            controller: controller,
            placeholder: 'Ingredient Name',
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.spacing(
                context,
                ResponsiveSpacing.sm,
              ),
              vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            ),
            placeholderStyle: TextStyle(
              color: AppColors.button.withValues(alpha: 0.5),
              fontSize: ResponsiveUtils.fontSize(
                context,
                ResponsiveFontSize.md,
              ),
            ),
            style: TextStyle(
              color: AppColors.button,
              fontSize: ResponsiveUtils.fontSize(
                context,
                ResponsiveFontSize.md,
              ),
            ),
            decoration: null,
            cursorColor: AppColors.mutedGreen,
          ),
        );
      },
    );
  }
}
