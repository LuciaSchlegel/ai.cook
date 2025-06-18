import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ai_cook_project/models/unit.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/providers/ingredients_provider.dart';
import 'package:ai_cook_project/providers/resource_provider.dart';
import 'package:ai_cook_project/dialogs/ingredient_dialogs.dart';

Future<void> showIngredientDialog({
  required BuildContext context,
  required UserIng? userIng,
  required void Function() onChanged,
}) async {
  final resourceProvider = Provider.of<ResourceProvider>(
    context,
    listen: false,
  );
  final ingredientsProvider = Provider.of<IngredientsProvider>(
    context,
    listen: false,
  );

  final dialogs = IngredientDialogs();
  await dialogs.showIngredientDialog(
    context: context,
    categories: resourceProvider.categories,
    ingredients:
        ingredientsProvider.ingredients.map((ing) {
          return UserIng(
            id: ing.id,
            ingredient: ing,
            quantity: 0,
            unit: Unit(id: -1, name: '', abbreviation: '', type: ''),
            uid: FirebaseAuth.instance.currentUser?.uid ?? '',
          );
        }).toList(),
    userIngredients: {
      for (var ing in ingredientsProvider.userIngredients) ing.id: ing,
    },
    userIng: userIng,
    onDelete:
        userIng != null
            ? () => IngredientDialogs.showDeleteDialog(
              context: context,
              ingredient: userIng.ingredient!,
              onDelete: () async {
                await ingredientsProvider.removeUserIngredient(userIng);
                onChanged();
              },
            )
            : null,
    onSave: (updatedUserIng) async {
      if (userIng == null) {
        await ingredientsProvider.addUserIngredient(updatedUserIng);
      } else {
        await ingredientsProvider.updateUserIngredient(updatedUserIng);
      }
      onChanged();
    },
  );
}
