import 'package:ai_cook_project/dialogs/ingredients/custom_ing/custom_ing_form_dialog.dart';
import 'package:ai_cook_project/dialogs/ingredients/form/ingredient_form_dialog.dart';
import 'package:ai_cook_project/models/category_model.dart';
import 'package:ai_cook_project/models/custom_ing_model.dart';
import 'package:ai_cook_project/models/ingredient_model.dart';
import 'package:ai_cook_project/models/unit.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/providers/ingredients_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget buildIngredientDialog({
  required BuildContext context,
  required List<Category> categories,
  required IngredientsProvider ingredientsProvider,
  UserIng? userIng,
  required Future<void> Function(UserIng) onSave,
  VoidCallback? onDelete,
  bool isPopup = false, // New parameter for popup mode
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
      isPopup: isPopup, // Pass popup mode
      onSave: (
        name,
        category,
        isVegan,
        isVegetarian,
        isGlutenFree,
        isLactoseFree,
        quantity,
        unit,
      ) async {
        try {
          final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
          final customIng = CustomIngredient(
            id: userIng?.customIngredient?.id ?? -1,
            name: name,
            category: category,
            isVegan: isVegan,
            isVegetarian: isVegetarian,
            isGlutenFree: isGlutenFree,
            isLactoseFree: isLactoseFree,
            uid: uid,
          );
          final updatedUserIng = UserIng(
            id: userIng?.id ?? -1,
            uid: uid,
            ingredient: null,
            customIngredient: customIng,
            quantity: quantity,
            unit: unit,
          );

          if (userIng == null) {
            await ingredientsProvider.addCustomIngredient(
              customIng,
              quantity: quantity,
              unit: unit,
            );
            if (context.mounted) Navigator.pop(context);
          } else {
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
      isPopup: isPopup, // Pass popup mode
      onSave: (
        name,
        category,
        isVegan,
        isVegetarian,
        isGlutenFree,
        isLactoseFree,
        quantity,
        unit,
      ) async {
        try {
          final updatedIngredient = Ingredient(
            id: userIng.ingredient!.id,
            name: name,
            category: category,
            isVegan: isVegan,
            isVegetarian: isVegetarian,
            isGlutenFree: isGlutenFree,
            isLactoseFree: isLactoseFree,
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
