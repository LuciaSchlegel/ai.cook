import 'package:ai_cook_project/screens/auth/logic/reset_pass.dart';
import 'package:ai_cook_project/screens/auth/services/auth_services.dart';
import 'package:ai_cook_project/screens/userInfo/user_info_screen.dart';
import 'package:ai_cook_project/widgets/error_dialog.dart';
import 'package:ai_cook_project/widgets/loading_spinner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_cook_project/providers/user_provider.dart';

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
    hideLoading: () async {
      if (context.mounted) {
        Navigator.pop(context); // hide loading
        await Provider.of<UserProvider>(context, listen: false).getUser();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const UserInfoScreen()),
        );
      }
    },
    onError: (String msg, {FirebaseAuthException? exception}) async {
      if (exception != null && exception.code == 'email-already-in-use') {
        await handleExistingEmail(context: context, email: email);
        return;
      }

      showErrorDialog(context, message: msg);
    },
  );
}
