// widgets/skeleton/skeleton_card.dart

import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';

class SkeletonCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;
  final bool withShadow;

  const SkeletonCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 20,
    this.withShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow:
            withShadow
                ? [
                  BoxShadow(
                    color: AppColors.mutedGreen.withOpacity(0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
                : null,
        border: Border.all(
          color: AppColors.mutedGreen.withOpacity(0.12),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}
