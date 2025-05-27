import 'package:ai_cook_project/providers/auth_provider.dart';
import 'package:ai_cook_project/screens/main_screen.dart';
import 'package:ai_cook_project/screens/signup_screen.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/widgets/auth_button.dart';
import 'package:ai_cook_project/widgets/custom_text_field.dart';
import 'package:ai_cook_project/widgets/error_dialog.dart';
import 'package:ai_cook_project/widgets/loading_spinner.dart';
import 'package:ai_cook_project/widgets/navigation_text_link.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? error;

  void _login() async {
    final auth = Provider.of<FBAuthProvider>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      showLoadingDialog(context, message: 'Logging in...');
      try {
        await auth.signInWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        _emailController.clear();
        _passwordController.clear();
        setState(() {
          error = null;
        });

        if (context.mounted) {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainScreen()),
          );
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.pop(context);
        }
        if (e is FirebaseAuthException) {
          String message;
          if (e.code == 'user-not-found') {
            message = 'No user found for that email.';
          } else if (e.code == 'invalid-credential') {
            message = 'Invalid email or password.';
          } else if (e.code == 'too-many-requests') {
            message = 'Too many requests. Please try again later.';
          } else if (e.code == 'operation-not-allowed') {
            message =
                'Email/password sign-in is not enabled. Please contact support.';
          } else if (e.code == 'network-request-failed') {
            message = 'Network error. Please check your internet connection.';
          } else if (e.code == 'user-disabled') {
            message = 'This user has been disabled. Please contact support.';
          } else {
            message = 'An error occurred. Please try again later.';
          }
          showErrorDialog(context, message: message);
        } else {
          showErrorDialog(
            context,
            message: e.toString().replaceAll('Exception: ', ''),
          );
        }
      }
    }
  }

  void _register() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SignupScreen()),
    );
  }

  void _forgotPassword() async {
    final auth = Provider.of<FBAuthProvider>(context, listen: false);
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      showErrorDialog(context, message: 'Please enter your email');
      return;
    }

    showLoadingDialog(context, message: 'Sending password reset email...');

    try {
      await auth.resetPassword(email);
      _emailController.clear();
      _passwordController.clear();
      setState(() => error = null);

      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset email sent')),
        );
      }
    } catch (e) {
      if (context.mounted) Navigator.pop(context);
      if (context.mounted) Navigator.pop(context);

      if (e is FirebaseAuthException) {
        String message;
        if (e.code == 'user-not-found') {
          message = 'No user found for that email.';
        } else if (e.code == 'invalid-email') {
          message = 'Invalid email address';
        } else if (e.code == 'too-many-requests') {
          message = 'Too many requests. Please try again later.';
        } else {
          message = 'An error occurred. Please try again later.';
        }

        showErrorDialog(context, message: message);
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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenHeight = constraints.maxHeight;
            final screenWidth = constraints.maxWidth;

            // Ajustamos las proporciones del formulario
            final formWidth =
                screenWidth > 600
                    ? 550.0
                    : screenWidth > 400
                    ? screenWidth * 0.95
                    : screenWidth * 0.98;

            return Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: screenHeight,
                    maxWidth: formWidth,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth > 600 ? 48 : 16,
                        vertical: 24,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 32),
                          FadeInUp(
                            delay: const Duration(milliseconds: 300),
                            duration: const Duration(milliseconds: 800),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth > 600 ? 48 : 24,
                                vertical: 32,
                              ),
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
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomTextField(
                                      controller: _emailController,
                                      label: 'Email',
                                      validator: _validateEmail,
                                    ),
                                    const SizedBox(height: 24),
                                    CustomTextField(
                                      controller: _passwordController,
                                      label: 'Password',
                                      validator: _validatePassword,
                                      obscureText: true,
                                    ),
                                    const SizedBox(height: 24),
                                    AuthButton(
                                      label: 'Sign in',
                                      onPressed: _login,
                                    ),
                                    const SizedBox(height: 16),
                                    NavigationTextLink(
                                      label: 'Forgot your password ?',
                                      onTap: _forgotPassword,
                                    ),
                                    const SizedBox(height: 16),
                                    NavigationTextLink(
                                      label: 'Don\'t have an account? Sign up',
                                      onTap: _register,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
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
