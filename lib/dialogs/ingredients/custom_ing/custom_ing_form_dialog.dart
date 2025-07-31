import 'package:ai_cook_project/dialogs/ingredients/custom_ing/utils/form_utils.dart';
import 'package:ai_cook_project/dialogs/ingredients/custom_ing/widgets/buttons.dart';
import 'package:ai_cook_project/dialogs/ingredients/custom_ing/widgets/cat_picker.dart';
import 'package:ai_cook_project/dialogs/ingredients/custom_ing/widgets/tags_picker.dart';
import 'package:ai_cook_project/dialogs/ingredients/form/widgets/fields.dart'
    as custom_ing_fields;
import 'package:ai_cook_project/dialogs/ingredients/form/widgets/picker_modal.dart';
import 'package:ai_cook_project/models/category_model.dart';
import 'package:ai_cook_project/models/custom_ing_model.dart';
import 'package:ai_cook_project/models/tag_model.dart';
import 'package:ai_cook_project/providers/resource_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/models/ingredient_model.dart';
import 'package:ai_cook_project/models/unit.dart';
import 'package:provider/provider.dart';

class CustomIngFormDialog extends StatefulWidget {
  final Ingredient? ingredient;
  final CustomIngredient? customIngredient;
  final double quantity;
  final Unit? unit;
  final List<Category> categories;
  final Function(
    String name,
    Category category,
    List<Tag> tags,
    double quantity,
    Unit unit,
  )
  onSave;
  final Function()? onDelete;

  const CustomIngFormDialog({
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
  State<CustomIngFormDialog> createState() => _CustomIngFormDialogState();
}

class _CustomIngFormDialogState extends State<CustomIngFormDialog> {
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late Category _selectedCategory;
  late Unit _selectedUnit;
  late Set<Tag> _selectedTags = {};

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.customIngredient?.name ?? '',
    );
    _quantityController = TextEditingController(
      text: widget.quantity.toString(),
    );
    _selectedCategory =
        widget.customIngredient?.category ?? widget.categories.first;
    _selectedUnit = widget.unit!;

    _selectedTags = widget.customIngredient?.tags?.toSet() ?? {};

    if (widget.customIngredient?.tags != null) {
      _selectedTags.addAll(widget.customIngredient!.tags!);
    }
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
    return isCustomIngFormValid(
      name: _nameController.text,
      quantityText: _quantityController.text,
      selectedTags: _selectedTags.toList(),
      unitName: _selectedUnit.name,
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
                widget.customIngredient == null
                    ? 'Add Custom Ingredient'
                    : 'Edit Custom Ingredient',
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
              custom_ing_fields.ControlledIngNameField(
                controller: _nameController,
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.button.withOpacity(0.3)),
                ),
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  onPressed: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder:
                          (BuildContext context) => CategoryPickerModal(
                            categories: widget.categories,
                            selectedCategory: _selectedCategory,
                            onSelected: (newCategory) {
                              setState(() {
                                _selectedCategory = newCategory;
                              });
                            },
                          ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedCategory.name,
                        style: const TextStyle(
                          color: AppColors.button,
                          fontSize: 16,
                        ),
                      ),
                      const Icon(
                        CupertinoIcons.chevron_down,
                        color: AppColors.button,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TagsPicker(
                tags: resourceProvider.tags,
                selectedTags: _selectedTags.toList(),
                onTagsSelected: (tag) {
                  setState(() {
                    if (_selectedTags.contains(tag)) {
                      _selectedTags.remove(tag);
                    } else {
                      _selectedTags.add(tag);
                    }
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.button.withOpacity(0.3),
                        ),
                      ),
                      child: custom_ing_fields.QuantityField(
                        controller: _quantityController,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.button.withOpacity(0.3),
                        ),
                      ),
                      child: CupertinoButton(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        onPressed: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder:
                                (context) => UnitPickerModal(
                                  selectedUnit: _selectedUnit,
                                  units: availableUnits,
                                  onSelected: (Unit selected) {
                                    setState(() {
                                      _selectedUnit = selected;
                                    });
                                  },
                                ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedUnit.name,
                              style: TextStyle(
                                color:
                                    _selectedUnit.name == 'Select unit'
                                        ? AppColors.button.withOpacity(0.5)
                                        : AppColors.button,
                                fontSize: 16,
                              ),
                            ),
                            const Icon(
                              CupertinoIcons.chevron_down,
                              color: AppColors.button,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36),
              SaveButtonsRow(
                isEditing: widget.customIngredient != null,
                onDelete: widget.onDelete,
                onCancel: () => Navigator.pop(context),
                onSave: () {
                  widget.onSave(
                    _nameController.text,
                    _selectedCategory,
                    _selectedTags.toList(),
                    double.parse(_quantityController.text),
                    _selectedUnit,
                  );
                  if (mounted) Navigator.pop(context);
                },
                isFormValid: _validateForm(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
