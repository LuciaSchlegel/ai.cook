import 'package:ai_cook_project/dialogs/ai_recommendations/constants/dialog_constants.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:flutter/cupertino.dart';

class AIGreetingSection extends StatelessWidget {
  final String greeting;

  const AIGreetingSection({super.key, required this.greeting});

  @override
  Widget build(BuildContext context) {
    if (greeting.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: DialogConstants.spacingMD),
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
              CupertinoIcons.person_fill,
              size: 16,
              color: AppColors.mutedGreen,
            ),
          ),
          const SizedBox(width: DialogConstants.spacingSM),
          Expanded(child: Text(greeting, style: DialogConstants.bodyTextStyle)),
        ],
      ),
    );
  }
}
