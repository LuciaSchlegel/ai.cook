// 📁 ingredient_selection_tile.dart
import 'package:ai_cook_project/dialogs/ingredients/global_ing/add/widgets/picker.dart';
import 'package:ai_cook_project/models/ingredient_model.dart';
import 'package:ai_cook_project/models/unit.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IngredientSelectionTile extends StatelessWidget {
  final Ingredient ingredient;
  final bool selected;
  final int quantity;
  final Unit unit;
  final List<Unit> units;
  final void Function(int quantity, Unit unit) onConfirm;
  final VoidCallback onDeselect;
  final bool disabled;

  const IngredientSelectionTile({
    super.key,
    required this.ingredient,
    required this.selected,
    required this.quantity,
    required this.unit,
    required this.units,
    required this.onConfirm,
    required this.onDeselect,
    this.disabled = false,
  });

  Widget _getCategoryIcon() {
    final categoryName = ingredient.category?.name.toLowerCase() ?? '';
    String assetPath;
    switch (categoryName) {
      case 'fruits':
        assetPath = 'assets/icons/cherries.svg';
        break;
      case 'vegetables':
        assetPath = 'assets/icons/carrot.svg';
        break;
      case 'meat':
        assetPath = 'assets/icons/cow.svg';
        break;
      case 'fish':
        assetPath = 'assets/icons/fish.svg';
        break;
      case 'grain':
        assetPath = 'assets/icons/grains.svg';
        break;
      case 'dairies':
        assetPath = 'assets/icons/cheese.svg';
        break;
      case 'groceries':
        assetPath = 'assets/icons/tote-simple.svg';
        break;
      default:
        assetPath = 'assets/icons/tote-simple.svg';
    }
    return SvgPicture.asset(
      assetPath,
      width: 22,
      height: 22,
      color: AppColors.mutedGreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                selected
                    ? AppColors.mutedGreen
                    : AppColors.mutedGreen.withOpacity(0.18),
            width: selected ? 1.5 : 1.1,
          ),
          boxShadow: [
            if (selected)
              BoxShadow(
                color: AppColors.mutedGreen.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          child: Row(
            children: [
              // Icono de categoría
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.mutedGreen.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(child: _getCategoryIcon()),
              ),
              const SizedBox(width: 16),
              // Nombre y categoría
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ingredient.name,
                      style: const TextStyle(
                        color: AppColors.button,
                        fontFamily: 'Casta',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      ingredient.category?.name ?? '',
                      style: TextStyle(
                        color: AppColors.mutedGreen.withOpacity(0.85),
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              // Cantidad y unidad (si está seleccionado)
              if (selected)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    '$quantity ${unit.abbreviation}',
                    style: const TextStyle(
                      color: AppColors.mutedGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              // Botón de acción
              GestureDetector(
                onTap:
                    disabled
                        ? null
                        : () async {
                          if (selected) {
                            onDeselect();
                          } else {
                            final result =
                                await showCupertinoModalPopup<(int, Unit)?>(
                                  context: context,
                                  builder:
                                      (_) => QuantityUnitPicker(units: units),
                                );
                            if (result != null) {
                              final (qty, unit) = result;
                              onConfirm(qty, unit);
                            }
                          }
                        },
                child: Icon(
                  selected
                      ? CupertinoIcons.checkmark_alt_circle_fill
                      : CupertinoIcons.add_circled,
                  color:
                      disabled
                          ? AppColors.button.withOpacity(0.3)
                          : AppColors.mutedGreen,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
