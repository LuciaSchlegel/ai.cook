import 'package:ai_cook_project/dialogs/ingredients/global_ing/widgets/card_chips.dart';
import 'package:ai_cook_project/dialogs/ingredients/global_ing/widgets/scroller.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/providers/ingredients_provider.dart';
import 'package:ai_cook_project/providers/resource_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../theme.dart';

Future<void> showGlobalIngredientsDialog(BuildContext context) async {
  final ingredientsProvider = Provider.of<IngredientsProvider>(
    context,
    listen: false,
  );
  final resourceProvider = Provider.of<ResourceProvider>(
    context,
    listen: false,
  );
  if (resourceProvider.units.isEmpty) {
    await resourceProvider.initializeResources();
  }
  final globalIngredients = ingredientsProvider.ingredients;
  final selectedIngredients = <UserIng>[];
  final categories = resourceProvider.categories;
  String selectedCategory = 'All';

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return PopScope(
        canPop: false,
        child: StatefulBuilder(
          builder: (context, setState) {
            final filteredIngredients =
                selectedCategory == 'All'
                    ? globalIngredients
                    : globalIngredients
                        .where(
                          (ing) =>
                              ing.category!.name.trim().toLowerCase() ==
                              selectedCategory.trim().toLowerCase(),
                        )
                        .toList();

            return Dialog(
              backgroundColor: CupertinoColors.systemGrey6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Start Your Cupboard',
                      style: TextStyle(
                        color: AppColors.button,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Casta',
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: CardChips(
                        selectedIngredients: selectedIngredients,
                        categories: categories,
                        selectedCategory: selectedCategory,
                        onCategorySelected: (category) {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    Flexible(
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.6,
                        ),
                        child: IngListScroller(
                          filteredIngredients: filteredIngredients,
                          selectedIngredients: selectedIngredients,
                          onAdd:
                              (ing) =>
                                  setState(() => selectedIngredients.add(ing)),
                          onRemove:
                              (ing) => setState(
                                () => selectedIngredients.remove(ing),
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      color:
                          selectedIngredients.isNotEmpty
                              ? AppColors.button
                              : AppColors.button.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(18),
                      onPressed:
                          selectedIngredients.isNotEmpty
                              ? () async {
                                for (var ing in selectedIngredients) {
                                  print(selectedIngredients);
                                  await ingredientsProvider.addUserIngredient(
                                    ing,
                                  );
                                  print(ing.toJson());
                                }
                                Navigator.pop(context);
                              }
                              : null,
                      child: const Text(
                        'Add Selected',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
