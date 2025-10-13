// widgets/auth_button.dart
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const AuthButton({required this.label, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.xxl),
            ),
          ),
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: AppFontWeights.medium,
            fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.md),
            color: Colors.white,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }
}
