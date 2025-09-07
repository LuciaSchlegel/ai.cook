import 'package:ai_cook_project/theme.dart';
import 'package:flutter/cupertino.dart';

class FormComments extends StatelessWidget {
  final TextEditingController preferencesController;

  const FormComments({super.key, required this.preferencesController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.button.withValues(alpha: 0.2)),
      ),
      child: CupertinoTextField(
        controller: preferencesController,
        placeholder: 'e.g. I prefer spicy food, vegetarian dishes...',
        maxLines: 3,
        textInputAction: TextInputAction.done,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        placeholderStyle: TextStyle(
          color: AppColors.button.withValues(alpha: 0.5),
          fontSize: 16,
        ),
        style: const TextStyle(color: AppColors.button, fontSize: 16),
        decoration: null,
        cursorColor: AppColors.mutedGreen,
        onSubmitted: (_) {
          // Dismiss keyboard when user presses done
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
}
