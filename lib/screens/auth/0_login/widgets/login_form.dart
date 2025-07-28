import 'package:ai_cook_project/utils/field_validator.dart';
import 'package:ai_cook_project/widgets/buttons/auth_button.dart';
import 'package:ai_cook_project/widgets/utils/custom_text_field.dart';
import 'package:ai_cook_project/widgets/buttons/navigation_text_link.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final VoidCallback onLogin;
  final VoidCallback onForgotPassword;
  final VoidCallback onRegister;

  const LoginForm({
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    required this.onLogin,
    required this.onForgotPassword,
    required this.onRegister,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      delay: const Duration(milliseconds: 300),
      duration: const Duration(milliseconds: 800),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 15,
              spreadRadius: 1,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: emailController,
                label: 'Email',
                validator: FieldValidator.validateEmail,
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: passwordController,
                label: 'Password',
                validator: FieldValidator.validatePassword,
                obscureText: true,
              ),
              const SizedBox(height: 24),
              AuthButton(label: 'Sign in', onPressed: onLogin),
              const SizedBox(height: 16),
              NavigationTextLink(
                label: 'Forgot your password ?',
                onTap: onForgotPassword,
              ),
              const SizedBox(height: 16),
              NavigationTextLink(
                label: 'Don\'t have an account? Sign up',
                onTap: onRegister,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
