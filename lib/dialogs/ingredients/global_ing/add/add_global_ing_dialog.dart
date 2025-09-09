import 'package:ai_cook_project/dialogs/ingredients/global_ing/add/logic/filter.dart';
import 'package:ai_cook_project/dialogs/ingredients/global_ing/add/widgets/add_button.dart';
import 'package:ai_cook_project/dialogs/ingredients/global_ing/add/widgets/empty_list.dart';
import 'package:ai_cook_project/dialogs/ingredients/global_ing/widgets/ing_selection_tile.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/providers/ingredients_provider.dart';
import 'package:ai_cook_project/providers/resource_provider.dart';
import 'package:ai_cook_project/widgets/utils/safe_constrained_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../../theme.dart';
import 'package:ai_cook_project/dialogs/error_dialog.dart';
import 'package:ai_cook_project/utils/app_error_handler.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/constants/dialog_constants.dart';

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

    return SafeConstrainedDialog(
      backgroundColor: AppColors.white,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: DialogConstants.adaptivePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Ingredients',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.button,
                  fontSize: DialogConstants.fontSizeTitle,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Casta',
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: DialogConstants.spacingMD),
              CupertinoTextField(
                controller: searchController,
                placeholder: 'Search ingredients...',
                prefix: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(
                    CupertinoIcons.search,
                    color: AppColors.button,
                    size: DialogConstants.iconSizeMD + 2,
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: DialogConstants.spacingMD),
              SizedBox(
                height: DialogConstants.adaptiveSpacing(context, 50.0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length + 1,
                  itemBuilder: (context, index) {
                    final name =
                        index == 0 ? 'All' : categories[index - 1].name;
                    final selected = name == selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.only(
                        right: DialogConstants.spacingXS,
                      ),
                      child: GestureDetector(
                        onTap: () => setState(() => selectedCategory = name),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: DialogConstants.spacingSM,
                            vertical: DialogConstants.spacingXXS,
                          ),
                          decoration: BoxDecoration(
                            color:
                                selected
                                    ? AppColors.mutedGreen
                                    : AppColors.mutedGreen.withValues(
                                      alpha: 0.2,
                                    ),
                            borderRadius: BorderRadius.circular(
                              DialogConstants.radiusMD,
                            ),
                          ),
                          child: Text(
                            name,
                            style: TextStyle(
                              color:
                                  selected
                                      ? AppColors.white
                                      : AppColors.button.withValues(alpha: 0.8),
                              fontSize: DialogConstants.fontSizeMD,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: DialogConstants.spacingMD),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: DialogConstants.adaptiveSpacing(context, 380.0),
                ),
                child:
                    searchFilteredIngredients.isEmpty
                        ? const EmptyList()
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
                                    quantity: 0.0,
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
              const SizedBox(height: DialogConstants.spacingLG),
              CupertinoButton(
                padding: const EdgeInsets.symmetric(
                  vertical: DialogConstants.spacingSM,
                  horizontal: DialogConstants.spacingLG,
                ),
                color: AppColors.background.withValues(alpha: 0.9),
                disabledColor: AppColors.button.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(DialogConstants.radiusMD),
                onPressed:
                    selectedIngredients.isNotEmpty
                        ? () async {
                          try {
                            await Future.wait(
                              selectedIngredients.map(
                                (ing) => ingredientsProvider.addUserIngredient(
                                  ing.copyWith(id: 0),
                                  optimistic: false,
                                ),
                              ),
                            );
                            await ingredientsProvider.fetchUserIngredients();
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
                    fontSize: DialogConstants.fontSizeMD,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: DialogConstants.spacingXS),
              const AddCustomIngredientButton(),
            ],
          ),
        ),
      ),
    );
  }
}
