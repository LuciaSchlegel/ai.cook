import 'package:ai_cook_project/models/category_model.dart';
import 'package:ai_cook_project/models/custom_ing_model.dart';
import 'package:ai_cook_project/models/tag_model.dart';
import 'package:ai_cook_project/providers/resource_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    super.initState();
    _nameController = TextEditingController(
      text: widget.ingredient?.name ?? widget.customIngredient?.name ?? '',
    );
    _quantityController = TextEditingController(
      text: widget.quantity.toString(),
    );
    _selectedCategory =
        widget.ingredient?.category ??
        widget.customIngredient?.category ??
        widget.categories.first;

    // Initialize with the provided unit or a placeholder
    _selectedUnit =
        widget.unit ??
        Unit(id: -1, name: 'Select unit', abbreviation: '', type: '');

    // Initialize selected tags
    if (widget.ingredient?.tags != null) {
      _selectedTags.addAll(widget.ingredient!.tags!);
    } else if (widget.customIngredient?.tags != null) {
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
    // Only set default unit if we don't have one and we're not editing
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
    if (_nameController.text.isEmpty) return false;
    if (_selectedTags.isEmpty) return false;
    if (_selectedUnit.name == 'Select unit') return false;
    try {
      int.parse(_quantityController.text);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final resourceProvider = Provider.of<ResourceProvider>(context);
    final availableTags = resourceProvider.tags;
    final availableUnits = resourceProvider.units;

    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside
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
          color: CupertinoColors.systemGrey6.withOpacity(1),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
                  color: AppColors.button.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                widget.ingredient == null
                    ? 'Add Ingredient'
                    : 'Edit Ingredient',
                style: const TextStyle(
                  fontSize: 28,
                  fontFamily: 'Casta',
                  color: AppColors.button,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Name field
              Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.button.withOpacity(0.2)),
                ),
                child: CupertinoTextField(
                  controller: _nameController,
                  placeholder: 'Name',
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  placeholderStyle: TextStyle(
                    color: AppColors.button.withOpacity(0.5),
                    fontSize: 16,
                  ),
                  style: const TextStyle(color: AppColors.button, fontSize: 16),
                  decoration: null,
                  cursorColor: AppColors.mutedGreen,
                ),
              ),
              const SizedBox(height: 16),

              // Category dropdown
              Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.button.withOpacity(0.2)),
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
                          (BuildContext context) => Container(
                            height: 216,
                            padding: const EdgeInsets.only(top: 6.0),
                            margin: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            color: CupertinoColors.systemBackground.resolveFrom(
                              context,
                            ),
                            child: SafeArea(
                              top: false,
                              child: Column(
                                children: [
                                  Container(
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.white,
                                      border: const Border(
                                        bottom: BorderSide(
                                          color: CupertinoColors.systemGrey4,
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CupertinoButton(
                                          padding: EdgeInsets.only(left: 16),
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(
                                              color: AppColors.mutedGreen,
                                              fontSize: 16,
                                            ),
                                          ),
                                          onPressed:
                                              () => Navigator.of(context).pop(),
                                        ),
                                        CupertinoButton(
                                          padding: EdgeInsets.only(right: 16),
                                          child: const Text(
                                            'Done',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.mutedGreen,
                                              fontSize: 16,
                                            ),
                                          ),
                                          onPressed:
                                              () => Navigator.of(context).pop(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: CupertinoPicker(
                                      magnification: 1.22,
                                      squeeze: 1.2,
                                      useMagnifier: true,
                                      itemExtent: 32.0,
                                      scrollController:
                                          FixedExtentScrollController(
                                            initialItem: widget.categories
                                                .indexOf(_selectedCategory),
                                          ),
                                      onSelectedItemChanged: (
                                        int selectedItem,
                                      ) {
                                        setState(() {
                                          _selectedCategory =
                                              widget.categories[selectedItem];
                                        });
                                      },
                                      children:
                                          widget.categories
                                              .map(
                                                (category) => Center(
                                                  child: Text(
                                                    category.name,
                                                    style: const TextStyle(
                                                      color: AppColors.button,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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

              // Tags section
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        _selectedTags.isEmpty
                            ? CupertinoColors.systemRed
                            : AppColors.button.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tags (select at least one)',
                      style: TextStyle(
                        color: AppColors.button.withOpacity(0.7),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          availableTags.map((tag) {
                            final isSelected = _selectedTags.contains(tag);
                            return FilterChip(
                              label: Text(tag.name),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedTags.add(tag);
                                  } else {
                                    _selectedTags.remove(tag);
                                  }
                                });
                              },
                              backgroundColor: CupertinoColors.systemGrey6,
                              selectedColor: AppColors.mutedGreen,
                              checkmarkColor: AppColors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              labelStyle: TextStyle(
                                color:
                                    isSelected
                                        ? AppColors.white
                                        : AppColors.button.withOpacity(0.8),
                                fontSize: 14,
                              ),
                              side: BorderSide(
                                color:
                                    isSelected
                                        ? AppColors.mutedGreen
                                        : AppColors.button.withOpacity(0.2),
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Quantity and unit row
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.button.withOpacity(0.2),
                        ),
                      ),
                      child: CupertinoTextField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        placeholder: 'Quantity',
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        placeholderStyle: TextStyle(
                          color: AppColors.button.withOpacity(0.5),
                          fontSize: 16,
                        ),
                        style: const TextStyle(
                          color: AppColors.button,
                          fontSize: 16,
                        ),
                        decoration: null,
                        cursorColor: AppColors.mutedGreen,
                        onTap: () {
                          if (_quantityController.text == '0') {
                            _quantityController.clear();
                          }
                        },
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
                          color: AppColors.button.withOpacity(0.2),
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
                                (BuildContext context) => Container(
                                  height: 216,
                                  padding: const EdgeInsets.only(top: 6.0),
                                  margin: EdgeInsets.only(
                                    bottom:
                                        MediaQuery.of(
                                          context,
                                        ).viewInsets.bottom,
                                  ),
                                  color: CupertinoColors.systemBackground
                                      .resolveFrom(context),
                                  child: SafeArea(
                                    top: false,
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: CupertinoColors.white,
                                            border: const Border(
                                              bottom: BorderSide(
                                                color:
                                                    CupertinoColors.systemGrey4,
                                                width: 0.5,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CupertinoButton(
                                                padding: EdgeInsets.only(
                                                  left: 16,
                                                ),
                                                child: const Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                    color: AppColors.mutedGreen,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                onPressed:
                                                    () =>
                                                        Navigator.of(
                                                          context,
                                                        ).pop(),
                                              ),
                                              CupertinoButton(
                                                padding: EdgeInsets.only(
                                                  right: 16,
                                                ),
                                                child: const Text(
                                                  'Done',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.mutedGreen,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                onPressed:
                                                    () =>
                                                        Navigator.of(
                                                          context,
                                                        ).pop(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: CupertinoPicker(
                                            magnification: 1.22,
                                            squeeze: 1.2,
                                            useMagnifier: true,
                                            itemExtent: 32.0,
                                            scrollController:
                                                FixedExtentScrollController(
                                                  initialItem: availableUnits
                                                      .indexOf(_selectedUnit),
                                                ),
                                            onSelectedItemChanged: (
                                              int selectedItem,
                                            ) {
                                              setState(() {
                                                _selectedUnit =
                                                    availableUnits[selectedItem];
                                              });
                                            },
                                            children:
                                                availableUnits
                                                    .map(
                                                      (unit) => Center(
                                                        child: Text(
                                                          unit.name,
                                                          style:
                                                              const TextStyle(
                                                                color:
                                                                    AppColors
                                                                        .button,
                                                                fontSize: 16,
                                                              ),
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
              const SizedBox(height: 32),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (widget.ingredient != null ||
                      widget.customIngredient != null) ...[
                    TextButton(
                      onPressed: widget.onDelete,
                      style: TextButton.styleFrom(
                        foregroundColor: CupertinoColors.systemRed,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.button,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed:
                        _validateForm()
                            ? () {
                              widget.onSave(
                                _nameController.text,
                                _selectedCategory,
                                _selectedTags.toList(),
                                int.parse(_quantityController.text),
                                _selectedUnit,
                              );
                              Navigator.pop(context);
                            }
                            : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color:
                            _validateForm()
                                ? AppColors.mutedGreen
                                : AppColors.mutedGreen.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        widget.ingredient == null ? 'Add' : 'Save',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
