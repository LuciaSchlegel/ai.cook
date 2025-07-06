import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';

class GreyCardChips extends StatelessWidget {
  final List<String> items;
  final String selectedItem;
  final void Function(String) onSelected;
  final double horizontalPadding;

  const GreyCardChips({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onSelected,
    this.horizontalPadding = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        itemBuilder: (context, index) {
          final label = items[index];
          final isSelected = label == selectedItem;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (_) => onSelected(label),
              backgroundColor: CupertinoColors.systemGrey5,
              selectedColor: AppColors.mutedGreen,
              checkmarkColor: AppColors.white,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.white : AppColors.button,
                fontWeight: FontWeight.w500,
              ),
              shape: StadiumBorder(
                side: BorderSide(
                  color:
                      isSelected
                          ? AppColors.mutedGreen
                          : CupertinoColors.systemGrey4,
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          );
        },
      ),
    );
  }
}
