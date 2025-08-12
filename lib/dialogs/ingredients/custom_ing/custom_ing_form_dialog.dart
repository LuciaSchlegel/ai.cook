import 'package:ai_cook_project/dialogs/ingredients/custom_ing/utils/form_utils.dart';
import 'package:ai_cook_project/dialogs/ingredients/custom_ing/widgets/custom_ing_layout.dart';
import 'package:ai_cook_project/models/category_model.dart';
import 'package:ai_cook_project/models/custom_ing_model.dart';
import 'package:ai_cook_project/providers/resource_provider.dart';
import 'package:flutter/cupertino.dart';
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
    bool isVegan,
    bool isVegetarian,
    bool isGlutenFree,
    bool isLactoseFree,
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
  late Set<String> _selectedTags = {};

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.customIngredient?.name ?? '',
    );

    final bool isEditing =
        widget.customIngredient != null || widget.ingredient != null;
    _quantityController = TextEditingController(
      text: isEditing && widget.quantity > 0 ? widget.quantity.toString() : '',
    );
    _selectedCategory =
        widget.customIngredient?.category ?? widget.categories.first;
    _selectedUnit = widget.unit!;

    _selectedTags =
        widget.customIngredient?.dietaryTags.map((e) => e.name).toSet() ?? {};
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
    double? quantity;
    try {
      quantity = double.parse(_quantityController.text);
    } catch (e) {
      return false;
    }

    return isCustomIngFormValid(
      name: _nameController.text,
      quantity: quantity,
      selectedTags: _selectedTags.toList(),
      unitName: _selectedUnit.name,
    );
  }

  void _handleSave() {
    double quantity;
    try {
      quantity = double.parse(_quantityController.text);
    } catch (e) {
      return;
    }

    final tagNames = _selectedTags.map((tag) => tag.toLowerCase()).toSet();

    widget.onSave(
      _nameController.text,
      _selectedCategory,
      tagNames.contains('vegan'),
      tagNames.contains('vegetarian'),
      tagNames.contains('gluten-free'),
      tagNames.contains('lactose-free'),
      quantity,
      _selectedUnit,
    );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final resourceProvider = Provider.of<ResourceProvider>(context);
    final availableUnits = resourceProvider.units;

    return CustomIngLayout(
      isEditing: widget.customIngredient != null,
      nameController: _nameController,
      quantityController: _quantityController,
      selectedCategory: _selectedCategory,
      categories: widget.categories,
      onCategoryChanged: (Category newCategory) {
        setState(() {
          _selectedCategory = newCategory;
        });
      },
      selectedTags: _selectedTags,
      onTagToggle: (String tag) {
        setState(() {
          if (_selectedTags.contains(tag)) {
            _selectedTags.remove(tag);
          } else {
            _selectedTags.add(tag);
          }
        });
      },
      selectedUnit: _selectedUnit,
      availableUnits: availableUnits,
      onUnitChanged: (Unit newUnit) {
        setState(() {
          _selectedUnit = newUnit;
        });
      },
      onCancel: () => Navigator.pop(context),
      onSave: _handleSave,
      onDelete: widget.onDelete,
      isFormValid: _validateForm(),
      resourceProvider: resourceProvider,
    );
  }
}
