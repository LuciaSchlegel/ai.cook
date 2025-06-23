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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      placeholderStyle: TextStyle(
        color: AppColors.button.withOpacity(0.5),
        fontSize: 16,
      ),
      style: const TextStyle(color: AppColors.button, fontSize: 16),
      decoration: null,
      cursorColor: AppColors.mutedGreen,
      onTap: () {
        if (controller.text == '0') controller.clear();
      },
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
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.mutedGreen.withOpacity(0.6),
          width: 2,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(name, style: TextStyle(color: AppColors.button)),
    );
  }
}
