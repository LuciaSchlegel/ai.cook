import 'package:ai_cook_project/screens/auth/0_login/widgets/login_form.dart';
import 'package:ai_cook_project/screens/auth/logic/reset_pass.dart';
import 'package:ai_cook_project/screens/auth/services/auth_services.dart';
import 'package:ai_cook_project/screens/main/main_screen.dart';
import 'package:ai_cook_project/screens/auth/0_signup/signup_screen.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_container.dart';
import 'package:ai_cook_project/widgets/error_dialog.dart';
import 'package:ai_cook_project/widgets/loading_spinner.dart';
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
        // Intenta cerrar el diálogo de loading si está abierto
        if (Navigator.of(context, rootNavigator: true).canPop()) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      },
      onSuccess: () {
        _emailController.clear();
        _passwordController.clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
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
    AuthService.forgotPassword(
      context: context,
      email: _emailController.text,
      showLoading:
          () => showLoadingDialog(context, message: 'Sending reset email...'),
      hideLoading: () {
        if (context.mounted) Navigator.pop(context);
      },
      onSuccess: () {
        _emailController.clear();
        _passwordController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset email sent')),
        );
      },
      onError: (msg, {exception}) {
        showErrorDialog(context, message: msg);
      },
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
      body: ResponsiveContainer(
        child: LoginForm(
          emailController: _emailController,
          passwordController: _passwordController,
          formKey: _formKey,
          onLogin: _login,
          onForgotPassword: _forgotPassword,
          onRegister: _register,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showErrorDialog(context, message: "Esto es un error de prueba");
        },
        child: const Icon(Icons.error),
      ),
    );
  }
}
