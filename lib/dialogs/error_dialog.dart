import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
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
          title: Icon(
            CupertinoIcons.exclamationmark_triangle_fill,
            color: AppColors.orange,
            size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.xxl),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.sm),
              ResponsiveText(
                message,
                fontSize: ResponsiveFontSize.md,
                fontWeight: FontWeight.w400,
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
                child: const ResponsiveText(
                  "Reset password",
                  fontSize: ResponsiveFontSize.md,
                  fontWeight: FontWeight.w600,
                  color: AppColors.orange,
                ),
              ),
            CupertinoDialogAction(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const ResponsiveText(
                "OK",
                fontSize: ResponsiveFontSize.sm,
                fontWeight: FontWeight.w500,
                color: AppColors.button,
              ),
            ),
          ],
        ),
  );
}
