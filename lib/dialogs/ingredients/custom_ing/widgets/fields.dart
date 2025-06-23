import 'package:ai_cook_project/theme.dart';
import 'package:flutter/cupertino.dart';

class IngredientNameField extends StatelessWidget {
  final TextEditingController nameController;
  final String? Function(String?)? validator;

  const IngredientNameField({
    super.key,
    required this.nameController,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.button.withOpacity(0.2)),
      ),
      child: CupertinoTextField(
        controller: nameController,
        placeholder: 'Name',
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        style: const TextStyle(color: AppColors.button, fontSize: 16),
        decoration: null,
        cursorColor: AppColors.mutedGreen,
      ),
    );
  }
}
