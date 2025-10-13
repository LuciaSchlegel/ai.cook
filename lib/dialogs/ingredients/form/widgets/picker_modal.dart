import 'package:ai_cook_project/models/unit.dart';
import 'package:ai_cook_project/utils/text_utils.dart';
import 'package:ai_cook_project/widgets/pickers/generic_picker_modal.dart';
import 'package:flutter/cupertino.dart';

class UnitPickerModal extends StatelessWidget {
  final Unit selectedUnit;
  final List<Unit> units;
  final void Function(Unit) onSelected;

  const UnitPickerModal({
    super.key,
    required this.selectedUnit,
    required this.units,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GenericPickerModal<Unit>(
      items: units,
      selectedItem: selectedUnit,
      getDisplayText: (unit) => TextUtils.capitalizeFirstLetter(unit.name),
      areEqual: (a, b) => a.id == b.id,
      onSelected: onSelected,
      title: 'Select Unit',
    );
  }
}

/// Convenience function to show unit picker
Future<Unit?> showUnitPicker({
  required BuildContext context,
  required List<Unit> units,
  required Unit selectedUnit,
}) {
  return showGenericPicker<Unit>(
    context: context,
    items: units,
    selectedItem: selectedUnit,
    getDisplayText: (unit) => TextUtils.capitalizeFirstLetter(unit.name),
    areEqual: (a, b) => a.id == b.id,
    title: 'Select Unit',
  );
}
