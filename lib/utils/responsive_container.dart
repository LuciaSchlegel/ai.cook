import 'package:flutter/material.dart';

class ResponsiveContainer extends StatelessWidget {
  final Widget child;

  const ResponsiveContainer({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = constraints.maxHeight;
        final screenWidth = constraints.maxWidth;
        final formWidth =
            screenWidth > 800
                ? 600.0
                : screenWidth > 600
                ? screenWidth * 0.85
                : screenWidth * 0.95;

        final formHeight =
            screenHeight > 700
                ? screenHeight * 0.5
                : screenHeight > 500
                ? screenHeight * 0.85
                : screenHeight * 0.95;
        return Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: formHeight,
                maxWidth: formWidth,
                maxHeight: screenHeight * 0.95,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth > 600 ? 48 : 16,
                    vertical: 24,
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
