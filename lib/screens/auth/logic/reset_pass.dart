import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_cook_project/widgets/error_dialog.dart';
import 'package:ai_cook_project/widgets/loading_spinner.dart';
import 'package:ai_cook_project/providers/auth_provider.dart';

Future<void> handleExistingEmail({
  required BuildContext context,
  required String email,
}) async {
  showErrorDialog(
    context,
    message: 'Email already in use',
    onResetPassword: () async {
      final auth = Provider.of<FBAuthProvider>(context, listen: false);
      showLoadingDialog(context, message: 'Sending password reset email...');

      try {
        await auth.resetPassword(email);
        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password reset email sent')),
          );
        }
      } catch (_) {
        if (context.mounted) Navigator.pop(context);
        showErrorDialog(context, message: 'Failed to send reset email.');
      }
    },
  );
}
