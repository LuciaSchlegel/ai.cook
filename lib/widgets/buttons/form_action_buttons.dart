import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';

class FormActionButtons extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback? onDelete;
  final VoidCallback onSave;
  final bool isValid;
  final bool isEditing;

  const FormActionButtons({
    super.key,
    required this.onCancel,
    required this.onSave,
    required this.isValid,
    this.onDelete,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Botón de eliminar en el lado izquierdo
            if (onDelete != null)
              CupertinoButton(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.sm,
                  ),
                  vertical: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.xs,
                  ),
                ),
                onPressed: onDelete,
                child: Container(
                  padding: EdgeInsets.all(
                    ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
                  ),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.borderRadius(
                        context,
                        ResponsiveBorderRadius.xs,
                      ),
                    ),
                  ),
                  child: Icon(
                    CupertinoIcons.delete,
                    color: CupertinoColors.systemRed,
                    size: ResponsiveUtils.iconSize(
                      context,
                      ResponsiveIconSize.sm,
                    ),
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
                        ResponsiveSpacing.sm,
                      ),
                      vertical: ResponsiveUtils.spacing(
                        context,
                        ResponsiveSpacing.xs,
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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  width: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: isValid ? onSave : null,
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
                          isValid
                              ? AppColors.mutedGreen
                              : AppColors.mutedGreen.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.borderRadius(
                          context,
                          ResponsiveBorderRadius.lg,
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
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
