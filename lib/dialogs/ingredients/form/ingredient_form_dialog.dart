import 'package:ai_cook_project/dialogs/ingredients/form/logic/form_logic.dart';
import 'package:ai_cook_project/dialogs/ingredients/form/widgets/fields.dart';
import 'package:ai_cook_project/dialogs/ingredients/form/widgets/unit_selector.dart';
import 'package:ai_cook_project/models/category_model.dart';
import 'package:ai_cook_project/models/custom_ing_model.dart';
import 'package:ai_cook_project/models/dietary_tag_model.dart';
import 'package:ai_cook_project/providers/resource_provider.dart';
import 'package:ai_cook_project/widgets/buttons/form_action_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/models/ingredient_model.dart';
import 'package:ai_cook_project/models/unit.dart';
import 'package:provider/provider.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';

class IngredientFormDialog extends StatefulWidget {
  final Ingredient? ingredient;
  final CustomIngredient? customIngredient;
  final double quantity;
  final Unit? unit;
  final List<Category> categories;
  final Function(
    String name,
    Category category,
    bool isVegan,
    bool isVegetarian,
    bool isGlutenFree,
    bool isLactoseFree,
    double quantity,
    Unit unit,
  )
  onSave;
  final Function()? onDelete;
  final bool isPopup; // New parameter to detect popup mode

  const IngredientFormDialog({
    super.key,
    this.ingredient,
    this.customIngredient,
    this.quantity = 1,
    this.unit,
    required this.categories,
    required this.onSave,
    this.onDelete,
    this.isPopup = false, // Default to false for backward compatibility
  });

  @override
  State<IngredientFormDialog> createState() => _IngredientFormDialogState();
}

class _IngredientFormDialogState extends State<IngredientFormDialog> {
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late Category _selectedCategory;
  late Unit _selectedUnit;
  final Set<DietaryTag> _selectedTags = {};

