import 'package:ai_cook_project/dialogs/ingredients/global_ing/widgets/scroller.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/providers/ingredients_provider.dart';
import 'package:ai_cook_project/providers/resource_provider.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/widgets/utils/safe_constrained_dialog.dart';
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
  String selectedCategory = 'All';
  String searchText = '';

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return PopScope(
        canPop: false,
        child: StatefulBuilder(
          builder: (context, setState) {
            final filteredByCategory =
                selectedCategory == 'All'
                    ? globalIngredients
                    : globalIngredients
                        .where(
                          (ing) =>
                              ing.category!.name.trim().toLowerCase() ==
                              selectedCategory.trim().toLowerCase(),
                        )
                        .toList();

            final filteredIngredients =
                searchText.isEmpty
                    ? filteredByCategory
                    : filteredByCategory
                        .where(
                          (ing) => ing.name.toLowerCase().contains(
                            searchText.toLowerCase(),
                          ),
                        )
                        .toList();

            // Si no hay ingredientes globales, muestra un loading spinner
            if (globalIngredients.isEmpty) {
              return Dialog(
                backgroundColor: CupertinoColors.systemGrey6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SizedBox(
                  height: 200,
                  child: Center(child: CupertinoActivityIndicator(radius: 20)),
                ),
              );
            }

            return SafeConstrainedDialog(
              backgroundColor: CupertinoColors.systemGrey6,
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Start Your Cupboard',
                        style: TextStyle(
                          color: AppColors.button,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Casta',
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 28),
                      // … tus chips de categorías …
                      const SizedBox(height: 20),
                      CupertinoSearchTextField(
                        placeholder: 'Search ingredients',
                        onChanged:
                            (value) => setState(() => searchText = value),
                      ),
                      const SizedBox(height: 28),

                      // Lista con altura acotada
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 380),
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

                      const SizedBox(height: 28),
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
                                    await ingredientsProvider.addUserIngredient(
                                      ing,
                                    );
                                  }
                                  Navigator.pop(context);
                                }
                                : null,
                        child: Text(
                          'Add Selected',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.white,
                            fontSize: ResponsiveUtils.fontSize(
                              context,
                              ResponsiveFontSize.md,
                            ),
                            fontWeight: AppFontWeights.semiBold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
