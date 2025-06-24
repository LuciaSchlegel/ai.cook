// 📁 ingredient_selection_tile.dart
import 'package:ai_cook_project/dialogs/ingredients/global_ing/add/widgets/picker.dart';
import 'package:ai_cook_project/models/ingredient_model.dart';
import 'package:ai_cook_project/models/unit.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class IngredientSelectionTile extends StatelessWidget {
  final Ingredient ingredient;
  final bool selected;
  final int quantity;
  final Unit unit;
  final List<Unit> units;
  final void Function(int quantity, Unit unit) onConfirm;
  final VoidCallback onDeselect;

  const IngredientSelectionTile({
    super.key,
    required this.ingredient,
    required this.selected,
    required this.quantity,
    required this.unit,
    required this.units,
    required this.onConfirm,
    required this.onDeselect,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color:
            selected
                ? AppColors.mutedGreen.withOpacity(0.1)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? AppColors.mutedGreen : CupertinoColors.systemGrey4,
          width: 1.5,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(
          ingredient.name,
          style: const TextStyle(
            color: AppColors.button,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing:
            selected
                ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$quantity ${unit.abbreviation}',
                      style: const TextStyle(
                        color: AppColors.mutedGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      CupertinoIcons.checkmark_alt_circle_fill,
                      color: AppColors.mutedGreen,
                    ),
                  ],
                )
                : const Icon(
                  CupertinoIcons.add_circled,
                  color: AppColors.mutedGreen,
                ),
        onTap: () async {
          if (selected) {
            onDeselect();
          } else {
            final result = await showCupertinoModalPopup<(int, Unit)?>(
              context: context,
              builder: (_) => QuantityUnitPicker(units: units),
            );
            if (result != null) {
              final (qty, unit) = result;
              onConfirm(qty, unit);
            }
          }
        },
      ),
    );
  }
}
