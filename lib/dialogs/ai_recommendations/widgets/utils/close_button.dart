import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CloseButtonExt extends StatelessWidget {
  final VoidCallback handleClose;

  const CloseButtonExt({super.key, required this.handleClose});

  @override
  Widget build(BuildContext context) {
    final buttonSize = ResponsiveUtils.iconSize(context, ResponsiveIconSize.xl);
    final iconSize = ResponsiveUtils.iconSize(context, ResponsiveIconSize.sm);

    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: AppColors.mutedGreen.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.md),
        ),
      ),
      child: IconButton(
        onPressed: handleClose,
        icon: Icon(
          CupertinoIcons.xmark,
          color: AppColors.button.withValues(alpha: 0.6),
          size: iconSize,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
