import 'package:ai_cook_project/models/category_model.dart';
import 'package:ai_cook_project/models/custom_ing_model.dart';
import 'package:ai_cook_project/models/ingredient_model.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/models/unit.dart';
import 'package:ai_cook_project/widgets/ingredient_form_dialog.dart';
import 'package:ai_cook_project/widgets/custom_ing_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:ai_cook_project/providers/ingredients_provider.dart';

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
    debugPrint('Showing ingredient dialog. userIng: ${userIng?.toJson()}');

    final ingredientsProvider = Provider.of<IngredientsProvider>(
      context,
      listen: false,
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: false,
      builder:
          (context) => PopScope(
            canPop: true,
            child:
                userIng?.customIngredient != null || userIng == null
                    ? CustomIngFormDialog(
                      ingredient: userIng?.ingredient,
                      customIngredient: userIng?.customIngredient,
                      quantity: userIng?.quantity ?? 0,
                      unit:
                          userIng?.unit ??
                          Unit(
                            id: -1,
                            name: 'Select unit',
                            abbreviation: '',
                            type: '',
                          ),
                      categories: categories,
                      onDelete: userIng != null ? onDelete : null,
                      onSave: (name, category, tags, quantity, unit) async {
                        try {
                          debugPrint(
                            'Saving custom ingredient. Name: $name, Category: ${category.name}, Tags: ${tags.length}, Quantity: $quantity, Unit: ${unit.toJson()}',
                          );

                          if (userIng == null) {
                            // Add new custom ingredient
                            final customIng = CustomIngredient(
                              id: -1,
                              name: name,
                              category: category,
                              tags: tags,
                              uid: FirebaseAuth.instance.currentUser?.uid ?? '',
                            );

                            debugPrint(
                              'Created CustomIngredient: ${customIng.toJson()}',
                            );

                            final newUserIng = UserIng(
                              id: -1,
                              uid: FirebaseAuth.instance.currentUser?.uid ?? '',
                              ingredient: null,
                              customIngredient: customIng,
                              quantity: quantity,
                              unit: unit,
                            );

                            debugPrint(
                              'Created UserIng: ${newUserIng.toJson()}',
                            );

                            await ingredientsProvider.addCustomIngredient(
                              customIng,
                              quantity: quantity,
                              unit: unit,
                            );
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          } else {
                            // Update existing custom ingredient
                            final updatedCustomIngredient = CustomIngredient(
                              id: userIng.customIngredient?.id ?? -1,
                              name: name,
                              category: category,
                              tags: tags,
                              uid: FirebaseAuth.instance.currentUser?.uid ?? '',
                            );

                            final updatedUserIng = UserIng(
                              id: userIng.id,
                              uid: FirebaseAuth.instance.currentUser?.uid ?? '',
                              ingredient: null,
                              customIngredient: updatedCustomIngredient,
                              quantity: quantity,
                              unit: unit,
                            );

                            await onSave(updatedUserIng);
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          }
                        } catch (e, stackTrace) {
                          debugPrint('Error in onSave: $e');
                          debugPrint('Stack trace: $stackTrace');
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
                    )
                    : IngredientFormDialog(
                      ingredient: userIng?.ingredient,
                      customIngredient: userIng?.customIngredient,
                      quantity: userIng?.quantity ?? 0,
                      unit:
                          userIng.unit ??
                          Unit(
                            id: -1,
                            name: 'Select unit',
                            abbreviation: '',
                            type: '',
                          ),
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
                              customIngredient: null,
                              quantity: quantity,
                              unit: unit,
                            );

                            await onSave(newUserIng);
                          } else {
                            // Update existing ingredient
                            final updatedIngredient = Ingredient(
                              id: userIng.ingredient!.id,
                              name: name,
                              category: category,
                              tags: tags,
                              isVegan: userIng.ingredient!.isVegan,
                              isVegetarian: userIng.ingredient!.isVegetarian,
                              isGlutenFree: userIng.ingredient!.isGlutenFree,
                              isLactoseFree: userIng.ingredient!.isLactoseFree,
                            );

                            final updatedUserIng = UserIng(
                              id: userIng.id,
                              uid: FirebaseAuth.instance.currentUser!.uid,
                              ingredient: updatedIngredient,
                              customIngredient: null,
                              quantity: quantity,
                              unit: unit,
                            );

                            await onSave(updatedUserIng);
                          }

                          FocusScope.of(context).unfocus();
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
