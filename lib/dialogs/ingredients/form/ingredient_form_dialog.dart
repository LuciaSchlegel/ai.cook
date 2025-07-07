import 'package:ai_cook_project/dialogs/ingredients/form/logic/form_logic.dart';
import 'package:ai_cook_project/dialogs/ingredients/form/widgets/fields.dart';
import 'package:ai_cook_project/dialogs/ingredients/form/widgets/unit_selector.dart';
import 'package:ai_cook_project/models/category_model.dart';
import 'package:ai_cook_project/models/custom_ing_model.dart';
import 'package:ai_cook_project/models/tag_model.dart';
import 'package:ai_cook_project/providers/resource_provider.dart';
import 'package:ai_cook_project/widgets/form_action_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/models/ingredient_model.dart';
import 'package:ai_cook_project/models/unit.dart';
import 'package:provider/provider.dart';

class IngredientFormDialog extends StatefulWidget {
  final Ingredient? ingredient;
  final CustomIngredient? customIngredient;
  final int quantity;
  final Unit? unit;
  final List<Category> categories;
  final Function(
    String name,
    Category category,
    List<Tag> tags,
    int quantity,
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
  final Set<Tag> _selectedTags = {};

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
          24,
          16,
          24,
          MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          // No shadow at all
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: AppColors.button.withOpacity(0.15), // softer
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                widget.ingredient == null
                    ? 'Add Ingredient'
                    : 'Edit Ingredient',
                style: const TextStyle(
                  fontSize: 30,
                  fontFamily: 'Casta',
                  color: AppColors.button,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              IngredientNameField(name: _nameController.text),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.button.withOpacity(0.12), // lighter border
                          width: 1,
                        ),
                      ),
                      child: QuantityField(controller: _quantityController),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.button.withOpacity(0.12), // lighter border
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
              const SizedBox(height: 36),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
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
                        onSave: () {
                          widget.onSave(
                            _nameController.text,
                            _selectedCategory,
                            _selectedTags.toList(),
                            int.parse(_quantityController.text),
                            _selectedUnit,
                          );
                        },
                        closeDialog: () => Navigator.pop(context),
                      ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