  @override
  void initState() {
    _nameController = TextEditingController();
    _quantityController = TextEditingController();

    IngredientFormUtils.initializeState(
      nameController: _nameController,
      quantityController: _quantityController,
      ingredient: widget.ingredient,
      customIngredient: widget.customIngredient,
      quantity: widget.quantity,
      categories: widget.categories,
      selectedTags: _selectedTags,
      setCategory: (cat) => _selectedCategory = cat,
      setUnit: (unit) => _selectedUnit = unit,
      providedUnit: widget.unit,
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final resourceProvider = Provider.of<ResourceProvider>(
      context,
      listen: false,
    );
    if (widget.unit == null &&
        _selectedUnit.id == -1 &&
        resourceProvider.units.isNotEmpty) {
      setState(() {
        _selectedUnit = resourceProvider.units.first;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    return IngredientFormUtils.isFormValid(
      name: _nameController.text,
      tags: _selectedTags,
      quantity: _quantityController.text,
      unit: _selectedUnit,
      isEditing: widget.ingredient != null || widget.customIngredient != null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final resourceProvider = Provider.of<ResourceProvider>(context);
    final availableUnits = resourceProvider.units;
    final showDragHandle =
        !widget.isPopup; // Only show drag handle for bottom sheet

    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            padding: EdgeInsets.all(
              ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius:
                  widget.isPopup
                      ? BorderRadius.circular(
                        // All corners rounded for popup
                        ResponsiveUtils.borderRadius(
                          context,
                          ResponsiveBorderRadius.lg,
                        ),
                      )
                      : BorderRadius.vertical(
                        // Only top rounded for bottom sheet
                        top: Radius.circular(
                          ResponsiveUtils.borderRadius(
                            context,
                            ResponsiveBorderRadius.xl,
                          ),
                        ),
                      ),
              boxShadow:
                  widget.isPopup
                      ? [
                        BoxShadow(
                          color: AppColors.button.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ]
                      : [
                        BoxShadow(
                          color: AppColors.mutedGreen.withValues(alpha: 0.06),
                          blurRadius: ResponsiveUtils.spacing(
                            context,
                            ResponsiveSpacing.sm,
                          ),
                          offset: Offset(
                            0,
                            ResponsiveUtils.spacing(
                              context,
                              ResponsiveSpacing.xxs,
                            ),
                          ),
                          spreadRadius: 0,
                        ),
                      ],
            ),
            child: ClipRRect(
              borderRadius:
                  widget.isPopup
                      ? BorderRadius.circular(
                        // All corners rounded for popup
                        ResponsiveUtils.borderRadius(
                          context,
                          ResponsiveBorderRadius.lg,
                        ),
                      )
                      : BorderRadius.vertical(
                        // Only top rounded for bottom sheet
                        top: Radius.circular(
                          ResponsiveUtils.borderRadius(
                            context,
                            ResponsiveBorderRadius.xl,
                          ),
                        ),
                      ),
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Drag handle (only for bottom sheet)
                    if (showDragHandle)
                      Container(
                        width: ResponsiveUtils.spacing(
                          context,
                          ResponsiveSpacing.xxl,
                        ),
                        height: ResponsiveUtils.spacing(
                          context,
                          ResponsiveSpacing.xxs,
                        ),
                        margin: EdgeInsets.only(
                          bottom: ResponsiveUtils.spacing(
                            context,
                            ResponsiveSpacing.lg,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.button.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(
                            ResponsiveUtils.borderRadius(
                              context,
                              ResponsiveBorderRadius.sm,
                            ),
                          ),
                        ),
                      ),
                    ResponsiveText(
                      widget.ingredient == null
                          ? 'Add Ingredient'
                          : 'Edit Ingredient',
                      fontSize: ResponsiveFontSize.title,
                      fontFamily: 'Casta',
                      fontWeight: FontWeight.bold,
                      color: AppColors.button,
                      textAlign: TextAlign.center,
                    ),
                    const ResponsiveSpacingWidget.vertical(
                      ResponsiveSpacing.lg,
                    ),
                    IngredientNameField(name: _nameController.text),
                    const ResponsiveSpacingWidget.vertical(
                      ResponsiveSpacing.xxs,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ResponsiveContainer(
                            backgroundColor: CupertinoColors.white,
                            borderRadius: ResponsiveBorderRadius.sm,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.button.withValues(
                                    alpha: 0.12,
                                  ),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(
                                  ResponsiveUtils.borderRadius(
                                    context,
                                    ResponsiveBorderRadius.sm,
                                  ),
                                ),
                              ),
                              child: QuantityField(
                                controller: _quantityController,
                              ),
                            ),
                          ),
                        ),
                        const ResponsiveSpacingWidget.horizontal(
                          ResponsiveSpacing.sm,
                        ),
                        Expanded(
                          child: ResponsiveContainer(
                            backgroundColor: CupertinoColors.white,
                            borderRadius: ResponsiveBorderRadius.sm,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.button.withValues(
                                    alpha: 0.12,
                                  ),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(
                                  ResponsiveUtils.borderRadius(
                                    context,
                                    ResponsiveBorderRadius.sm,
                                  ),
                                ),
                              ),
                              child: UnitSelectorButton(
                                selectedUnit: _selectedUnit,
                                units: availableUnits,
                                onUnitSelected: (unit) {
                                  setState(() {
                                    _selectedUnit = unit;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const ResponsiveSpacingWidget.vertical(
                      ResponsiveSpacing.md,
                    ),
                    ResponsiveContainer(
                      borderRadius: ResponsiveBorderRadius.md,
                      child: FormActionButtons(
                        isValid: _validateForm(),
                        onDelete: widget.onDelete,
                        isEditing:
                            widget.ingredient != null ||
                            widget.customIngredient != null,
                        onCancel: () => Navigator.pop(context),
                        onSave:
                            () => IngredientFormUtils.handleSave(
                              validateForm: _validateForm,
                              onSave: () {
                                widget.onSave(
                                  _nameController.text,
                                  _selectedCategory,
                                  _selectedTags.any(
                                    (tag) => tag.name == 'vegan',
                                  ),
                                  _selectedTags.any(
                                    (tag) => tag.name == 'vegetarian',
                                  ),
                                  _selectedTags.any(
                                    (tag) => tag.name == 'gluten_free',
                                  ),
                                  _selectedTags.any(
                                    (tag) => tag.name == 'lactose_free',
                                  ),
                                  double.parse(_quantityController.text),
                                  _selectedUnit,
                                );
                              },
                              closeDialog: () => Navigator.pop(context),
                            ),
                      ),
                    ),
                    // Add safe area padding at bottom + keyboard padding
                    SizedBox(
                      height:
                          ResponsiveUtils.getScrollBottomPadding(context) +
                          (widget.isPopup
                              ? 0
                              : MediaQuery.of(context).viewInsets.bottom * 0.1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
