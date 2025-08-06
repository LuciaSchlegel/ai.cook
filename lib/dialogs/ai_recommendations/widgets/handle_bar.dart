import 'package:ai_cook_project/theme.dart';
import 'package:flutter/cupertino.dart';

class HandleBar extends StatelessWidget {
  const HandleBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.mutedGreen.withOpacity(0.2),
            AppColors.mutedGreen.withOpacity(0.4),
            AppColors.mutedGreen.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
