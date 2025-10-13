import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.md),
            color: AppColors.black,
            fontFamily: 'Inter',
          ),
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
        ),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          style: TextStyle(
            fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.md),
            color: AppColors.black,
            fontFamily: 'Inter',
          ),
          decoration: InputDecoration(
            errorStyle: TextStyle(
              fontSize: ResponsiveUtils.fontSize(
                context,
                ResponsiveFontSize.sm,
              ),
              color: Colors.red,
              fontFamily: 'Inter',
            ),
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.borderRadius(
                  context,
                  ResponsiveBorderRadius.lg,
                ),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.borderRadius(
                  context,
                  ResponsiveBorderRadius.lg,
                ),
              ),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.borderRadius(
                  context,
                  ResponsiveBorderRadius.lg,
                ),
              ),
              borderSide: const BorderSide(color: AppColors.orange, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
