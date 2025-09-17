import 'package:ai_cook_project/screens/auth/0_login/login_screen.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/field_validator.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:ai_cook_project/widgets/utils/custom_text_field.dart';
import 'package:ai_cook_project/widgets/buttons/navigation_text_link.dart';
import 'package:flutter/material.dart';

class SignUpForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final VoidCallback onSignUp;
  final bool acceptedTerms;
  final bool acceptedNewsletter;
  final ValueChanged<bool?> onToggleTerms;
  final ValueChanged<bool?> onToggleNewsletter;

  const SignUpForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.onSignUp,
    required this.acceptedTerms,
    required this.acceptedNewsletter,
    required this.onToggleTerms,
    required this.onToggleNewsletter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      padding: ResponsiveSpacing.lg,
      backgroundColor: Colors.white,
      borderRadius: ResponsiveBorderRadius.xxl,
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ResponsiveSpacingWidget.vertical(ResponsiveSpacing.xs),
            CustomTextField(
              label: "Email",
              controller: emailController,
              validator: FieldValidator.validateEmail,
            ),
            ResponsiveSpacingWidget.vertical(ResponsiveSpacing.lg),
            CustomTextField(
              label: "Password",
              controller: passwordController,
              validator: FieldValidator.validatePassword,
              obscureText: true,
            ),
            ResponsiveSpacingWidget.vertical(ResponsiveSpacing.md),
            _CheckboxRow(
              value: acceptedTerms,
              onChanged: onToggleTerms,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'I accept the terms and conditions ',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.black,
                        fontSize: ResponsiveUtils.fontSize(
                          context,
                          ResponsiveFontSize.sm,
                        ),
                      ),
                    ),
                    TextSpan(
                      text: '*',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: ResponsiveUtils.fontSize(
                          context,
                          ResponsiveFontSize.sm,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _CheckboxRow(
              value: acceptedNewsletter,
              onChanged: onToggleNewsletter,
              child: ResponsiveText(
                'Subscribe to our newsletter',
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  ResponsiveFontSize.sm,
                ),
                color: AppColors.black,
                fontFamily: 'Inter',
              ),
            ),
            ResponsiveSpacingWidget.vertical(ResponsiveSpacing.lg),
            _ResponsiveSignUpButton(onPressed: onSignUp),
            ResponsiveSpacingWidget.vertical(ResponsiveSpacing.sm),
            ResponsiveContainer(
              padding: ResponsiveSpacing.sm,
              child: NavigationTextLink(
                label: 'Already have an account? Sign in',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Responsive checkbox row widget
class _CheckboxRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final Widget child;

  const _CheckboxRow({
    required this.value,
    required this.onChanged,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: ResponsiveUtils.spacing(context, ResponsiveSpacing.xxs),
      ),
      child: Row(
        children: [
          Transform.scale(
            scale: ResponsiveUtils.isIPhone(context) ? 1.0 : 1.2,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.orange,
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

/// Responsive sign up button
class _ResponsiveSignUpButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ResponsiveSignUpButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.xl),
            ),
          ),
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
          ),
        ),
        child: ResponsiveText(
          'Sign up',
          fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.md),
          fontWeight: AppFontWeights.medium,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}
