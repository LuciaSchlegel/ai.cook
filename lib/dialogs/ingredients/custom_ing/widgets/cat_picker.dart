import 'package:flutter/cupertino.dart';
import 'package:ai_cook_project/models/category_model.dart';
import 'package:ai_cook_project/widgets/pickers/generic_picker_modal.dart';

class CategoryPickerModal extends StatelessWidget {
  final List<Category> categories;
  final Category selectedCategory;
  final ValueChanged<Category> onSelected;

  const CategoryPickerModal({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GenericPickerModal<Category>(
      items: categories,
      selectedItem: selectedCategory,
      getDisplayText: (category) => category.name,
      areEqual: (a, b) => a.id == b.id,
      onSelected: onSelected,
      title: 'Select Category',
    );
  }
}

/// Convenience function to show category picker
Future<Category?> showCategoryPicker({
  required BuildContext context,
  required List<Category> categories,
  required Category selectedCategory,
}) {
  return showGenericPicker<Category>(
    context: context,
    items: categories,
    selectedItem: selectedCategory,
    getDisplayText: (category) => category.name,
    areEqual: (a, b) => a.id == b.id,
    title: 'Select Category',
  );
}
