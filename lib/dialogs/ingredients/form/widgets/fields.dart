import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class QuantityField extends StatelessWidget {
  final TextEditingController controller;

  const QuantityField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return CupertinoTextField.borderless(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          placeholder: 'Quantity',
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
            vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
          ),
          placeholderStyle: TextStyle(
            color: AppColors.button.withValues(alpha: 0.5),
            fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.md),
          ),
          style: TextStyle(
            color: AppColors.button,
            fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.md),
          ),
          cursorColor: AppColors.mutedGreen,
          inputFormatters: [
            // Allow only numbers and a single decimal point
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,}$')),
          ],
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
        return Padding(
          padding: ResponsiveUtils.padding(context, ResponsiveSpacing.sm),
          child: Container(
            padding: ResponsiveUtils.padding(context, ResponsiveSpacing.xxs),
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey6.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.borderRadius(
                  context,
                  ResponsiveBorderRadius.lg,
                ),
              ),
            ),
            child: CupertinoTextField(
              controller: TextEditingController(text: name),
              enabled: false,
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.spacing(
                  context,
                  ResponsiveSpacing.md,
                ),
                vertical: ResponsiveUtils.spacing(
                  context,
                  ResponsiveSpacing.md,
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
            border: Border.all(
              color: AppColors.mutedGreen.withValues(alpha: 0.7),
              width: 0.5,
            ),
          ),
          child: CupertinoTextField.borderless(
            controller: controller,
            placeholder: 'Ingredient Name',
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.spacing(
                context,
                ResponsiveSpacing.sm,
              ),
              vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
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
