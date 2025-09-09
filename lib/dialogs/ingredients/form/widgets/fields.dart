import 'package:ai_cook_project/dialogs/ai_recommendations/constants/dialog_constants.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:flutter/cupertino.dart';

class QuantityField extends StatelessWidget {
  final TextEditingController controller;

  const QuantityField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      keyboardType: TextInputType.number,
      placeholder: 'Quantity',
      padding: const EdgeInsets.symmetric(
        horizontal: DialogConstants.spacingSM,
        vertical: DialogConstants.spacingSM,
      ),
      placeholderStyle: TextStyle(
        color: AppColors.button.withOpacity(0.5),
        fontSize: DialogConstants.fontSizeMD,
      ),
      style: const TextStyle(
        color: AppColors.button,
        fontSize: DialogConstants.fontSizeMD,
      ),
      decoration: null,
      cursorColor: AppColors.mutedGreen,
    );
  }
}

class IngredientNameField extends StatelessWidget {
  final String name;

  const IngredientNameField({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(DialogConstants.radiusSM),
        border: Border.all(color: AppColors.button.withOpacity(0.12), width: 1),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: DialogConstants.spacingSM,
        vertical: DialogConstants.spacingSM,
      ),
      child: Text(
        name,
        style: TextStyle(
          color: AppColors.button,
          fontSize: DialogConstants.fontSizeMD,
        ),
      ),
    );
  }
}

class ControlledIngNameField extends StatelessWidget {
  final TextEditingController controller;

  const ControlledIngNameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(DialogConstants.radiusMD),
        border: Border.all(color: AppColors.button.withOpacity(0.3)),
      ),
      child: CupertinoTextField(
        controller: controller,
        placeholder: 'Ingredient Name',
        padding: const EdgeInsets.symmetric(
          horizontal: DialogConstants.spacingSM,
          vertical: DialogConstants.spacingSM,
        ),
        placeholderStyle: TextStyle(
          color: AppColors.button.withOpacity(0.5),
          fontSize: DialogConstants.fontSizeMD,
        ),
        style: const TextStyle(
          color: AppColors.button,
          fontSize: DialogConstants.fontSizeMD,
        ),
        decoration: null,
        cursorColor: AppColors.mutedGreen,
      ),
    );
  }
}
