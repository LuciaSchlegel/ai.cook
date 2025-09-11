import 'package:ai_cook_project/dialogs/ingredients/global_ing/add/logic/filter.dart';
import 'package:ai_cook_project/dialogs/ingredients/global_ing/add/widgets/add_button.dart';
import 'package:ai_cook_project/dialogs/ingredients/global_ing/add/widgets/empty_list.dart';
import 'package:ai_cook_project/dialogs/ingredients/global_ing/widgets/ing_selection_tile.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/providers/ingredients_provider.dart';
import 'package:ai_cook_project/providers/resource_provider.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:ai_cook_project/widgets/selectors/grey_card_chips.dart';
import 'package:ai_cook_project/widgets/utils/safe_constrained_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../../theme.dart';
import 'package:ai_cook_project/dialogs/error_dialog.dart';
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

    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return SafeConstrainedDialog(
          backgroundColor: AppColors.white,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: ResponsiveUtils.padding(context, ResponsiveSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ResponsiveText(
                    'Add Ingredients',
                    fontSize: ResponsiveFontSize.title,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Casta',
                    color: AppColors.button,
                    letterSpacing: 1.2,
                    textAlign: TextAlign.center,
                  ),
                  ResponsiveSpacingWidget.vertical(ResponsiveSpacing.md),
                  CupertinoTextField(
                    controller: searchController,
                    placeholder: 'Search ingredients...',
                    prefix: Padding(
                      padding: ResponsiveUtils.padding(
                        context,
                        ResponsiveSpacing.sm,
                      ).copyWith(right: 0),
                      child: ResponsiveIcon(
                        CupertinoIcons.search,
                        null,
                        color: AppColors.button,
                        size: ResponsiveIconSize.md,
                      ),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  ResponsiveSpacingWidget.vertical(ResponsiveSpacing.md),
                  GreyCardChips(
                    items: ['All', ...categories.map((c) => c.name)],
                    selectedItems: [selectedCategory],
                    onSelected: (items) {
                      // For category filtering, we want single selection behavior
                      // If multiple items are selected, take the last one (most recently selected)
                      // If the current category was deselected, default to 'All'
                      setState(() {
                        if (items.isEmpty) {
                          selectedCategory = 'All';
                        } else if (items.length == 1) {
                          selectedCategory = items.first;
                        } else {
                          // Multiple items selected, find the one that's not currently selected
                          final newCategory = items.firstWhere(
                            (item) => item != selectedCategory,
                            orElse: () => items.first,
                          );
                          selectedCategory = newCategory;
                        }
                      });
                    },
                    horizontalPadding: ResponsiveSpacing.sm,
                    verticalPadding: ResponsiveSpacing.xs,
                  ),
                  ResponsiveSpacingWidget.vertical(ResponsiveSpacing.md),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight:
                          ResponsiveUtils.getDeviceType(context) ==
                                  DeviceType.iPhone
                              ? 300.0
                              : ResponsiveUtils.getDeviceType(context) ==
                                  DeviceType.iPadMini
                              ? 380.0
                              : 450.0,
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
                  ResponsiveSpacingWidget.vertical(ResponsiveSpacing.lg),
                  CupertinoButton(
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveUtils.spacing(
                        context,
                        ResponsiveSpacing.sm,
                      ),
                      horizontal: ResponsiveUtils.spacing(
                        context,
                        ResponsiveSpacing.lg,
                      ),
                    ),
                    color: AppColors.background.withValues(alpha: 0.9),
                    disabledColor: AppColors.button.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.borderRadius(
                        context,
                        ResponsiveBorderRadius.md,
                      ),
                    ),
                    onPressed:
                        selectedIngredients.isNotEmpty
                            ? () async {
                              try {
                                await Future.wait(
                                  selectedIngredients.map(
                                    (ing) =>
                                        ingredientsProvider.addUserIngredient(
                                          ing.copyWith(id: 0),
                                          optimistic: false,
                                        ),
                                  ),
                                );
                                await ingredientsProvider
                                    .fetchUserIngredients();
                                if (context.mounted) Navigator.pop(context);
                              } catch (e) {
                                final errorMsg = AppErrorHandler.handle(e);
                                if (context.mounted) {
                                  showErrorDialog(context, message: errorMsg);
                                }
                              }
                            }
                            : null,
                    child: ResponsiveText(
                      'Add Selected',
                      fontSize: ResponsiveFontSize.md,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  ResponsiveSpacingWidget.vertical(ResponsiveSpacing.xs),
                  const AddCustomIngredientButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
