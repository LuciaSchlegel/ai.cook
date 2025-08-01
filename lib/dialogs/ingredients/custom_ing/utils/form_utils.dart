bool isCustomIngFormValid({
  required String name,
  required double quantity,
  required List selectedTags,
  required String unitName,
}) {
  if (name.trim().isEmpty) return false;
  if (selectedTags.isEmpty) return false;
  if (unitName == 'Select unit') return false;

  if (quantity <= 0) return false;

  return true;
}
