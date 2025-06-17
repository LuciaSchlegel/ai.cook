import 'package:ai_cook_project/screens/login_screen.dart';
import 'package:ai_cook_project/screens/user_info_screen.dart';
import 'package:ai_cook_project/widgets/error_dialog.dart';
import 'package:ai_cook_project/widgets/loading_spinner.dart';
import 'package:ai_cook_project/widgets/navigation_text_link.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:ai_cook_project/providers/auth_provider.dart';
import 'package:ai_cook_project/providers/user_provider.dart';
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

  void _register() async {
    if (!_acceptedTerms) {
      showErrorDialog(
        context,
        message: 'Please accept the terms and conditions to continue',
      );
      return;
    }

    final auth = Provider.of<FBAuthProvider>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      showLoadingDialog(context, message: 'Signing up...');
      try {
        await auth.signUpWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        _emailController.clear();
        _passwordController.clear();
        if (context.mounted) {
          Navigator.pop(context);
          await Provider.of<UserProvider>(context, listen: false).getUser();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserInfoScreen()),
          );
        }
      } catch (e) {
        if (context.mounted) Navigator.pop(context);
        if (e is FirebaseAuthException) {
          String message = 'An error occurred. Please try again later.';

          if (e.code == 'email-already-in-use') {
            showErrorDialog(
              context,
              message: 'Email already in use',
              onResetPassword: () async {
                final auth = Provider.of<FBAuthProvider>(
                  context,
                  listen: false,
                );
                final email = _emailController.text.trim();

                showLoadingDialog(
                  context,
                  message: 'Sending password reset email...',
                );
                try {
                  await auth.resetPassword(email);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password reset email sent'),
                      ),
                    );
                  }
                } catch (_) {
                  if (context.mounted) Navigator.pop(context);
                  showErrorDialog(
                    context,
                    message: 'Failed to send reset email.',
                  );
                }
              },
            );
            return; // Add return to prevent showing error dialog twice
          } else if (e.code == 'invalid-email') {
            message = 'Invalid email address';
          } else if (e.code == 'weak-password') {
            message = 'Password is too weak';
          }

          showErrorDialog(context, message: message);
        }
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) return 'Invalid email address';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 6) return 'Minimum 6 characters';
    return null;
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
                        SizedBox(
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
                        ),
                        const SizedBox(height: 32),
                        FadeInUp(
                          delay: const Duration(milliseconds: 300),
                          duration: const Duration(milliseconds: 800),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Email",
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _emailController,
                                    validator: _validateEmail,
                                    style: const TextStyle(
                                      color: AppColors.black,
                                    ),
                                    decoration: _inputDecoration(),
                                  ),
                                  const SizedBox(height: 24),
                                  const Text(
                                    "Password",
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _passwordController,
                                    validator: _validatePassword,
                                    obscureText: true,
                                    style: const TextStyle(
                                      color: AppColors.black,
                                    ),
                                    decoration: _inputDecoration(),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: _acceptedTerms,
                                        onChanged: (value) {
                                          setState(() {
                                            _acceptedTerms = value ?? false;
                                          });
                                        },
                                        activeColor: AppColors.orange,
                                      ),
                                      Expanded(
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    'I accept the terms and conditions ',
                                                style: TextStyle(
                                                  color: AppColors.black,
                                                ),
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
                                  const SizedBox(
                                    height: 0,
                                  ), // Cambiado de 4 a 0
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: _acceptedNewsletter,
                                        onChanged: (value) {
                                          setState(() {
                                            _acceptedNewsletter =
                                                value ?? false;
                                          });
                                        },
                                        activeColor: AppColors.orange,
                                      ),
                                      Expanded(
                                        child: RichText(
                                          text: TextSpan(
                                            text: 'Subscribe to our newsletter',
                                            style: TextStyle(
                                              color: AppColors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ), // Espacio antes del botón
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: _register,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.orange,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
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
                                            builder:
                                                (context) =>
                                                    const LoginScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
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

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: AppColors.orange, width: 2),
      ),
    );
  }
}
