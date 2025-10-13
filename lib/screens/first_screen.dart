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

    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Padding(
              padding: ResponsiveUtils.padding(context, ResponsiveSpacing.xl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Text(
                    'ai.Cook',
                    style: AppTextStyles.melodrama(
                      fontSize:
                          deviceType == DeviceType.iPadPro
                              ? ResponsiveUtils.fontSize(
                                context,
                                ResponsiveFontSize.display3,
                              )
                              : ResponsiveUtils.fontSize(
                                context,
                                ResponsiveFontSize.display2,
                              ),
                      color: AppColors.white,
                      fontWeight: AppFontWeights.medium,
                      letterSpacing: 0.8,
                      height: 1.4,
                    ),
                  ),
                  const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.md),

                  // Apple Button
                  Container(
                    padding: ResponsiveUtils.padding(
                      context,
                      deviceType == DeviceType.iPadPro
                          ? ResponsiveSpacing.xxs
                          : ResponsiveSpacing.sm,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: ResponsiveUtils.getOptimalContentWidth(
                            context,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            await authProvider.signInWithApple();
                          },
                          child: Container(
                            width: double.infinity,
                            height:
                                ResponsiveUtils.spacing(
                                  context,
                                  ResponsiveSpacing.xxl,
                                ) *
                                1.2,
                            padding: ResponsiveUtils.padding(
                              context,
                              ResponsiveSpacing.md,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.button,
                              borderRadius: BorderRadius.circular(
                                ResponsiveUtils.borderRadius(
                                  context,
                                  ResponsiveBorderRadius.xxl,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'assets/icons/apple-logo.png',
                                    height: ResponsiveUtils.iconSize(
                                      context,
                                      ResponsiveIconSize.lg,
                                    ),
                                  ),
                                  ResponsiveSpacingWidget.horizontal(
                                    ResponsiveSpacing.sm,
                                  ),
                                  ResponsiveText(
                                    "Continue with Apple",
                                    color: AppColors.white,
                                    fontSize: ResponsiveUtils.fontSize(
                                      context,
                                      ResponsiveFontSize.md,
                                    ),
                                    fontWeight: AppFontWeights.medium,
                                    fontFamily: 'Inter',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: ResponsiveUtils.padding(
                      context,
                      ResponsiveSpacing.sm,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: ResponsiveUtils.getOptimalContentWidth(
                            context,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  await authProvider.signInWithGoogle();
                                },
                                child: Container(
                                  height:
                                      ResponsiveUtils.spacing(
                                        context,
                                        ResponsiveSpacing.xxl,
                                      ) *
                                      1.2,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(
                                      ResponsiveUtils.borderRadius(
                                        context,
                                        ResponsiveBorderRadius.xxl,
                                      ),
                                    ),
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/icons/google-logo.png',
                                      height: ResponsiveUtils.iconSize(
                                        context,
                                        ResponsiveIconSize.lg,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            ResponsiveSpacingWidget.horizontal(
                              ResponsiveSpacing.md,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/login');
                                },
                                child: Container(
                                  height:
                                      ResponsiveUtils.spacing(
                                        context,
                                        ResponsiveSpacing.xxl,
                                      ) *
                                      1.2,
                                  decoration: BoxDecoration(
                                    color: AppColors.orange,
                                    borderRadius: BorderRadius.circular(
                                      ResponsiveUtils.borderRadius(
                                        context,
                                        ResponsiveBorderRadius.xxl,
                                      ),
                                    ),
                                  ),
                                  child: Center(
                                    child: ResponsiveText(
                                      "Sign in",
                                      fontSize: ResponsiveUtils.fontSize(
                                        context,
                                        ResponsiveFontSize.md,
                                      ),
                                      fontWeight: AppFontWeights.medium,
                                      color: AppColors.white,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.xl),

                  // Sign Up
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/sign_up');
                    },
                    child: ResponsiveText(
                      'Sign up',
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        ResponsiveFontSize.md,
                      ),
                      fontWeight: AppFontWeights.medium,
                      fontFamily: 'Inter',
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
      },
    );
  }
}
