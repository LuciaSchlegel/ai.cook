import 'package:ai_cook_project/models/unit.dart';
import 'package:ai_cook_project/utils/text_utils.dart';
import 'package:ai_cook_project/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';

/// Convenience function to show unit picker
Future<Unit?> showUnitPicker({
  required BuildContext context,
  required List<Unit> units,
  required Unit selectedUnit,
}) {
  return AppBottomSheet.showPicker<Unit>(
    context: context,
    items: units,
    selectedItem: selectedUnit,
    displayText: (unit) => TextUtils.capitalizeFirstLetter(unit.name),
    areEqual: (a, b) => a.id == b.id,
    title: 'Select Unit',
  );
}
