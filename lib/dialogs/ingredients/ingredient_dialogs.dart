import 'package:ai_cook_project/dialogs/ingredients/logic/build_ing_dialog.dart';
import 'package:ai_cook_project/models/category_model.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:ai_cook_project/providers/ingredients_provider.dart';
import 'package:ai_cook_project/theme.dart';

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
      useSafeArea: true,
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
    required String ingredientName,
    required Function() onDelete,
  }) {
    showDialog(
      context: context,
      builder:
          (context) => CupertinoAlertDialog(
            title: Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: const Text(
                'Delete Ingredient',
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Casta',
                  color: AppColors.button,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            content: Text(
              'Are you sure you want to delete $ingredientName?',
              style: const TextStyle(fontSize: 17, color: AppColors.button),
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppColors.button,
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  onDelete();
                  Navigator.pop(context);
                },
                isDestructiveAction: true,
                child: const Text(
                  'Delete',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                ),
              ),
            ],
          ),
    );
  }
}
