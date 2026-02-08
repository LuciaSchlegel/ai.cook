import 'dart:math' as math;
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Sophisticated AI-themed loading indicator with animated gradient
class AILoadingIndicator extends StatefulWidget {
  final String message;
  final Color? accentColor;

  const AILoadingIndicator({
    super.key,
    this.message = 'Processing...',
    this.accentColor,
  });

  @override
  State<AILoadingIndicator> createState() => _AILoadingIndicatorState();
}

class _AILoadingIndicatorState extends State<AILoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = widget.accentColor ?? const Color(0xFF8B5CF6);

    return Container(
      padding: ResponsiveUtils.padding(context, ResponsiveSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated ring indicator
          SizedBox(
            width:
                ResponsiveUtils.iconSize(context, ResponsiveIconSize.xxl) * 1.5,
            height:
                ResponsiveUtils.iconSize(context, ResponsiveIconSize.xxl) * 1.5,
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _rotationController,
                _pulseAnimation,
              ]),
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer glow
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withValues(
                                alpha: 0.2 * _pulseAnimation.value,
                              ),
                              blurRadius: ResponsiveUtils.spacing(
                                context,
                                ResponsiveSpacing.lg,
                              ),
                              spreadRadius: ResponsiveUtils.spacing(
                                context,
                                ResponsiveSpacing.xs,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Rotating gradient ring
                      Transform.rotate(
                        angle: _rotationController.value * 2 * math.pi,
                        child: CustomPaint(
                          size: Size(
                            ResponsiveUtils.iconSize(
                                  context,
                                  ResponsiveIconSize.xxl,
                                ) *
                                1.5,
                            ResponsiveUtils.iconSize(
                                  context,
                                  ResponsiveIconSize.xxl,
                                ) *
                                1.5,
                          ),
                          painter: _GradientRingPainter(
                            progress: _rotationController.value,
                            accentColor: accentColor,
                          ),
                        ),
                      ),
                      // Center sparkle icon
                      ShaderMask(
                        shaderCallback:
                            (bounds) => LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                accentColor,
                                accentColor.withValues(alpha: 0.7),
                              ],
                            ).createShader(bounds),
                        child: Icon(
                          CupertinoIcons.sparkles,
                          size: ResponsiveUtils.iconSize(
                            context,
                            ResponsiveIconSize.lg,
                          ),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.lg),
          ),
          // Message with animated dots
          _AnimatedLoadingText(
            message: widget.message,
            accentColor: accentColor,
          ),
        ],
      ),
    );
  }
}

/// Custom painter for gradient ring
class _GradientRingPainter extends CustomPainter {
  final double progress;
  final Color accentColor;

  _GradientRingPainter({required this.progress, required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 3;

    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round;

    // Draw gradient arc
    final gradient = SweepGradient(
      startAngle: 0,
      endAngle: math.pi * 2,
      colors: [
        accentColor.withValues(alpha: 0.0),
        accentColor.withValues(alpha: 0.3),
        accentColor.withValues(alpha: 0.6),
        accentColor,
        accentColor.withValues(alpha: 0.6),
        accentColor.withValues(alpha: 0.3),
        accentColor.withValues(alpha: 0.0),
      ],
      stops: const [0.0, 0.15, 0.3, 0.5, 0.7, 0.85, 1.0],
    );

    paint.shader = gradient.createShader(
      Rect.fromCircle(center: center, radius: radius),
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      math.pi * 2,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_GradientRingPainter oldDelegate) =>
      progress != oldDelegate.progress;
}

/// Animated loading text with dots
class _AnimatedLoadingText extends StatefulWidget {
  final String message;
  final Color accentColor;

  const _AnimatedLoadingText({
    required this.message,
    required this.accentColor,
  });

  @override
  State<_AnimatedLoadingText> createState() => _AnimatedLoadingTextState();
}

class _AnimatedLoadingTextState extends State<_AnimatedLoadingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _dotsController;

  @override
  void initState() {
    super.initState();
    _dotsController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _dotsController,
      builder: (context, child) {
        final dotCount = (_dotsController.value * 4).floor() % 4;
        final dots = '.' * dotCount;

        return Text(
          '${widget.message}$dots',
          style: AppTextStyles.inter(
            fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.sm),
            fontWeight: AppFontWeights.medium,
            color: widget.accentColor.withValues(alpha: 0.8),
            letterSpacing: 0.2,
          ),
        );
      },
    );
  }
}
