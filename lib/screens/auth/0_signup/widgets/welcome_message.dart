import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:flutter/material.dart';

class WelcomeMessage extends StatelessWidget {
  const WelcomeMessage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get responsive height for the welcome message container
    final containerHeight =
        ResponsiveUtils.spacing(context, ResponsiveSpacing.xxl) * 3;

    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return SizedBox(
          height: containerHeight,
          child: Center(
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize:
                    ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.title2,
                    ) *
                    1.02,
                fontFamily: 'Melodrama',
                color: Colors.white,
                fontWeight: AppFontWeights.medium,
                letterSpacing: 1.2,
                height: 1.2,
              ),
              child: AnimatedTextKit(
                totalRepeatCount: 1,
                animatedTexts: [
                  TypewriterAnimatedText(
                    'ready to become a(i) chef?',
                    speed: const Duration(milliseconds: 125),
                    cursor: '|',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
