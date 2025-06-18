import 'package:ai_cook_project/screens/auth/logic/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_cook_project/providers/auth_provider.dart';

class AuthService {
  static Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
    required GlobalKey<FormState> formKey,
    VoidCallback? onSuccess,
    void Function(String error)? onError,
    VoidCallback? showLoading,
    VoidCallback? hideLoading,
  }) async {
    final auth = Provider.of<FBAuthProvider>(context, listen: false);
    if (formKey.currentState!.validate()) {
      showLoading?.call();
      try {
        await auth.signInWithEmailAndPassword(email.trim(), password.trim());
        formKey.currentState!.reset();
        onSuccess?.call();
      } catch (e) {
        onError?.call(FirebaseErrorHandler.handleError(e));
      } finally {
        hideLoading?.call();
      }
    }
  }

  static Future<void> forgotPassword({
    required BuildContext context,
    required String email,
    VoidCallback? onSuccess,
    void Function(String error)? onError,
    VoidCallback? showLoading,
    VoidCallback? hideLoading,
  }) async {
    final auth = Provider.of<FBAuthProvider>(context, listen: false);
    if (email.isEmpty) {
      onError?.call('Please enter your email');
      return;
    }

    showLoading?.call();
    try {
      await auth.resetPassword(email.trim());
      onSuccess?.call();
    } catch (e) {
      onError?.call(FirebaseErrorHandler.handleError(e));
    } finally {
      hideLoading?.call();
    }
  }
}
