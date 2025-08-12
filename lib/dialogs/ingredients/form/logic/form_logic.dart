import 'package:ai_cook_project/models/dietary_tag_model.dart';
import 'package:ai_cook_project/models/unit.dart';
import 'package:ai_cook_project/models/category_model.dart';
import 'package:ai_cook_project/models/ingredient_model.dart';
import 'package:ai_cook_project/models/custom_ing_model.dart';
import 'package:flutter/material.dart';

class IngredientFormUtils {
  /// Inicializa los controladores y el estado inicial del formulario
  static void initializeState({
    required TextEditingController nameController,
    required TextEditingController quantityController,
    required Ingredient? ingredient,
    required CustomIngredient? customIngredient,
    required double quantity,
    required List<Category> categories,
    required Set<DietaryTag> selectedTags,
    required Function(Category) setCategory,
    required Function(Unit) setUnit,
    required Unit? providedUnit,
  }) {
    nameController.text = ingredient?.name ?? customIngredient?.name ?? '';
    final bool isEditing = ingredient != null || customIngredient != null;
    quantityController.text =
        isEditing && quantity > 0 ? quantity.toString() : '';

    final category =
        ingredient?.category ?? customIngredient?.category ?? categories.first;
    setCategory(category);

    final unit =
        providedUnit ??
        Unit(id: -1, name: 'Select unit', abbreviation: '', type: '');
    setUnit(unit);

    // final tags = ingredient?.tags ?? customIngredient?.tags;
    // if (tags != null) selectedTags.addAll(tags);
  }

  /// Valida si el formulario está completo y correcto
  static bool isFormValid({
    required String name,
    required Set<DietaryTag> tags,
    required String quantity,
    required Unit unit,
  }) {
    if (name.isEmpty || tags.isEmpty || unit.name == 'Select unit') {
      return false;
    }
    return double.tryParse(quantity) != null;
  }

  /// Encapsula la lógica de guardado
  static void handleSave({
    required VoidCallback closeDialog,
    required bool Function() validateForm,
    required void Function() onSave,
  }) {
    if (!validateForm()) return;
    onSave();
    closeDialog();
  }
}
