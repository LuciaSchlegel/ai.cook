import 'package:ai_cook_project/screens/auth/0_login/login_screen.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/field_validator.dart';
import 'package:ai_cook_project/widgets/custom_text_field.dart';
import 'package:ai_cook_project/widgets/navigation_text_link.dart';
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
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            CustomTextField(
              label: "Email",
              controller: emailController,
              validator: FieldValidator.validateEmail,
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: "Password",
              controller: passwordController,
              validator: FieldValidator.validatePassword,
              obscureText: true,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: acceptedTerms,
                  onChanged: onToggleTerms,
                  activeColor: AppColors.orange,
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'I accept the terms and conditions ',
                          style: TextStyle(color: AppColors.black),
                        ),
                        TextSpan(
                          text: '*',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 0), // Cambiado de 4 a 0
            Row(
              children: [
                Checkbox(
                  value: acceptedNewsletter,
                  onChanged: onToggleNewsletter,
                  activeColor: AppColors.orange,
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: 'Subscribe to our newsletter',
                      style: TextStyle(color: AppColors.black),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24), // Espacio antes del botón
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onSignUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Sign up'),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.all(10),
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
