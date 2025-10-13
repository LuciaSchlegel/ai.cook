import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/cupertino.dart';

class FormComments extends StatelessWidget {
  final TextEditingController preferencesController;

  const FormComments({super.key, required this.preferencesController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.md),
        ),
        border: Border.all(
          color: AppColors.button.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.button.withValues(alpha: 0.03),
            blurRadius: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: CupertinoTextField(
        controller: preferencesController,
        placeholder: 'e.g. I prefer spicy food, vegetarian dishes...',
        maxLines: 3,
        textInputAction: TextInputAction.done,
        padding: ResponsiveUtils.padding(context, ResponsiveSpacing.sm),
        placeholderStyle: TextStyle(
          fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.md),
          color: AppColors.button.withValues(alpha: 0.5),
        ),
        style: TextStyle(
          fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.md),
          color: AppColors.button,
          fontWeight: AppFontWeights.regular,
          fontFamily: 'Inter',
        ),
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
