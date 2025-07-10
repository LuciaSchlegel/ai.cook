import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/widgets/dropdown_selector.dart';
import 'package:ai_cook_project/widgets/grey_card_chips.dart';
import 'package:flutter/material.dart';

class ChipsDropdownCard extends StatelessWidget {
  final String dropdownValue;
  final List<String> dropdownItems;
  final ValueChanged<String?> onDropdownChanged;
  final String chipsSelectedItem;
  final List<String> chipsItems;
  final ValueChanged<String> onChipSelected;
  final String? dropdownTitle;

  const ChipsDropdownCard({
    super.key,
    required this.dropdownValue,
    required this.dropdownItems,
    required this.onDropdownChanged,
    required this.chipsSelectedItem,
    required this.chipsItems,
    required this.onChipSelected,
    this.dropdownTitle,
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
            color: Colors.black.withOpacity(0.06),
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
            color: AppColors.mutedGreen.withOpacity(
              0.5,
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
            ),
            const SizedBox(height: 8),
            GreyCardChips(
              items: chipsItems,
              selectedItem: chipsSelectedItem,
              onSelected: onChipSelected,
              horizontalPadding: 0, // Ya hay padding en el contenedor principal
            ),
          ],
        ),
      ),
    );
  }
}
