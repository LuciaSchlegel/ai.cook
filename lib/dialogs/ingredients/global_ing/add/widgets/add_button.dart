// 📁 add_custom_ingredient_button.dart
import 'package:ai_cook_project/dialogs/ingredients/ingredient_dialogs.dart';
import 'package:ai_cook_project/models/custom_ing_model.dart';
import 'package:ai_cook_project/models/unit.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/providers/ingredients_provider.dart';
import 'package:ai_cook_project/providers/resource_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class AddCustomIngredientButton extends StatelessWidget {
  const AddCustomIngredientButton({super.key});

  @override
  Widget build(BuildContext context) {
    final ingredientsProvider = Provider.of<IngredientsProvider>(
      context,
      listen: false,
    );
    final resourceProvider = Provider.of<ResourceProvider>(
      context,
      listen: false,
    );
    final globalIngredients = ingredientsProvider.ingredients;

    return TextButton(
      onPressed: () {
        showResponsiveIngredientDialog(
          context: context,
          categories: resourceProvider.categories,
          ingredients:
              globalIngredients
                  .map(
                    (ing) => UserIng(
                      id: ing.id,
                      ingredient: ing,
                      quantity: 0,
                      unit: Unit(id: -1, name: '', abbreviation: '', type: ''),
                      uid: FirebaseAuth.instance.currentUser?.uid ?? '',
                    ),
                  )
                  .toList(),
          userIngredients: {},
          userIng: null,
          onSave: (userIng) async {
            final customIng = CustomIngredient(
              id: -1,
              name: userIng.customIngredient?.name ?? '',
              category: userIng.customIngredient?.category,
              isVegan: userIng.customIngredient?.isVegan ?? false,
              isVegetarian: userIng.customIngredient?.isVegetarian ?? false,
              isGlutenFree: userIng.customIngredient?.isGlutenFree ?? false,
              isLactoseFree: userIng.customIngredient?.isLactoseFree ?? false,

              uid: FirebaseAuth.instance.currentUser?.uid ?? '',
            );

            try {
              await ingredientsProvider.addCustomIngredient(
                customIng,
                quantity: userIng.quantity,
                unit: userIng.unit,
              );
              if (context.mounted) Navigator.pop(context);
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
          onDelete: () {},
        );
      },
      child: const Text(
        'Add custom ingredient',
        style: TextStyle(
          color: CupertinoColors.systemBlue,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
