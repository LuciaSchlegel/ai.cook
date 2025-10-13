import 'package:ai_cook_project/theme.dart';
import 'package:flutter/material.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
// Solo dejamos la validación, eliminando showErrorDialog para centralizar el diálogo de error en widgets/error_dialog.dart

void showValidationErrorDialog(BuildContext context, List<String> errors) {
  showDialog(
    context: context,
    useRootNavigator: true,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.md),
          ),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.amber[700],
              size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.lg),
            ),
            const SizedBox(width: 8),
            Text(
              'Missing Information',
              style: TextStyle(
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  ResponsiveFontSize.lg,
                ),
                fontWeight: AppFontWeights.semiBold,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please complete the following:',
              style: TextStyle(
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  ResponsiveFontSize.md,
                ),
                fontWeight: AppFontWeights.medium,
                color: Colors.black87,
              ),
            ),
            SizedBox(
              height: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            ),
            ...errors.map((error) => buildValidationItem(context, error)),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.borderRadius(
                    context,
                    ResponsiveBorderRadius.sm,
                  ),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.spacing(
                  context,
                  ResponsiveSpacing.md,
                ),
                vertical: ResponsiveUtils.spacing(
                  context,
                  ResponsiveSpacing.sm,
                ),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: TextStyle(
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  ResponsiveFontSize.md,
                ),
                fontWeight: AppFontWeights.medium,
                color: AppColors.orange,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      );
    },
  );
}

Widget buildValidationItem(BuildContext context, String text) {
  return Padding(
    padding: EdgeInsets.only(
      left: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
      bottom: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
    ),
    child: Row(
      children: [
        Icon(
          Icons.error_outline,
          size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.sm),
          color: Colors.red[700],
        ),
        SizedBox(width: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm)),
        Text(
          text,
          style: TextStyle(
            fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.sm),
            color: Colors.black87,
            fontFamily: 'Inter',
          ),
        ),
      ],
    ),
  );
}
