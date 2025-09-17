import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SaveButtonsRow extends StatelessWidget {
  final bool isEditing;
  final VoidCallback? onDelete;
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final bool isFormValid;

  const SaveButtonsRow({
    super.key,
    required this.isEditing,
    this.onDelete,
    required this.onCancel,
    required this.onSave,
    required this.isFormValid,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Botón de eliminar en el lado izquierdo
        if (isEditing)
          CupertinoButton(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.spacing(
                context,
                ResponsiveSpacing.sm,
              ),
              vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
            ),
            onPressed: onDelete,
            child: Container(
              padding: EdgeInsets.all(
                ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
              ),
              decoration: BoxDecoration(
                color: CupertinoColors.systemRed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                CupertinoIcons.delete,
                color: CupertinoColors.systemRed,
                size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.sm),
              ),
            ),
          )
        else
          const SizedBox.shrink(),

        // Botones de Cancel y Save en el lado derecho
        Row(
          children: [
            TextButton(
              onPressed: onCancel,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.button,
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
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: ResponsiveUtils.fontSize(
                    context,
                    ResponsiveFontSize.md,
                  ),
                  fontWeight: AppFontWeights.medium,
                  fontFamily: 'Inter',
                  letterSpacing: 0.2,
                ),
              ),
            ),
            SizedBox(
              width: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: isFormValid ? onSave : null,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.lg,
                  ),
                  vertical: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.sm,
                  ),
                ),
                decoration: BoxDecoration(
                  color:
                      isFormValid
                          ? AppColors.mutedGreen
                          : AppColors.mutedGreen.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(
                    ResponsiveUtils.borderRadius(
                      context,
                      ResponsiveBorderRadius.xl,
                    ),
                  ),
                ),
                child: Text(
                  isEditing ? 'Save' : 'Add',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.md,
                    ),
                    fontWeight: AppFontWeights.semiBold,
                    fontFamily: 'Inter',
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
