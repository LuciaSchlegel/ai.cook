import 'package:flutter/cupertino.dart';
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.lightYellow.withOpacity(0.08),
            AppColors.mutedGreen.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.mutedGreen.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.mutedGreen.withOpacity(0.2),
                  AppColors.lightYellow.withOpacity(0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              CupertinoIcons.heart_fill,
              size: 16,
              color: AppColors.mutedGreen,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              displayText,
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: AppColors.button.withOpacity(0.85),
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
