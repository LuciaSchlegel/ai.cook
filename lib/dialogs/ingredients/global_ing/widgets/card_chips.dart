import 'package:ai_cook_project/models/category_model.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:flutter/material.dart';

class CardChips extends StatelessWidget {
  final List<UserIng> selectedIngredients;
  final List<Category> categories;
  final String selectedCategory;
  final void Function(String) onCategorySelected;

  const CardChips({
    super.key,
    required this.selectedIngredients,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length + 1,
      itemBuilder: (context, index) {
        final isAll = index == 0;
        final category = isAll ? null : categories[index - 1];
        final categoryName = isAll ? 'All' : category!.name;
        final isSelected = categoryName == selectedCategory;

        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () => onCategorySelected(categoryName),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? AppColors.mutedGreen
                        : AppColors.mutedGreen.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  categoryName,
                  style: TextStyle(
                    color:
                        isSelected
                            ? AppColors.white
                            : AppColors.button.withValues(alpha: 0.9),
                    fontSize: 14,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
