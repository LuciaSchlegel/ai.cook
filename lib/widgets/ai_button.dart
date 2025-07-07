import 'package:ai_cook_project/theme.dart';
import 'package:flutter/material.dart';

class AiButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isActive;

  const AiButton({super.key, required this.onPressed, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = screenWidth < 400 ? 52.0 : 64.0;
    final borderWidth = 4.0;

    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Center(
            child: Container(
              width: buttonSize,
              height: buttonSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.orange.withOpacity(0.18),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(
                  width: borderWidth,
                  style: BorderStyle.solid,
                  color: Colors.transparent, // Necesario para usar foreground
                ),
                // El gradiente se aplica con foregroundPainter
              ),
              child: CustomPaint(
                painter: _GradientBorderPainter(
                  strokeWidth: borderWidth,
                  gradient: LinearGradient(
                    colors:
                        isActive
                            ? [const Color(0xFFF8D794), AppColors.orange]
                            : [AppColors.orange, const Color(0xFFF8D794)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: AnimatedRotation(
                    turns: isActive ? 0.25 : 0.0, // 0.25 vueltas = 90 grados
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    child: Image.asset(
                      'assets/icons/ai.png',
                      width: buttonSize * 0.56, // ~36 para 64px
                      height: buttonSize * 0.56,
                      color: AppColors.orange,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GradientBorderPainter extends CustomPainter {
  final double strokeWidth;
  final Gradient gradient;

  _GradientBorderPainter({required this.strokeWidth, required this.gradient});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint =
        Paint()
          ..shader = gradient.createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth;
    canvas.drawCircle(
      size.center(Offset.zero),
      (size.width / 2) - strokeWidth / 2,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
