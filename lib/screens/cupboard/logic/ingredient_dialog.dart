import 'package:ai_cook_project/models/custom_ing_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ai_cook_project/models/unit.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/providers/ingredients_provider.dart';
import 'package:ai_cook_project/providers/resource_provider.dart';
import 'package:ai_cook_project/dialogs/ingredients/ingredient_dialogs.dart';

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

  // 🔁 Si estás editando uno existente, buscá la versión más actual
  if (userIng != null) {
    final updated = ingredientsProvider.userIngredients.firstWhere(
      (i) => i.id == userIng!.id,
      orElse: () => userIng!,
    );

    // ✅ Buscar el customIngredient completo para asegurar que tenga tags
    if (updated.customIngredient != null) {
      final fullCustom = ingredientsProvider.userIngredients
          .map((u) => u.customIngredient)
          .whereType<CustomIngredient>()
          .firstWhere(
            (c) => c.id == updated.customIngredient!.id,
            orElse: () => updated.customIngredient!,
          );

      userIng = updated.copyWith(
        customIngredient: updated.customIngredient!.copyWith(
          tags: fullCustom.tags,
        ),
      );
    } else {
      userIng = updated;
    }
  }

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
    onDelete: () {
      final ingredientName =
          userIng?.ingredient?.name ?? userIng?.customIngredient?.name;
      final ingToDelete = userIng;

      if (ingToDelete != null && ingredientName != null) {
        IngredientDialogs.showDeleteDialog(
          context: context,
          ingredientName: ingredientName,
          onDelete: () async {
            await ingredientsProvider.removeUserIngredient(ingToDelete);
            onChanged();
            if (context.mounted) {
              Navigator.pop(context); // Cierra el formulario de edición
            }
          },
        );
      }
    },
    onSave: (updatedUserIng) async {
      if (userIng == null) {
        await ingredientsProvider.addUserIngredient(updatedUserIng);
      } else {
        // ⚠️ Guardamos la versión retornada con las tags del formulario
        final saved = await ingredientsProvider.updateUserIngredient(
          updatedUserIng,
        );
        userIng = saved;
      }
      onChanged();
    },
  );
}
