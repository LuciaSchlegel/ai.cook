import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class WelcomeMessage extends StatelessWidget {
  const WelcomeMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Center(
        child: DefaultTextStyle(
          style: const TextStyle(
            fontSize: 40.0,
            fontFamily: 'Casta',
            color: Colors.white,
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
  }
}
