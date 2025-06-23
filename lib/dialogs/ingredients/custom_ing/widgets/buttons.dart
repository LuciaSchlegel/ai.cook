import 'package:ai_cook_project/theme.dart';
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
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isEditing) ...[
          TextButton(
            onPressed: onDelete,
            style: TextButton.styleFrom(
              foregroundColor: CupertinoColors.systemRed,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 16),
        ],
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
          onPressed: isFormValid ? onSave : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color:
                  isFormValid
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
    );
  }
}
