import 'package:ai_cook_project/models/category_model.dart';
import 'package:ai_cook_project/models/custom_ing_model.dart';
import 'package:ai_cook_project/models/ingredient_model.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/models/unit.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/widgets/ingredient_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class IngredientDialogs {
  static void showIngredientDialog({
    required BuildContext context,
    required List<Category> categories,
    required List<UserIng> ingredients,
    required Map<int, UserIng> userIngredients,
    required Function(UserIng) onSave,
    Function()? onDelete,
    UserIng? userIng,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: false,
      builder:
          (context) => PopScope(
            canPop: true,
            child: IngredientFormDialog(
              ingredient: userIng?.ingredient,
              customIngredient: userIng?.customIngredient,
              quantity: userIng?.quantity ?? 0,
              unit:
                  userIng?.unit ??
                  Unit(id: -1, name: 'Select unit', abbreviation: '', type: ''),
              categories: categories,
              onDelete: userIng != null ? onDelete : null,
              onSave: (name, category, tags, quantity, unit) async {
                try {
                  if (userIng == null) {
                    // Add new ingredient
                    final newId = ingredients.length + 1;
                    final newIngredient = Ingredient(
                      id: newId,
                      name: name,
                      category: category,
                      tags: tags,
                      isVegan: false,
                      isVegetarian: false,
                      isGlutenFree: false,
                      isLactoseFree: false,
                    );

                    final newUserIng = UserIng(
                      id: newId,
                      uid: FirebaseAuth.instance.currentUser!.uid,
                      ingredient: newIngredient,
                      quantity: quantity,
                      unit: unit,
                    );

                    await onSave(newUserIng);
                  } else {
                    // Update existing ingredient
                    final updatedIngredient = Ingredient(
                      id: userIng.ingredient.id,
                      name: name,
                      category: category,
                      tags: tags,
                      isVegan: userIng.ingredient.isVegan,
                      isVegetarian: userIng.ingredient.isVegetarian,
                      isGlutenFree: userIng.ingredient.isGlutenFree,
                      isLactoseFree: userIng.ingredient.isLactoseFree,
                    );

                    final updatedCustomIngredient =
                        userIng.customIngredient != null
                            ? CustomIngredient(
                              name: name,
                              category: category,
                              tags: tags,
                              uid: FirebaseAuth.instance.currentUser!.uid,
                            )
                            : null;

                    final updatedUserIng = UserIng(
                      id: userIng.id,
                      uid: FirebaseAuth.instance.currentUser!.uid,
                      ingredient: updatedIngredient,
                      customIngredient: updatedCustomIngredient,
                      quantity: quantity,
                      unit: unit,
                    );

                    await onSave(updatedUserIng);
                  }

                  // Dismiss keyboard before popping
                  FocusScope.of(context).unfocus();

                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
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
