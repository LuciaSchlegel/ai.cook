import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/widgets/selectors/dropdown_selector.dart';
import 'package:ai_cook_project/widgets/selectors/grey_card_chips.dart';
import 'package:flutter/material.dart';

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
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
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
        horizontal: MediaQuery.of(context).size.width * 0.02,
        vertical: MediaQuery.of(context).size.height * 0.01,
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
            24,
          ), // Un poco menor que el exterior
        ),
        padding: const EdgeInsets.all(10), // Espacio entre los bordes
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
            const SizedBox(height: 8),
            GreyCardChips(
              items: chipsItems,
              selectedItems: chipsSelectedItems,
              onSelected: onChipsSelected,
              horizontalPadding: 0, // Ya hay padding en el contenedor principal
            ),
          ],
        ),
      ),
    );
  }
}
