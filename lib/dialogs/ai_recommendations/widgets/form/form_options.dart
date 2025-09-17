import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
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
                'Max Cooking Time',
                style: TextStyle(
                  fontSize: ResponsiveUtils.fontSize(
                    context,
                    ResponsiveFontSize.sm,
                  ),
                  fontWeight: AppFontWeights.semiBold,
                  fontFamily: 'Inter',
                  color: AppColors.button.withValues(alpha: 0.9),
                  letterSpacing: 0.2,
                  height: 1.4,
                ),
              ),
              SizedBox(
                height: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
              ),
              Container(
                height:
                    ResponsiveUtils.spacing(context, ResponsiveSpacing.xl) +
                    ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(
                    ResponsiveUtils.borderRadius(
                      context,
                      ResponsiveBorderRadius.md,
                    ),
                  ),
                  border: Border.all(
                    color: AppColors.button.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.button.withValues(alpha: 0.03),
                      blurRadius: ResponsiveUtils.spacing(
                        context,
                        ResponsiveSpacing.xs,
                      ),
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: CupertinoTextField(
                  controller: maxTimeController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  placeholder: 'e.g. 30min',
                  padding: ResponsiveUtils.padding(
                    context,
                    ResponsiveSpacing.sm,
                  ),
                  placeholderStyle: TextStyle(
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.md,
                    ),
                    fontWeight: AppFontWeights.regular,
                    fontFamily: 'Inter',
                    color: AppColors.button.withValues(alpha: 0.5),
                  ),
                  style: TextStyle(
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.md,
                    ),
                    fontWeight: AppFontWeights.regular,
                    fontFamily: 'Inter',
                    color: AppColors.button,
                  ),
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
        SizedBox(width: ResponsiveUtils.spacing(context, ResponsiveSpacing.md)),

        // Difficulty Selector
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Preferred Difficulty',
                style: TextStyle(
                  fontSize: ResponsiveUtils.fontSize(
                    context,
                    ResponsiveFontSize.sm,
                  ),
                  fontWeight: AppFontWeights.semiBold,
                  fontFamily: 'Inter',
                  color: AppColors.button.withValues(alpha: 0.9),
                  letterSpacing: 0.2,
                  height: 1.4,
                ),
              ),
              SizedBox(
                height: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
              ),
              SizedBox(
                height:
                    ResponsiveUtils.spacing(context, ResponsiveSpacing.xl) +
                    ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
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
