import 'dart:math' as math;

import 'package:ai_cook_project/widgets/clippers/optimized_aperture_clipper.dart';
import 'package:flutter/material.dart';

class AiDialogScaffold extends StatelessWidget {
  final AnimationController controller;
  final Animation<double> apertureAnimation;
  final Animation<double> contentOpacityAnimation;
  final Animation<double> contentScaleAnimation;
  final bool isOpen;
  final VoidCallback onClose;
  final Widget Function(ScrollController) scrollContentBuilder;

  const AiDialogScaffold({
    super.key,
    required this.controller,
    required this.apertureAnimation,
    required this.contentOpacityAnimation,
    required this.contentScaleAnimation,
    required this.isOpen,
    required this.onClose,
    required this.scrollContentBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        if (!isOpen && controller.value == 0.0) {
          return const SizedBox.shrink();
        }

        final size = MediaQuery.of(context).size;
        final maxRadius = math.sqrt(
          size.width * size.width + size.height * size.height,
        );

        return Material(
          type: MaterialType.transparency,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black54.withValues(alpha: controller.value * 0.5),
            child: Stack(
              children: [
                GestureDetector(
                  onTap: onClose,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.transparent,
                  ),
                ),
                ClipPath(
                  clipper: OptimizedApertureClipper(
                    progress: apertureAnimation.value,
                    maxRadius: maxRadius,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: DraggableScrollableSheet(
                      initialChildSize: 0.85,
                      minChildSize: 0.4,
                      maxChildSize: 0.95,
                      snap: true,
                      snapSizes: const [0.4, 0.7, 0.95],
                      builder: (context, scrollController) {
                        return Transform.scale(
                          scale: contentScaleAnimation.value,
                          child: Opacity(
                            opacity: contentOpacityAnimation.value,
                            child: scrollContentBuilder(scrollController),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
