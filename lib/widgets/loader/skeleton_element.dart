import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';

class SkeletonElement extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadius borderRadius;
  final Animation<double> animation;

  const SkeletonElement({
    super.key,
    required this.height,
    required this.width,
    required this.borderRadius,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [
            (animation.value - 1).clamp(0.0, 1.0),
            animation.value.clamp(0.0, 1.0),
            (animation.value + 1).clamp(0.0, 1.0),
          ],
          colors: [
            AppColors.mutedGreen.withOpacity(0.08),
            AppColors.mutedGreen.withOpacity(0.15),
            AppColors.mutedGreen.withOpacity(0.08),
          ],
        ),
      ),
    );
  }
}
