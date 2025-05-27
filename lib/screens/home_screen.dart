//home_screen.dart
import 'package:ai_cook_project/widgets/social_widget.dart';
import 'package:ai_cook_project/widgets/weekly_card.dart';
import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: AppColors.background,
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.02),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome,',
                          style: TextStyle(
                            fontFamily: 'Casta',
                            fontSize: 48,
                            color: Colors.white,
                            height: 1.1,
                          ),
                        ),
                        Text(
                          'lucia',
                          style: TextStyle(
                            fontFamily: 'Casta',
                            fontSize: 48,
                            color: Colors.white,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.03),
                    Divider(
                      color: Color.fromRGBO(238, 238, 238, 0.498),
                      thickness: 1,
                    ),
                    SizedBox(height: size.height * 0.03),
                    const Center(child: WeeklyCard()),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.04),
              const SocialCarousel(),
              SizedBox(height: size.height * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}
