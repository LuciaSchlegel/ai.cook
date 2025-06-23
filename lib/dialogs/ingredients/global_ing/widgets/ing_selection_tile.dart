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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: selected ? AppColors.mutedGreen : CupertinoColors.systemGrey5,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color:
              selected
                  ? AppColors.mutedGreen
                  : AppColors.mutedGreen.withOpacity(0.5),
        ),
      ),
      child: ListTile(
        title: Text(
          ingredient.name,
          style: TextStyle(
            color: selected ? AppColors.white : AppColors.button,
            fontSize: 16,
          ),
        ),
        trailing:
            selected
                ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$quantity ${unit.abbreviation.isNotEmpty ? unit.abbreviation : unit.name}',
                        style: const TextStyle(
                          color: CupertinoColors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      CupertinoIcons.checkmark_circle_fill,
                      color: CupertinoColors.white,
                      size: 20,
                    ),
                  ],
                )
                : const Icon(
                  CupertinoIcons.circle,
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
