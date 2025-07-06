import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Botón de eliminar en el lado izquierdo
        if (onDelete != null)
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            onPressed: onDelete,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: CupertinoColors.systemRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                CupertinoIcons.delete,
                color: CupertinoColors.systemRed,
                size: 20,
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(width: 16),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: isValid ? onSave : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color:
                      isValid
                          ? AppColors.mutedGreen
                          : AppColors.mutedGreen.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  isEditing ? 'Save' : 'Add',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
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
  }
}
