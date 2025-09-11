bool isCustomIngFormValid({
  required String name,
  required double quantity,
  required List selectedTags,
  required String unitName,
  bool isEditing = false,
}) {
  // Name cannot be empty
  if (name.trim().isEmpty) return false;

  // Unit must be selected
  if (unitName == 'Select unit') return false;

  // Quantity must be positive
  if (quantity <= 0) return false;

  // For new custom ingredients, dietary tags are optional
  // For editing, we allow empty tags since some ingredients might not have dietary restrictions
  // This makes the validation consistent and flexible

  return true;
}
