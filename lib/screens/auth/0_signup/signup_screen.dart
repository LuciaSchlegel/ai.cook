import 'package:ai_cook_project/screens/auth/0_signup/widgets/welcome_message.dart';
import 'package:ai_cook_project/screens/auth/0_signup/widgets/sign_up_form.dart';
import 'package:ai_cook_project/screens/auth/logic/sign_up_controller.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:ai_cook_project/theme.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _acceptedTerms = false;
  bool _acceptedNewsletter = false;

  void _register() {
    handleRegister(
      context: context,
      formKey: _formKey,
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      acceptedTerms: _acceptedTerms,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenHeight = constraints.maxHeight;
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: screenHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 48),
                        WelcomeMessage(),
                        const SizedBox(height: 32),
                        FadeInUp(
                          delay: const Duration(milliseconds: 300),
                          duration: const Duration(milliseconds: 800),
                          child: SignUpForm(
                            formKey: _formKey,
                            emailController: _emailController,
                            passwordController: _passwordController,
                            onSignUp: _register,
                            acceptedTerms: _acceptedTerms,
                            acceptedNewsletter: _acceptedNewsletter,
                            onToggleTerms: (value) {
                              setState(() {
                                _acceptedTerms = value ?? false;
                              });
                            },
                            onToggleNewsletter: (value) {
                              setState(() {
                                _acceptedNewsletter = value ?? false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
