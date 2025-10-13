import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:flutter/material.dart';

class FloatingAddButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String heroTag;

  const FloatingAddButton({
    required this.onPressed,
    this.heroTag = 'add_button',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: ResponsiveUtils.spacing(context, ResponsiveSpacing.lg),
      ),
      child: FloatingActionButton(
        heroTag: heroTag,
        onPressed: onPressed,
        backgroundColor: AppColors.button.withValues(alpha: 0.9),
        elevation: 2,
        shape: const CircleBorder(),
        child: const ResponsiveIcon(
          Icons.add,
          null,
          color: AppColors.white,
          size: ResponsiveIconSize.lg,
        ),
      ),
    );
  }
}
