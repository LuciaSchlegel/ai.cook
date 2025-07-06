import 'package:ai_cook_project/models/unit.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:flutter/cupertino.dart';

class UnitPickerModal extends StatefulWidget {
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
  State<UnitPickerModal> createState() => _UnitPickerModalState();
}

class _UnitPickerModalState extends State<UnitPickerModal> {
  late Unit _tempSelected;

  @override
  void initState() {
    super.initState();
    _tempSelected = widget.selectedUnit;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: Column(
        children: [
          Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 8),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  onPressed: () => Navigator.pop(context), minimumSize: Size(0, 0),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.mutedGreen, fontSize: 17),
                  ),
                ),
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  onPressed: () {
                    widget.onSelected(_tempSelected);
                    Navigator.pop(context);
                  }, minimumSize: Size(0, 0),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.mutedGreen,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: CupertinoPicker(
              itemExtent: 36.0,
              scrollController: FixedExtentScrollController(
                initialItem: widget.units.indexWhere(
                  (u) => u.id == widget.selectedUnit.id,
                ),
              ),
              onSelectedItemChanged: (index) {
                _tempSelected = widget.units[index];
              },
              children:
                  widget.units
                      .map((unit) => Center(child: Text(unit.name)))
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
