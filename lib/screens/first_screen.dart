import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<FBAuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: ResponsiveUtils.padding(context, ResponsiveSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              const ResponsiveText(
                'ai.cook',
                fontSize: ResponsiveFontSize.display2,
                fontWeight: FontWeight.normal,
                color: AppColors.white,
                fontFamily: 'Casta',
              ),
              const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.xl),

              // Apple Button
              GestureDetector(
                onTap: () async {
                  await authProvider.signInWithApple();
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.button,
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.borderRadius(
                        context,
                        ResponsiveBorderRadius.xl,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/icons/apple-logo.png', height: 24),
                        const ResponsiveSpacingWidget.horizontal(
                          ResponsiveSpacing.xs,
                        ),
                        const ResponsiveText(
                          "Continue with Apple",
                          color: AppColors.white,
                          fontSize: ResponsiveFontSize.sm,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.md),

              // Google + Sign In
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        await authProvider.signInWithGoogle();
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(
                            ResponsiveUtils.borderRadius(
                              context,
                              ResponsiveBorderRadius.xl,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/icons/google-logo.png',
                            height: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const ResponsiveSpacingWidget.horizontal(
                    ResponsiveSpacing.md,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orange,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveUtils.borderRadius(
                              context,
                              ResponsiveBorderRadius.xl,
                            ),
                          ),
                        ),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const ResponsiveText(
                        "Sign in",
                        fontSize: ResponsiveFontSize.sm,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.xl),

              // Sign Up
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/sign_up');
                },
                child: const ResponsiveText(
                  'Sign up',
                  fontSize: ResponsiveFontSize.sm,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  height: 2.5,
                  color: AppColors.white,
                  decorationColor: AppColors.white,
                  decorationStyle: TextDecorationStyle.solid,
                  decorationThickness: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
