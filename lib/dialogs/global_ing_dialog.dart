import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/providers/ingredients_provider.dart';
import 'package:ai_cook_project/providers/resource_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../theme.dart';

Future<void> showGlobalIngredientsDialog(BuildContext context) async {
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
                              ing.category?.name?.trim().toLowerCase() ==
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      ],
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
                            padding: EdgeInsets.only(
                              right: 12,
                              left: index == 0 ? 0 : 0,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCategory = categoryName;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                constraints: const BoxConstraints(minWidth: 80),
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
                                    textAlign: TextAlign.center,
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
                            itemCount: filteredIngredients.length,
                            itemBuilder: (context, index) {
                              final ing = filteredIngredients[index];
                              bool selected = selectedIngredients.any(
                                (ui) => ui.ingredient?.id == ing.id,
                              );
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
                                    width: 1,
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
                                          ? const Icon(
                                            CupertinoIcons
                                                .checkmark_circle_fill,
                                            color: AppColors.white,
                                          )
                                          : Icon(
                                            CupertinoIcons.circle,
                                            color: AppColors.mutedGreen,
                                          ),
                                  onTap: () {
                                    setState(() {
                                      if (!selected) {
                                        selectedIngredients.add(
                                          UserIng(
                                            id: ing.id,
                                            uid:
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid,
                                            ingredient: ing,
                                            quantity: 1,
                                            unit: resourceProvider.units.first,
                                          ),
                                        );
                                      } else {
                                        selectedIngredients.removeWhere(
                                          (ui) => ui.ingredient?.id == ing.id,
                                        );
                                      }
                                    });
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
                                  await ingredientsProvider.addUserIngredient(
                                    ing,
                                  );
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
