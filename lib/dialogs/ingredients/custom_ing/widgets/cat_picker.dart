import 'package:ai_cook_project/models/category_model.dart';
import 'package:ai_cook_project/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';

/// Convenience function to show category picker
Future<Category?> showCategoryPicker({
  required BuildContext context,
  required List<Category> categories,
  required Category selectedCategory,
}) {
  return AppBottomSheet.showPicker<Category>(
    context: context,
    items: categories,
    selectedItem: selectedCategory,
    displayText: (category) => category.name,
    areEqual: (a, b) => a.id == b.id,
    title: 'Select Category',
  );
}
