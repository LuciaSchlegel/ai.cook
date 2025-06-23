import 'package:ai_cook_project/models/unit.dart';
import 'package:ai_cook_project/theme.dart';
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
    return Container(
      height: 216,
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: Column(
        children: [
          // toolbar
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              border: const Border(
                bottom: BorderSide(
                  color: CupertinoColors.systemGrey4,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.mutedGreen),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoButton(
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.mutedGreen,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // picker
          Expanded(
            child: CupertinoPicker(
              itemExtent: 32.0,
              scrollController: FixedExtentScrollController(
                initialItem: units.indexWhere((u) => u.id == selectedUnit.id),
              ),
              onSelectedItemChanged: (index) {
                onSelected(units[index]);
              },
              children:
                  units.map((unit) => Center(child: Text(unit.name))).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
