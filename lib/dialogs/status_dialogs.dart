import 'package:ai_cook_project/theme.dart';
import 'package:flutter/material.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/constants/dialog_constants.dart';

// Solo dejamos la validación, eliminando showErrorDialog para centralizar el diálogo de error en widgets/error_dialog.dart

void showValidationErrorDialog(BuildContext context, List<String> errors) {
  showDialog(
    context: context,
    useRootNavigator: true,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DialogConstants.radiusMD),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.amber[700],
              size: DialogConstants.iconSizeLG,
            ),
            const SizedBox(width: 8),
            const Text(
              'Missing Information',
              style: TextStyle(
                fontSize: DialogConstants.fontSizeLG,
                fontWeight: FontWeight.w600,
              ),
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
                fontSize: DialogConstants.fontSizeMD,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: DialogConstants.spacingSM),
            ...errors.map((error) => buildValidationItem(error)),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DialogConstants.radiusSM),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: DialogConstants.spacingMD,
                vertical: DialogConstants.spacingSM,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'OK',
              style: TextStyle(
                fontSize: DialogConstants.fontSizeMD,
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
    padding: const EdgeInsets.only(
      left: DialogConstants.spacingSM,
      bottom: DialogConstants.spacingSM,
    ),
    child: Row(
      children: [
        Icon(
          Icons.error_outline,
          size: DialogConstants.iconSizeSM,
          color: Colors.red[700],
        ),
        const SizedBox(width: DialogConstants.spacingSM),
        Text(
          text,
          style: const TextStyle(
            fontSize: DialogConstants.fontSizeSM,
            color: Colors.black87,
          ),
        ),
      ],
    ),
  );
}
