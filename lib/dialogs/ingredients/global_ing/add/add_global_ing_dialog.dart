import 'package:ai_cook_project/dialogs/ingredients/global_ing/add/logic/filter.dart';
import 'package:ai_cook_project/dialogs/ingredients/global_ing/add/widgets/add_button.dart';
import 'package:ai_cook_project/dialogs/ingredients/global_ing/add/widgets/empty_list.dart';
import 'package:ai_cook_project/dialogs/ingredients/global_ing/widgets/ing_selection_tile.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/providers/ingredients_provider.dart';
import 'package:ai_cook_project/providers/resource_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../../theme.dart';
import 'package:ai_cook_project/widgets/error_dialog.dart';
import 'package:ai_cook_project/utils/app_error_handler.dart';

class AddGlobalIngDialog extends StatefulWidget {
  const AddGlobalIngDialog({super.key});

  @override
  State<AddGlobalIngDialog> createState() => _AddGlobalIngDialogState();
}

class _AddGlobalIngDialogState extends State<AddGlobalIngDialog> {
  String selectedCategory = 'All';
  final searchController = TextEditingController();
  final selectedIngredients = <UserIng>[];

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
    final userIngredients = ingredientsProvider.userIngredients;
    final categories = resourceProvider.categories;
    final units = resourceProvider.units;
    final searchText = searchController.text.toLowerCase();
    final searchFilteredIngredients = filterIngredients(
      globalIngredients: globalIngredients,
      selectedCategory: selectedCategory,
      searchText: searchText,
    );

    debugPrint(
      'Selected ingredients: ${selectedIngredients.map((ui) => ui.ingredient?.name).toList()}',
    );

    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add Ingredients',
              style: TextStyle(
                color: AppColors.button,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'Casta',
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 28),
            CupertinoTextField(
              controller: searchController,
              placeholder: 'Search ingredients...',
              prefix: const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(
                  CupertinoIcons.search,
                  color: AppColors.button,
                  size: 20,
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 28),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length + 1,
                itemBuilder: (context, index) {
                  final name = index == 0 ? 'All' : categories[index - 1].name;
                  final selected = name == selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => setState(() => selectedCategory = name),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              selected
                                  ? AppColors.mutedGreen
                                  : AppColors.mutedGreen.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          name,
                          style: TextStyle(
                            color:
                                selected
                                    ? AppColors.white
                                    : AppColors.button.withOpacity(0.9),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 28),
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.3,
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child:
                    searchFilteredIngredients.isEmpty
                        ? EmptyList()
                        : ListView.builder(
                          shrinkWrap: true,
                          itemCount: searchFilteredIngredients.length,
                          itemBuilder: (context, index) {
                            final ing = searchFilteredIngredients[index];
                            final ingEntry = selectedIngredients.firstWhere(
                              (ui) => ui.ingredient?.id == ing.id,
                              orElse:
                                  () => UserIng(
                                    id: -1,
                                    uid: '',
                                    ingredient: ing,
                                    quantity: 0,
                                    unit: units.first,
                                  ),
                            );
                            final isInCupboard = userIngredients.any(
                              (ui) => ui.ingredient?.id == ing.id,
                            );
                            return IngredientSelectionTile(
                              ingredient: ing,
                              selected: ingEntry.id != -1,
                              quantity: ingEntry.quantity,
                              unit: ingEntry.unit!,
                              units: units,
                              onConfirm: (qty, unit) {
                                setState(() {
                                  selectedIngredients.removeWhere(
                                    (ui) => ui.ingredient?.id == ing.id,
                                  );
                                  selectedIngredients.add(
                                    UserIng(
                                      id: ing.id,
                                      uid:
                                          FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid,
                                      ingredient: ing,
                                      quantity: qty,
                                      unit: unit,
                                    ),
                                  );
                                });
                              },
                              onDeselect:
                                  () => setState(() {
                                    selectedIngredients.removeWhere(
                                      (ui) => ui.ingredient?.id == ing.id,
                                    );
                                  }),
                              disabled: isInCupboard,
                            );
                          },
                        ),
              ),
            ),
            const SizedBox(height: 28),
            CupertinoButton(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              color:
                  selectedIngredients.isNotEmpty
                      ? AppColors.button
                      : AppColors.button.withOpacity(0.4),
              borderRadius: BorderRadius.circular(18),
              onPressed:
                  selectedIngredients.isNotEmpty
                      ? () async {
                        try {
                          for (final ing in selectedIngredients) {
                            await ingredientsProvider.addUserIngredient(ing);
                          }
                          if (context.mounted) Navigator.pop(context);
                        } catch (e) {
                          final errorMsg = AppErrorHandler.handle(e);
                          if (context.mounted) {
                            showErrorDialog(context, message: errorMsg);
                          }
                        }
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
            const SizedBox(height: 28),
            const AddCustomIngredientButton(),
          ],
        ),
      ),
    );
  }
}
