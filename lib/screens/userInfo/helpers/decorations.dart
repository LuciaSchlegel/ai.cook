import 'package:ai_cook_project/theme.dart';
import 'package:flutter/material.dart';

Widget buildLabel(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.black,
      letterSpacing: 0.3,
    ),
  );
}

InputDecoration inputDecoration(String hint) {
  return InputDecoration(
    filled: true,
    fillColor: Colors.grey.shade50,
    hintText: hint,
    hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 16),
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: AppColors.orange, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: Colors.red.shade400, width: 2),
    ),
  );
}
