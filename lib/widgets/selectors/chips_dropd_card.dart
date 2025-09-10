import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/widgets/selectors/dropdown_selector.dart';
import 'package:ai_cook_project/widgets/selectors/grey_card_chips.dart';
import 'package:flutter/material.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';

class ChipsDropdownCard extends StatelessWidget {
  final String dropdownValue;
  final List<String> dropdownItems;
  final ValueChanged<String?> onDropdownChanged;
  final List<String> chipsSelectedItems;
  final List<String> chipsItems;
  final ValueChanged<List<String>> onChipsSelected;
  final String? dropdownTitle;
  final bool
  confirmDropdownOnDone; // New parameter for confirm-on-done behavior

  const ChipsDropdownCard({
    super.key,
    required this.dropdownValue,
    required this.dropdownItems,
    required this.onDropdownChanged,
    required this.chipsSelectedItems,
    required this.chipsItems,
    required this.onChipsSelected,
    this.dropdownTitle,
    this.confirmDropdownOnDone = false, // Default to old behavior
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return ResponsiveContainer(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.borderRadius(
                  context,
                  ResponsiveBorderRadius.xxxl,
                ),
              ),
              border: Border.all(color: AppColors.mutedGreen, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.sm,
                  ),
                  offset: Offset(
                    0,
                    ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
                  ),
                  spreadRadius: 0,
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.spacing(
                context,
                ResponsiveSpacing.xs,
              ),
              vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.mutedGreen.withValues(
                    alpha: 0.5,
                  ), // Borde interno más suave
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.borderRadius(
                    context,
                    ResponsiveBorderRadius.xxl,
                  ),
                ), // Un poco menor que el exterior
              ),
              padding: EdgeInsets.all(
                ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownSelector(
                    value: dropdownValue,
                    items: dropdownItems,
                    onChanged: onDropdownChanged,
                    title: dropdownTitle,
                    confirmOnDone: confirmDropdownOnDone,
                  ),
                  const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.sm),
                  GreyCardChips(
                    items: chipsItems,
                    selectedItems: chipsSelectedItems,
                    onSelected: onChipsSelected,
                    horizontalPadding: ResponsiveSpacing.xxs,
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
