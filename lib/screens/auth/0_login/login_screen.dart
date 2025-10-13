import 'package:ai_cook_project/screens/auth/0_login/widgets/login_form.dart';
import 'package:ai_cook_project/screens/auth/logic/reset_pass.dart';
import 'package:ai_cook_project/screens/auth/services/auth_services.dart';
import 'package:ai_cook_project/screens/main/main_screen.dart';
import 'package:ai_cook_project/screens/auth/0_signup/signup_screen.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:ai_cook_project/dialogs/error_dialog.dart';
import 'package:ai_cook_project/widgets/status/loading_spinner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() {
    AuthService.login(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
      formKey: _formKey,
      showLoading: () => showLoadingDialog(context, message: 'Logging in...'),
      hideLoading: () {
        if (Navigator.of(context, rootNavigator: true).canPop()) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      },
      onSuccess: () {
        Future.microtask(() {
          if (!mounted) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MainScreen()),
          );
        });
      },
      onError: (msg, {exception}) async {
        await Future.delayed(const Duration(milliseconds: 100));
        if (mounted && exception?.code == 'user-not-found') {
          await handleExistingEmail(
            context: context,
            email: _emailController.text.trim(),
          );
          return;
        } else if (mounted) {
          showErrorDialog(context, message: msg);
        }
      },
    );
  }

  void _register() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SignupScreen()),
    );
  }

  void _forgotPassword() {
    if (_emailController.text.trim().isEmpty) {
      showErrorDialog(
        context,
        message: 'Please enter your email address to reset your password.',
      );
      return;
    }

    if (!RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(_emailController.text.trim())) {
      showErrorDialog(context, message: 'Please enter a valid email address.');
      return;
    }

    AuthService.forgotPassword(
      context: context,
      email: _emailController.text.trim(),
      showLoading:
          () => showLoadingDialog(context, message: 'Sending reset email...'),
      hideLoading: () {
        if (context.mounted) Navigator.pop(context);
      },
      onSuccess: () async {
        await Future.delayed(const Duration(milliseconds: 100));
        if (!context.mounted) return;

        _showSuccessDialog();
      },
      onError: (msg, {exception}) {
        showErrorDialog(context, message: msg);
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder:
          (context) => CupertinoAlertDialog(
            title: Icon(
              CupertinoIcons.checkmark_circle_fill,
              color: AppColors.orange,
              size: 40,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Password reset email sent to:\n${_emailController.text.trim()}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Check your email and follow the instructions to reset your password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            actions: [
              CupertinoDialogAction(
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: AppColors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
    );
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
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: ResponsiveUtils.getOptimalContentWidth(context),
            ),
            child: SingleChildScrollView(
              padding: ResponsiveUtils.padding(context, ResponsiveSpacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ResponsiveSpacingWidget.vertical(ResponsiveSpacing.xxl),
                  LoginForm(
                    emailController: _emailController,
                    passwordController: _passwordController,
                    formKey: _formKey,
                    onLogin: _login,
                    onForgotPassword: _forgotPassword,
                    onRegister: _register,
                  ),
                  ResponsiveSpacingWidget.vertical(ResponsiveSpacing.xxl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
