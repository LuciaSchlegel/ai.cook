// widgets/navigation_text_link.dart
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/material.dart';

class NavigationTextLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final TextStyle? style;

  const NavigationTextLink({
    required this.label,
    required this.onTap,
    this.style,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          label,
          style:
              style ??
              TextStyle(
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  ResponsiveFontSize.sm,
                ),
                fontWeight: AppFontWeights.medium,
                fontFamily: 'Inter',
                color: AppColors.button,
              ),
        ),
      ),
    );
  }
}
