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
            screenWidth > 600
                ? 550.0
                : screenWidth > 400
                ? screenWidth * 0.95
                : screenWidth * 0.98;

        return Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: screenHeight,
                maxWidth: formWidth,
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
