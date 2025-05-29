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

  const IngredientFormDialog({
    super.key,
    this.ingredient,
    this.customIngredient,
    this.quantity = 1,
    this.unit,
    required this.categories,
    required this.onSave,
  });

  @override
  State<IngredientFormDialog> createState() => _IngredientFormDialogState();
}

class _IngredientFormDialogState extends State<IngredientFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _tagsController;
  late TextEditingController _quantityController;
  late String _selectedCategory;
  late Unit _selectedUnit;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.ingredient?.name ?? widget.customIngredient?.name ?? '',
    );
    _tagsController = TextEditingController(
      text:
          widget.ingredient?.tags?.join(', ') ??
          widget.customIngredient?.tags?.join(', ') ??
          '',
    );
    _quantityController = TextEditingController(
      text: widget.quantity.toString(),
    );
    _selectedCategory =
        widget.ingredient?.category ??
        widget.customIngredient?.category ??
        widget.categories.first;
    _selectedUnit = widget.unit ?? Unit.unit;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _tagsController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  List<String> _parseTags(String tagsString) {
    return tagsString
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();
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
                        height: 216, // Standard iOS picker height
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
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
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
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
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

          // Tags field
          CupertinoTextField(
            controller: _tagsController,
            placeholder: 'Tags (comma-separated)',
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
                              height: 216, // Standard iOS picker height
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
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: TextStyle(color: AppColors.black)),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onSave(
                      _nameController.text,
                      _selectedCategory,
                      _parseTags(_tagsController.text),
                      int.parse(_quantityController.text),
                      _selectedUnit,
                    );
                    Navigator.pop(context);
                  }
                },
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
