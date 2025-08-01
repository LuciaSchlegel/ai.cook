import 'package:ai_cook_project/dialogs/ingredients/custom_ing/custom_ing_form_dialog.dart';
import 'package:ai_cook_project/models/category_model.dart';
import 'package:ai_cook_project/models/custom_ing_model.dart';
import 'package:ai_cook_project/models/ingredient_model.dart';
import 'package:ai_cook_project/models/unit.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/providers/ingredients_provider.dart';
import 'package:ai_cook_project/dialogs/ingredients/form/ingredient_form_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget buildIngredientDialog({
  required BuildContext context,
  required List<Category> categories,
  required IngredientsProvider ingredientsProvider,
  UserIng? userIng,
  required Future<void> Function(UserIng) onSave,
  VoidCallback? onDelete,
}) {
  final unitFallback = Unit(
    id: -1,
    name: 'Select unit',
    abbreviation: '',
    type: '',
  );

  if (userIng?.customIngredient != null || userIng == null) {
    return CustomIngFormDialog(
      ingredient: userIng?.ingredient,
      customIngredient: userIng?.customIngredient,
      quantity: userIng?.quantity ?? 0,
      unit: userIng?.unit ?? unitFallback,
      categories: categories,
      onDelete: userIng != null ? onDelete : null,
      onSave: (name, category, tags, quantity, unit) async {
        try {
          if (userIng == null) {
            final customIng = CustomIngredient(
              id: -1,
              name: name,
              category: category,
              tags: tags,
              uid: FirebaseAuth.instance.currentUser?.uid ?? '',
            );
            await ingredientsProvider.addCustomIngredient(
              customIng,
              quantity: quantity,
              unit: unit,
            );
            if (context.mounted) Navigator.pop(context);
          } else {
            final updatedCustomIng = CustomIngredient(
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
              customIngredient: updatedCustomIng,
              quantity: quantity,
              unit: unit,
            );
            await onSave(updatedUserIng);
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
    );
  } else {
    return IngredientFormDialog(
      ingredient: userIng.ingredient!,
      customIngredient: userIng.customIngredient,
      quantity: userIng.quantity,
      unit: userIng.unit ?? unitFallback,
      categories: categories,
      onDelete: onDelete,
      onSave: (name, category, tags, quantity, unit) async {
        try {
          final updatedIngredient = Ingredient(
            id: userIng.ingredient!.id,
            name: name,
            category: category,
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
          if (context.mounted) FocusScope.of(context).unfocus();
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
    );
  }
}
