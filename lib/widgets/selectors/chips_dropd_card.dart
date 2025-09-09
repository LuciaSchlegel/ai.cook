import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/widgets/selectors/dropdown_selector.dart';
import 'package:ai_cook_project/widgets/selectors/grey_card_chips.dart';
import 'package:flutter/material.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/constants/dialog_constants.dart';

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
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: DialogConstants.spacingSM,
        vertical: DialogConstants.spacingXS,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(DialogConstants.radiusXXL),
        border: Border.all(color: AppColors.mutedGreen, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: DialogConstants.spacingXXS,
        vertical: DialogConstants.spacingXXS,
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
            DialogConstants.radiusXL,
          ), // Un poco menor que el exterior
        ),
        padding: const EdgeInsets.all(
          DialogConstants.spacingSM,
        ), // Espacio entre los bordes
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
            const SizedBox(height: DialogConstants.spacingXS),
            GreyCardChips(
              items: chipsItems,
              selectedItems: chipsSelectedItems,
              onSelected: onChipsSelected,
              horizontalPadding: 0,
            ),
          ],
        ),
      ),
    );
  }
}
