import 'package:ai_cook_project/dialogs/ingredients/logic/build_ing_dialog.dart';
import 'package:ai_cook_project/models/category_model.dart';
import 'package:ai_cook_project/models/ingredient_model.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_cook_project/providers/ingredients_provider.dart';

class IngredientDialogs {
  Future<void> showIngredientDialog({
    required BuildContext context,
    required List<Category> categories,
    required List<UserIng> ingredients,
    required Map<int, UserIng> userIngredients,
    required Future<void> Function(UserIng) onSave,
    Function()? onDelete,
    UserIng? userIng,
  }) {
    final ingredientsProvider = Provider.of<IngredientsProvider>(
      context,
      listen: false,
    );

    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: false,
      builder:
          (context) => PopScope(
            canPop: true,
            child: buildIngredientDialog(
              userIng: userIng,
              onDelete: onDelete,
              context: context,
              categories: categories,
              ingredientsProvider: ingredientsProvider,
              onSave: onSave,
            ),
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
