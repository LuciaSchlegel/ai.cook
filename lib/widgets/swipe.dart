import 'package:ai_cook_project/theme.dart';
import 'package:flutter/cupertino.dart';

class SwipeIndicator extends StatelessWidget {
  const SwipeIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 16,
      child: Column(
        children: [
          Icon(
            CupertinoIcons.chevron_up,
            size: 20,
            color: AppColors.mutedGreen.withOpacity(0.6),
          ),
          const SizedBox(height: 4),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.mutedGreen.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
