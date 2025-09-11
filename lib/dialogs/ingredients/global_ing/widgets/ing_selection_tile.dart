// 📁 ingredient_selection_tile.dart
import 'package:ai_cook_project/dialogs/ingredients/global_ing/add/widgets/picker.dart';
import 'package:ai_cook_project/models/ingredient_model.dart';
import 'package:ai_cook_project/models/unit.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';

class IngredientSelectionTile extends StatelessWidget {
  final Ingredient ingredient;
  final bool selected;
  final double quantity;
  final Unit unit;
  final List<Unit> units;
  final void Function(double quantity, Unit unit) onConfirm;
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
    return ResponsiveIcon(
      null,
      SvgAssetLoader(assetPath),
      size: ResponsiveIconSize.lg,
      color: AppColors.mutedGreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return Opacity(
          opacity: disabled ? 0.5 : 1.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: ResponsiveUtils.padding(context, ResponsiveSpacing.xs),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.borderRadius(
                  context,
                  ResponsiveBorderRadius.xl,
                ),
              ),
              border: Border.all(
                color:
                    selected
                        ? AppColors.mutedGreen
                        : AppColors.mutedGreen.withValues(alpha: 0.18),
                width: selected ? 1.5 : 1.1,
              ),
              boxShadow: [
                if (selected)
                  BoxShadow(
                    color: AppColors.mutedGreen.withValues(alpha: 0.08),
                    blurRadius: ResponsiveUtils.spacing(
                      context,
                      ResponsiveSpacing.xs,
                    ),
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Padding(
              padding: ResponsiveUtils.padding(context, ResponsiveSpacing.sm),
              child: Row(
                children: [
                  // Icono de categoría
                  Container(
                    width: ResponsiveUtils.spacing(
                      context,
                      ResponsiveSpacing.xxl,
                    ),
                    height: ResponsiveUtils.spacing(
                      context,
                      ResponsiveSpacing.xxl,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.mutedGreen.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.borderRadius(
                          context,
                          ResponsiveBorderRadius.lg,
                        ),
                      ),
                    ),
                    child: Center(child: _getCategoryIcon()),
                  ),
                  const ResponsiveSpacingWidget.horizontal(
                    ResponsiveSpacing.md,
                  ),
                  // Nombre y categoría
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ResponsiveText(
                          ingredient.name,
                          color: AppColors.button,
                          fontFamily: 'Casta',
                          fontSize: ResponsiveFontSize.xl,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                        const ResponsiveSpacingWidget.vertical(
                          ResponsiveSpacing.xxs,
                        ),
                        ResponsiveText(
                          ingredient.category?.name ?? '',
                          color: AppColors.mutedGreen.withValues(alpha: 0.85),
                          fontSize: ResponsiveFontSize.sm,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                  // Cantidad y unidad (si está seleccionado)
                  if (selected)
                    Padding(
                      padding: EdgeInsets.only(
                        right: ResponsiveUtils.spacing(
                          context,
                          ResponsiveSpacing.sm,
                        ),
                      ),
                      child: ResponsiveText(
                        '$quantity ${unit.abbreviation}',
                        color: AppColors.mutedGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: ResponsiveFontSize.sm,
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
                                final result = await showQuantityUnitPicker(
                                  context: context,
                                  units: units,
                                );
                                if (result != null) {
                                  final (qty, unit) = result;
                                  onConfirm(qty.toDouble(), unit);
                                }
                              }
                            },
                    child: ResponsiveIcon(
                      selected
                          ? CupertinoIcons.checkmark_alt_circle_fill
                          : CupertinoIcons.add_circled,
                      null,
                      color:
                          disabled
                              ? AppColors.button.withValues(alpha: 0.3)
                              : AppColors.mutedGreen,
                      size: ResponsiveIconSize.lg,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
