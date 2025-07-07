import 'package:ai_cook_project/screens/auth/logic/reset_pass.dart';
import 'package:ai_cook_project/screens/auth/services/auth_services.dart';
import 'package:ai_cook_project/screens/userInfo/user_info_screen.dart';
import 'package:ai_cook_project/widgets/error_dialog.dart';
import 'package:ai_cook_project/widgets/loading_spinner.dart';
import 'package:flutter/material.dart';

Future<void> handleRegister({
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required String email,
  required String password,
  required bool acceptedTerms,
}) async {
  if (!acceptedTerms) {
    showErrorDialog(
      context,
      message: 'Please accept the terms and conditions to continue',
    );
    return;
  }
  await AuthService.register(
    context: context,
    email: email,
    password: password,
    formKey: formKey,
    showLoading:
        () => showLoadingDialog(context, message: 'Creating account...'),
    hideLoading: () {
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    },
    onSuccess: () async {
      debugPrint('Registration successful, fetching user info');
      if (!context.mounted) return;

      // Cierra el loading si está abierto
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      // Espera un microtick para evitar conflictos de navegación
      Future.microtask(() {
        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const UserInfoScreen()),
          );
        }
      });
    },
    onError: (msg, {exception}) async {
      if (exception != null && exception.code == 'email-already-in-use') {
        if (context.mounted) {
          debugPrint('Mostrando diálogo de email ya en uso');
          await handleExistingEmail(context: context, email: email);
        }
      } else {
        if (context.mounted) {
          showErrorDialog(context, message: msg);
        }
      }
    },
  );
}
