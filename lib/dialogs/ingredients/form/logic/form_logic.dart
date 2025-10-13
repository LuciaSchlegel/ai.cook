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

    // Populate dietary tags from ingredient boolean properties
    if (ingredient != null) {
      selectedTags.clear();
      if (ingredient.isVegan) {
        selectedTags.add(DietaryTag(id: 1, name: 'vegan'));
      }
      if (ingredient.isVegetarian) {
        selectedTags.add(DietaryTag(id: 2, name: 'vegetarian'));
      }
      if (ingredient.isGlutenFree) {
        selectedTags.add(DietaryTag(id: 3, name: 'gluten_free'));
      }
      if (ingredient.isLactoseFree) {
        selectedTags.add(DietaryTag(id: 4, name: 'lactose_free'));
      }
    } else if (customIngredient != null) {
      selectedTags.clear();
      if (customIngredient.isVegan) {
        selectedTags.add(DietaryTag(id: 1, name: 'vegan'));
      }
      if (customIngredient.isVegetarian) {
        selectedTags.add(DietaryTag(id: 2, name: 'vegetarian'));
      }
      if (customIngredient.isGlutenFree) {
        selectedTags.add(DietaryTag(id: 3, name: 'gluten_free'));
      }
      if (customIngredient.isLactoseFree) {
        selectedTags.add(DietaryTag(id: 4, name: 'lactose_free'));
      }
    }
  }

  /// Valida si el formulario está completo y correcto
  static bool isFormValid({
    required String name,
    required Set<DietaryTag> tags,
    required String quantity,
    required Unit unit,
    bool isEditing = false,
  }) {
    // Name cannot be empty
    if (name.isEmpty) return false;

    // Unit must be selected
    if (unit.name == 'Select unit') return false;

    // Quantity must be valid
    if (double.tryParse(quantity) == null) return false;

    // For editing existing ingredients, dietary tags are optional
    // For new ingredients, we might want to require at least one dietary tag
    // But for now, let's make it optional for both cases
    return true;
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
