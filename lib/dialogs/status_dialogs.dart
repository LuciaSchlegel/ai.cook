import 'package:ai_cook_project/theme.dart';
import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red[700], size: 28),
            const SizedBox(width: 8),
            const Text(
              'Error',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'OK',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.orange,
              ),
            ),
          ),
        ],
      );
    },
  );
}

void showValidationErrorDialog(BuildContext context, List<String> errors) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.amber[700],
              size: 28,
            ),
            const SizedBox(width: 8),
            const Text(
              'Missing Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Please complete the following:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            ...errors.map((error) => buildValidationItem(error)),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'OK',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.orange,
              ),
            ),
          ),
        ],
      );
    },
  );
}

Widget buildValidationItem(String text) {
  return Padding(
    padding: const EdgeInsets.only(left: 8, bottom: 8),
    child: Row(
      children: [
        Icon(Icons.error_outline, size: 16, color: Colors.red[700]),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 14, color: Colors.black87)),
      ],
    ),
  );
}
