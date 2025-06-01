import 'package:ai_cook_project/models/custom_ing_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/models/ingredient_model.dart';
import 'package:ai_cook_project/models/unit.dart';

class IngredientFormDialog extends StatefulWidget {
  final Ingredient? ingredient;
  final CustomIngredient? customIngredient;
  final int quantity;
  final Unit? unit;
  final List<String> categories;
  final Function(
    String name,
    String category,
    List<String> tags,
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
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late String _selectedCategory;
  late Unit _selectedUnit;
  final Set<String> _selectedTags = {};

  // Available tags
  final List<String> _availableTags = [
    'vegan',
    'vegetarian',
    'gluten-free',
    'dairy-free',
    'high-protein',
    'low-carb',
    'low-fat',
    'healthy',
  ];

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
    _selectedUnit = widget.unit ?? Unit.unit;

    // Initialize selected tags
    if (widget.ingredient?.tags != null) {
      _selectedTags.addAll(widget.ingredient!.tags!);
    } else if (widget.customIngredient?.tags != null) {
      _selectedTags.addAll(widget.customIngredient!.tags!);
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
    try {
      int.parse(_quantityController.text);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        8,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6.withOpacity(1),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          Text(
            widget.ingredient == null ? 'Add Ingredient' : 'Edit Ingredient',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Times New Roman',
              color: AppColors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Name field
          CupertinoTextField(
            controller: _nameController,
            placeholder: 'Name',
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            placeholderStyle: TextStyle(
              color: CupertinoColors.systemGrey.resolveFrom(context),
              fontSize: 16,
            ),
            style: TextStyle(color: AppColors.black, fontSize: 16),
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground.resolveFrom(context),
              border: Border.all(color: CupertinoColors.systemGrey3),
              borderRadius: BorderRadius.circular(20),
            ),
            cursorColor: AppColors.mutedGreen,
          ),
          const SizedBox(height: 16),

          // Category dropdown
          Container(
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground.resolveFrom(context),
              border: Border.all(color: CupertinoColors.systemGrey3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: CupertinoButton(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                                  color: CupertinoColors.systemGrey6
                                      .resolveFrom(context),
                                  border: Border(
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
                                      padding: EdgeInsets.zero,
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: AppColors.mutedGreen,
                                        ),
                                      ),
                                      onPressed:
                                          () => Navigator.of(context).pop(),
                                    ),
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      child: Text(
                                        'Done',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.mutedGreen,
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
                                  scrollController: FixedExtentScrollController(
                                    initialItem: widget.categories.indexOf(
                                      _selectedCategory,
                                    ),
                                  ),
                                  onSelectedItemChanged: (int selectedItem) {
                                    setState(() {
                                      _selectedCategory =
                                          widget.categories[selectedItem];
                                    });
                                  },
                                  children:
                                      widget.categories
                                          .map((category) => Text(category))
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
                    _selectedCategory,
                    style: TextStyle(color: AppColors.black, fontSize: 16),
                  ),
                  Icon(
                    CupertinoIcons.chevron_down,
                    color: AppColors.black,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Tags section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground.resolveFrom(context),
              border: Border.all(
                color:
                    _selectedTags.isEmpty
                        ? CupertinoColors.systemRed
                        : CupertinoColors.systemGrey3,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tags (select at least one)',
                  style: TextStyle(
                    color: CupertinoColors.systemGrey.resolveFrom(context),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      _availableTags.map((tag) {
                        final isSelected = _selectedTags.contains(tag);
                        return FilterChip(
                          label: Text(tag),
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
                                    : AppColors.black.withOpacity(0.8),
                          ),
                          side: BorderSide(
                            color:
                                isSelected
                                    ? AppColors.mutedGreen
                                    : CupertinoColors.systemGrey6,
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
                child: CupertinoTextField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  placeholder: 'Quantity',
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  placeholderStyle: TextStyle(
                    color: CupertinoColors.systemGrey.resolveFrom(context),
                    fontSize: 16,
                  ),
                  style: TextStyle(color: AppColors.black, fontSize: 16),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground.resolveFrom(
                      context,
                    ),
                    border: Border.all(color: CupertinoColors.systemGrey3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  cursorColor: AppColors.mutedGreen,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground.resolveFrom(
                      context,
                    ),
                    border: Border.all(color: CupertinoColors.systemGrey3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CupertinoButton(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder:
                            (BuildContext context) => Container(
                              height: 216,
                              padding: const EdgeInsets.only(top: 6.0),
                              margin: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
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
                                        color: CupertinoColors.systemGrey6
                                            .resolveFrom(context),
                                        border: Border(
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
                                            padding: EdgeInsets.zero,
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                color: AppColors.mutedGreen,
                                              ),
                                            ),
                                            onPressed:
                                                () =>
                                                    Navigator.of(context).pop(),
                                          ),
                                          CupertinoButton(
                                            padding: EdgeInsets.zero,
                                            child: Text(
                                              'Done',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.mutedGreen,
                                              ),
                                            ),
                                            onPressed:
                                                () =>
                                                    Navigator.of(context).pop(),
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
                                              initialItem: Unit.values.indexOf(
                                                _selectedUnit,
                                              ),
                                            ),
                                        onSelectedItemChanged: (
                                          int selectedItem,
                                        ) {
                                          setState(() {
                                            _selectedUnit =
                                                Unit.values[selectedItem];
                                          });
                                        },
                                        children:
                                            Unit.values
                                                .map((unit) => Text(unit.label))
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
                          _selectedUnit.label,
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                          ),
                        ),
                        Icon(
                          CupertinoIcons.chevron_down,
                          color: AppColors.black,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.ingredient != null ||
                  widget.customIngredient != null) ...[
                TextButton(
                  onPressed: widget.onDelete,
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Delete'),
                ),
                const SizedBox(width: 16),
              ],
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: TextStyle(color: AppColors.black)),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.button,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  widget.ingredient == null ? 'Add' : 'Save',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
