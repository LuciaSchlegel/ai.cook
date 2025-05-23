import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';

class LoadingDialog extends StatelessWidget {
  final String message;

  const LoadingDialog({super.key, this.message = "Loading..."});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.orange),
            const SizedBox(width: 16),
            Flexible(
              // 👈 Este bloquea el overflow
              child: Text(
                message,
                style: const TextStyle(fontSize: 16, color: AppColors.black),
                overflow: TextOverflow.ellipsis, // opcional
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showLoadingDialog(BuildContext context, {String message = "Loading..."}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: const Color.fromRGBO(0, 0, 0, 0.4),
    builder: (_) => LoadingDialog(message: message),
  );
}
