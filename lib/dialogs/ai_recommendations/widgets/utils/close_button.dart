import 'package:ai_cook_project/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CloseButtonExt extends StatelessWidget {
  final VoidCallback handleClose;

  const CloseButtonExt({super.key, required this.handleClose});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.mutedGreen.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: IconButton(
        onPressed: handleClose,
        icon: Icon(
          CupertinoIcons.xmark,
          color: AppColors.button.withValues(alpha: 0.6),
          size: 16,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
