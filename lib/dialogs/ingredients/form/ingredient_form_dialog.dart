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
import 'package:ai_cook_project/dialogs/ai_recommendations/constants/dialog_constants.dart';

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

  const IngredientFormDialog({
    super.key,
    this.ingredient,
    this.customIngredient,
    this.quantity = 1,
    this.unit,
    required this.categories,
    required this.onSave,
    this.onDelete,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final resourceProvider = Provider.of<ResourceProvider>(context);
    final availableUnits = resourceProvider.units;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(
          DialogConstants.adaptiveSpacing(context, DialogConstants.spacingMD),
          DialogConstants.spacingSM,
          DialogConstants.adaptiveSpacing(context, DialogConstants.spacingMD),
          MediaQuery.of(context).viewInsets.bottom + DialogConstants.spacingMD,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(DialogConstants.radiusXL),
          ),
          boxShadow: DialogConstants.lightShadow,
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(DialogConstants.radiusXL),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(
                    bottom: DialogConstants.spacingMD,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.button.withOpacity(0.15), // softer
                    borderRadius: BorderRadius.circular(
                      DialogConstants.radiusSM,
                    ),
                  ),
                ),
                Text(
                  widget.ingredient == null
                      ? 'Add Ingredient'
                      : 'Edit Ingredient',
                  style: const TextStyle(
                    fontSize: DialogConstants.fontSizeTitle,
                    fontFamily: 'Casta',
                    color: AppColors.button,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: DialogConstants.adaptiveSpacing(
                    context,
                    DialogConstants.spacingLG,
                  ),
                ),
                IngredientNameField(name: _nameController.text),
                const SizedBox(height: DialogConstants.spacingMD),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: CupertinoColors.white,
                          borderRadius: BorderRadius.circular(
                            DialogConstants.radiusSM,
                          ),
                          border: Border.all(
                            color: AppColors.button.withOpacity(
                              0.12,
                            ), // lighter border
                            width: 1,
                          ),
                        ),
                        child: QuantityField(controller: _quantityController),
                      ),
                    ),
                    const SizedBox(width: DialogConstants.spacingSM),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: CupertinoColors.white,
                          borderRadius: BorderRadius.circular(
                            DialogConstants.radiusSM,
                          ),
                          border: Border.all(
                            color: AppColors.button.withOpacity(
                              0.12,
                            ), // lighter border
                            width: 1,
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
                  ],
                ),
                SizedBox(
                  height: DialogConstants.adaptiveSpacing(
                    context,
                    DialogConstants.spacingXL,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      DialogConstants.radiusMD,
                    ),
                  ),
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
                          closeDialog: () => Navigator.pop(context),
                        ),
                  ),
                ),
                // Add safe area padding at bottom
                SizedBox(
                  height: DialogConstants.safeScrollBottomPadding(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
