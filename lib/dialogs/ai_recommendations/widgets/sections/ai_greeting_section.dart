import 'package:ai_cook_project/theme.dart';
import 'package:flutter/cupertino.dart';

class AIGreetingSection extends StatelessWidget {
  final String greeting;

  const AIGreetingSection({super.key, required this.greeting});

  @override
  Widget build(BuildContext context) {
    if (greeting.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.lightYellow.withValues(alpha: 0.1),
            AppColors.mutedGreen.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.mutedGreen.withValues(alpha: 0.1),
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
                  AppColors.mutedGreen.withValues(alpha: 0.2),
                  AppColors.lightYellow.withValues(alpha: 0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              CupertinoIcons.person_fill,
              size: 16,
              color: AppColors.mutedGreen,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              greeting,
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: AppColors.button.withValues(alpha: 0.85),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
