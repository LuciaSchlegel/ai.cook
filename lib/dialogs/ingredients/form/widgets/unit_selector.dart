import 'package:ai_cook_project/dialogs/ingredients/form/widgets/picker_modal.dart';
import 'package:ai_cook_project/models/unit.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:flutter/cupertino.dart';

class UnitSelectorButton extends StatelessWidget {
  final Unit selectedUnit;
  final List<Unit> units;
  final void Function(Unit) onUnitSelected;

  const UnitSelectorButton({
    super.key,
    required this.selectedUnit,
    required this.units,
    required this.onUnitSelected,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      onPressed: () {
        showCupertinoModalPopup(
          context: context,
          builder:
              (_) => UnitPickerModal(
                selectedUnit: selectedUnit,
                units: units,
                onSelected: onUnitSelected,
              ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            selectedUnit.name,
            style: TextStyle(
              color:
                  selectedUnit.name == 'Select unit'
                      ? AppColors.button.withOpacity(0.5)
                      : AppColors.button,
              fontSize: 16,
            ),
          ),
          const Icon(
            CupertinoIcons.chevron_down,
            color: AppColors.button,
            size: 20,
          ),
        ],
      ),
    );
  }
}
