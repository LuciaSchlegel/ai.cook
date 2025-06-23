bool isCustomIngFormValid({
  required String name,
  required String quantityText,
  required List selectedTags,
  required String unitName,
}) {
  if (name.trim().isEmpty) return false;
  if (selectedTags.isEmpty) return false;
  if (unitName == 'Select unit') return false;

  final quantity = int.tryParse(quantityText);
  if (quantity == null || quantity <= 0) return false;

  return true;
}
