import 'dart:math' as math;

import 'package:ai_cook_project/dialogs/ai_recommendations/constants/dialog_constants.dart';
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

  // Responsive helper methods
  double _getInitialSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < DialogConstants.mobileBreakpoint) {
      return 0.9; // Larger on mobile for better usability
    } else if (screenWidth < DialogConstants.tabletBreakpoint) {
      return 0.85;
    } else {
      return 0.8; // Smaller on desktop
    }
  }

  double _getMinSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < DialogConstants.mobileBreakpoint) {
      return 0.5; // Higher minimum on mobile
    } else {
      return 0.4;
    }
  }

  double _getMaxSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < DialogConstants.mobileBreakpoint) {
      return 0.95;
    } else {
      return 0.9; // Leave more space on larger screens
    }
  }

  List<double> _getSnapSizes(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < DialogConstants.mobileBreakpoint) {
      return [0.5, 0.75, 0.95]; // Mobile-optimized snap points
    } else {
      return [0.4, 0.7, 0.9]; // Desktop-optimized snap points
    }
  }

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
                      initialChildSize: _getInitialSize(context),
                      minChildSize: _getMinSize(context),
                      maxChildSize: _getMaxSize(context),
                      snap: true,
                      snapSizes: _getSnapSizes(context),
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
