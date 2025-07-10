import 'package:ai_cook_project/theme.dart';
import 'package:flutter/cupertino.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.search,
            size: 48,
            color: AppColors.button.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Ingredients Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.button,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.button.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }
}
