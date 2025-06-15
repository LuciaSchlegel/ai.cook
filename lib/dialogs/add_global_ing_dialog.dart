import 'package:ai_cook_project/dialogs/ingredient_dialogs.dart';
import 'package:ai_cook_project/models/custom_ing_model.dart';
import 'package:ai_cook_project/models/unit.dart';
import 'package:ai_cook_project/models/user_basic_model.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/providers/ingredients_provider.dart';
import 'package:ai_cook_project/providers/resource_provider.dart';
import 'package:ai_cook_project/widgets/navigation_text_link.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../theme.dart';

Future<void> addGlobalIngredientsDialog(BuildContext context) async {
  final ingredientsProvider = Provider.of<IngredientsProvider>(
    context,
    listen: false,
  );
  final resourceProvider = Provider.of<ResourceProvider>(
    context,
    listen: false,
  );

  final globalIngredients = ingredientsProvider.ingredients;
  final selectedIngredients = <UserIng>[];
  final categories = resourceProvider.categories;
  String selectedCategory = 'All';
  final searchController = TextEditingController();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  void _showCustomIngredientDialog() {
    IngredientDialogs.showIngredientDialog(
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
        // Create a CustomIngredient from the user input
        final customIng = CustomIngredient(
          name: userIng.ingredient.name,
          category: userIng.ingredient.category,
          tags: userIng.ingredient.tags,
          uid: uid,
        );

        try {
          await ingredientsProvider.addCustomIngredient(customIng);
          Navigator.pop(context);
        } catch (e) {
          // Show error dialog
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text('Error'),
                  content: Text('Failed to add custom ingredient: $e'),
                  actions: [
                    CupertinoButton(
                      child: const Text('OK'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
          );
        }
      },
      onDelete: () {},
    );
  }

  showDialog(
    context: context,
    builder: (context) {
      return PopScope(
        canPop: true,
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

            // Apply search filter
            final searchFilteredIngredients =
                searchController.text.isEmpty
                    ? filteredIngredients
                    : filteredIngredients
                        .where(
                          (ing) => ing.name.toLowerCase().contains(
                            searchController.text.toLowerCase(),
                          ),
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
                      'Add Ingredients',
                      style: TextStyle(
                        color: AppColors.button,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Casta',
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.button.withOpacity(0.2),
                        ),
                      ),
                      child: CupertinoTextField(
                        controller: searchController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        placeholder: 'Search ingredients...',
                        prefix: const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(
                            CupertinoIcons.search,
                            color: AppColors.button,
                            size: 20,
                          ),
                        ),
                        style: const TextStyle(
                          color: AppColors.button,
                          fontSize: 16,
                        ),
                        decoration: null,
                        onChanged: (value) => setState(() {}),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length + 1,
                        itemBuilder: (context, index) {
                          final isAll = index == 0;
                          final category = isAll ? null : categories[index - 1];
                          final categoryName = isAll ? 'All' : category!.name;
                          final isSelected = categoryName == selectedCategory;

                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: GestureDetector(
                              onTap:
                                  () => setState(
                                    () => selectedCategory = categoryName,
                                  ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? AppColors.mutedGreen
                                          : AppColors.mutedGreen.withOpacity(
                                            0.2,
                                          ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    categoryName,
                                    style: TextStyle(
                                      color:
                                          isSelected
                                              ? AppColors.white
                                              : AppColors.button.withOpacity(
                                                0.9,
                                              ),
                                      fontSize: 14,
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    Flexible(
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.6,
                        ),
                        child: CupertinoScrollbar(
                          child: ListView.builder(
                            itemCount: searchFilteredIngredients.length,
                            itemBuilder: (context, index) {
                              final ing = searchFilteredIngredients[index];
                              final ingEntry = selectedIngredients.firstWhere(
                                (ui) => ui.ingredient.id == ing.id,
                                orElse:
                                    () => UserIng(
                                      id: -1,
                                      uid: '',
                                      ingredient: ing,
                                      quantity: 0,
                                      unit: resourceProvider.units.first,
                                    ),
                              );
                              final selected = ingEntry.id != -1;

                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color:
                                      selected
                                          ? AppColors.mutedGreen
                                          : CupertinoColors.systemGrey5,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color:
                                        selected
                                            ? AppColors.mutedGreen
                                            : AppColors.mutedGreen.withOpacity(
                                              0.5,
                                            ),
                                  ),
                                ),
                                child: ListTile(
                                  title: Text(
                                    ing.name,
                                    style: TextStyle(
                                      color:
                                          selected
                                              ? AppColors.white
                                              : AppColors.button,
                                      fontSize: 16,
                                    ),
                                  ),
                                  trailing:
                                      selected
                                          ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  '${ingEntry.quantity} ${ingEntry.unit?.abbreviation ?? ingEntry.unit?.name ?? ""}',
                                                  style: const TextStyle(
                                                    color:
                                                        CupertinoColors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              const Icon(
                                                CupertinoIcons
                                                    .checkmark_circle_fill,
                                                color: CupertinoColors.white,
                                                size: 20,
                                              ),
                                            ],
                                          )
                                          : const Icon(
                                            CupertinoIcons.circle,
                                            color: AppColors.mutedGreen,
                                          ),
                                  onTap: () async {
                                    if (!selected) {
                                      String quantityInput = '1';
                                      Unit selectedUnit =
                                          resourceProvider.units.first;

                                      await showModalBottomSheet(
                                        backgroundColor:
                                            CupertinoColors.systemGrey6,
                                        context: context,
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(24),
                                          ),
                                        ),
                                        builder: (context) {
                                          return Padding(
                                            padding: MediaQuery.of(context)
                                                .viewInsets
                                                .add(const EdgeInsets.all(24)),
                                            child: StatefulBuilder(
                                              builder: (
                                                context,
                                                setStateBottom,
                                              ) {
                                                return Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      width: 40,
                                                      height: 4,
                                                      margin:
                                                          const EdgeInsets.only(
                                                            bottom: 24,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: AppColors.button
                                                            .withOpacity(0.2),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              2,
                                                            ),
                                                      ),
                                                    ),
                                                    const Text(
                                                      'Enter Quantity',
                                                      style: TextStyle(
                                                        color: AppColors.button,
                                                        fontFamily: 'Casta',
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 0.5,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 16),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            CupertinoColors
                                                                .white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        border: Border.all(
                                                          color: AppColors
                                                              .button
                                                              .withOpacity(0.2),
                                                        ),
                                                      ),
                                                      child: CupertinoTextField(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 16,
                                                              vertical: 12,
                                                            ),
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        placeholder: 'e.g. 1.5',
                                                        style: const TextStyle(
                                                          color:
                                                              AppColors.button,
                                                          fontSize: 16,
                                                        ),
                                                        decoration: null,
                                                        onChanged:
                                                            (value) =>
                                                                quantityInput =
                                                                    value,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 32),
                                                    const Text(
                                                      'Select Unit',
                                                      style: TextStyle(
                                                        color: AppColors.button,
                                                        fontFamily: 'Casta',
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 0.5,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 16),
                                                    Container(
                                                      height: 150,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            CupertinoColors
                                                                .white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        border: Border.all(
                                                          color: AppColors
                                                              .button
                                                              .withOpacity(0.2),
                                                        ),
                                                      ),
                                                      child: CupertinoPicker(
                                                        itemExtent: 32.0,
                                                        scrollController:
                                                            FixedExtentScrollController(
                                                              initialItem: 0,
                                                            ),
                                                        onSelectedItemChanged: (
                                                          index,
                                                        ) {
                                                          setStateBottom(
                                                            () =>
                                                                selectedUnit =
                                                                    resourceProvider
                                                                        .units[index],
                                                          );
                                                        },
                                                        children:
                                                            resourceProvider
                                                                .units
                                                                .map(
                                                                  (
                                                                    unit,
                                                                  ) => Center(
                                                                    child: Text(
                                                                      unit.name,
                                                                      style: const TextStyle(
                                                                        color:
                                                                            AppColors.button,
                                                                        fontSize:
                                                                            16,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                                .toList(),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 32),
                                                    CupertinoButton(
                                                      padding: EdgeInsets.zero,
                                                      onPressed:
                                                          () => Navigator.pop(
                                                            context,
                                                          ),
                                                      child: Container(
                                                        width: double.infinity,
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              vertical: 16,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color:
                                                              AppColors
                                                                  .mutedGreen,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                18,
                                                              ),
                                                        ),
                                                        child: const Text(
                                                          'Confirm',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color:
                                                                AppColors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            letterSpacing: 0.5,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      );

                                      setState(() {
                                        selectedIngredients.add(
                                          UserIng(
                                            id: ing.id,
                                            uid:
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid,
                                            ingredient: ing,
                                            quantity:
                                                int.tryParse(quantityInput) ??
                                                1,
                                            unit: selectedUnit,
                                          ),
                                        );
                                      });
                                    } else {
                                      setState(() {
                                        selectedIngredients.removeWhere(
                                          (ui) => ui.ingredient.id == ing.id,
                                        );
                                      });
                                    }
                                  },
                                ),
                              );
                            },
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
                    const SizedBox(height: 24),
                    NavigationTextLink(
                      label: 'Add a custom ingredient',
                      onTap: () => _showCustomIngredientDialog(),
                      style: const TextStyle(
                        color: CupertinoColors.systemBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
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
