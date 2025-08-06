import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/widgets/selectors/dropdown_selector.dart';
import 'package:flutter/cupertino.dart';

class FormOptions extends StatelessWidget {
  final TextEditingController maxTimeController;
  final TextEditingController preferencesController;
  final String selectedDifficulty;
  final Function(String) onDifficultyChanged;

  const FormOptions({
    super.key,
    required this.maxTimeController,
    required this.preferencesController,
    required this.selectedDifficulty,
    required this.onDifficultyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Max Cooking Time
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Max Cooking Time (minutes)',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.button.withOpacity(0.9),
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.button.withOpacity(0.2)),
                ),
                child: CupertinoTextField(
                  controller: maxTimeController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  placeholder: 'e.g. 30',
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  placeholderStyle: TextStyle(
                    color: AppColors.button.withOpacity(0.5),
                    fontSize: 16,
                  ),
                  style: const TextStyle(color: AppColors.button, fontSize: 16),
                  decoration: null,
                  cursorColor: AppColors.mutedGreen,
                  onSubmitted: (_) {
                    // Move focus to preferences field when user presses next
                    FocusScope.of(context).nextFocus();
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),

        // Difficulty Selector
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Preferred Difficulty',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.button.withOpacity(0.9),
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 48,
                child: DropdownSelector(
                  value: selectedDifficulty,
                  items: ['Easy', 'Medium', 'Hard'],
                  onChanged: (newValue) {
                    if (newValue != null) {
                      onDifficultyChanged(newValue);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
