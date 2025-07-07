import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ai_cook_project/theme.dart';

void showErrorDialog(
  BuildContext context, {
  required String message,
  VoidCallback? onResetPassword,
}) {
  if (!context.mounted) return;

  showDialog(
    context: context,
    barrierDismissible: true,
    builder:
        (BuildContext dialogContext) => CupertinoAlertDialog(
          title: const Icon(
            CupertinoIcons.exclamationmark_triangle_fill,
            color: AppColors.orange,
            size: 40,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            if (onResetPassword != null)
              CupertinoDialogAction(
                onPressed: () {
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop();
                  }
                  Future.delayed(
                    const Duration(milliseconds: 100),
                    onResetPassword,
                  );
                },
                child: const Text(
                  "Reset password",
                  style: TextStyle(
                    color: AppColors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            CupertinoDialogAction(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                "OK",
                style: TextStyle(
                  color: AppColors.button,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
  );
}
