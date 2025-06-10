import 'package:ai_cook_project/models/category_model.dart';
import 'package:ai_cook_project/models/custom_ing_model.dart';
import 'package:ai_cook_project/models/ingredient_model.dart';
import 'package:ai_cook_project/models/tag_model.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/widgets/ingredient_form_dialog.dart';
import 'package:flutter/material.dart';

class IngredientDialogs {
  static void showIngredientDialog({
    required BuildContext context,
    required List<String> categories,
    required List<UserIng> ingredients,
    required Map<int, UserIng> userIngredients,
    required Function(UserIng) onSave,
    Function()? onDelete,
    UserIng? userIng,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      isScrollControlled: true,
      builder:
          (context) => IngredientFormDialog(
            ingredient: userIng?.ingredient,
            customIngredient: userIng?.customIngredient,
            quantity: userIng?.quantity ?? 0,
            unit: userIng?.unit,
            categories: categories,
            onDelete: userIng != null ? onDelete : null,
            onSave: (name, category, tags, quantity, unit) {
              if (userIng == null) {
                // Add new ingredient
                final newId = ingredients.length + 1;
                final newIngredient = Ingredient(
                  id: newId,
                  name: name,
                  category: Category(id: 1, name: category),
                  tags: tags.map((tag) => Tag(id: 1, name: tag)).toList(),
                );

                final newUserIng = UserIng(
                  id: newId,
                  uid: '1', // This would come from auth
                  ingredient: newIngredient,
                  quantity: quantity,
                  unit: unit,
                );

                onSave(newUserIng);
              } else {
                // Update existing ingredient
                final updatedIngredient =
                    userIng.ingredient != null
                        ? Ingredient(
                          id: userIng.ingredient!.id,
                          name: name,
                          category: Category(id: 1, name: category),
                          tags:
                              tags.map((tag) => Tag(id: 1, name: tag)).toList(),
                        )
                        : null;

                final updatedCustomIngredient =
                    userIng.customIngredient != null
                        ? CustomIngredient(
                          id: userIng.customIngredient!.id,
                          name: name,
                          category: Category(id: 1, name: category),
                          tags:
                              tags.map((tag) => Tag(id: 1, name: tag)).toList(),
                        )
                        : null;

                final updatedUserIng = UserIng(
                  id: userIng.id,
                  uid: userIng.uid,
                  ingredient: updatedIngredient,
                  customIngredient: updatedCustomIngredient,
                  quantity: quantity,
                  unit: unit,
                );

                onSave(updatedUserIng);
              }
              Navigator.pop(context);
            },
          ),
    );
  }

  static void showDeleteDialog({
    required BuildContext context,
    required Ingredient ingredient,
    required Function() onDelete,
  }) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Ingredient'),
            content: Text(
              'Are you sure you want to delete ${ingredient.name}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  onDelete();
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}
