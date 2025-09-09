import 'package:flutter/cupertino.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/constants/dialog_constants.dart';
import 'package:ai_cook_project/theme.dart';

class AIConclusionSection extends StatelessWidget {
  final String conclusion;

  const AIConclusionSection({super.key, required this.conclusion});

  @override
  Widget build(BuildContext context) {
    final displayText =
        conclusion.isNotEmpty
            ? conclusion
            : 'Happy cooking! Let me know if you need any help with these recipes! 👨‍🍳✨';

    return Container(
      padding: const EdgeInsets.all(DialogConstants.spacingMD),
      decoration: DialogConstants.sectionDecoration.copyWith(
        gradient: DialogConstants.accentGradient,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: DialogConstants.iconContainerDecoration(
              AppColors.mutedGreen,
            ),
            child: Icon(
              CupertinoIcons.heart_fill,
              size: 16,
              color: AppColors.mutedGreen,
            ),
          ),
          const SizedBox(width: DialogConstants.spacingSM),
          Expanded(
            child: Text(
              displayText,
              style: DialogConstants.bodyTextStyle.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
