import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';

class ErrorDialog extends StatelessWidget {
  final String message;

  const ErrorDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.orange, size: 28),
            const SizedBox(width: 16),
            Flexible(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.black,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showErrorDialog(
  BuildContext context, {
  required String message,
  VoidCallback? onResetPassword, // <- botón opcional
}) {
  showDialog(
    context: context,
    builder:
        (_) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: AppColors.orange,
                size: 40,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(color: AppColors.black, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              if (onResetPassword != null) ...[
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context, rootNavigator: true).pop();
                    await Future.delayed(const Duration(milliseconds: 100));
                    onResetPassword();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text("Reset password"),
                ),
              ],
            ],
          ),
        ),
  );
}
