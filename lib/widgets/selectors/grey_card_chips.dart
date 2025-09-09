import 'package:ai_cook_project/dialogs/ai_recommendations/constants/dialog_constants.dart';
import 'package:ai_cook_project/utils/text_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';

class GreyCardChips extends StatelessWidget {
  final List<String> items;
  final List<String> selectedItems;
  final void Function(List<String>) onSelected;
  final double horizontalPadding;
  final double verticalPadding;

  const GreyCardChips({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.onSelected,
    this.horizontalPadding = DialogConstants.spacingSM,
    this.verticalPadding = DialogConstants.spacingXS,
  });

  void _handleChipTap(String label) {
    List<String> newSelectedItems = List.from(selectedItems);

    if (newSelectedItems.contains(label)) {
      // Deselect if already selected
      newSelectedItems.remove(label);
    } else {
      // Select if not selected
      newSelectedItems.add(label);
    }

    onSelected(newSelectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: DialogConstants.spacingXS),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(DialogConstants.radiusLG),
        // Sombra más suave y consistente con tu diseño
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: DialogConstants.radiusSM,
            offset: const Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: DialogConstants.spacingXXS,
          vertical: DialogConstants.spacingXXS,
        ),
        child: Container(
          height: DialogConstants.adaptiveSpacing(context, 80.0),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.black, Colors.black, Colors.transparent],
                stops: [0.0, 0.95, 1.0],
              ).createShader(bounds);
            },
            blendMode: BlendMode.dstIn,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(DialogConstants.radiusMD),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final label = items[index];
                  final isSelected = selectedItems.contains(label);

                  return Padding(
                    padding: EdgeInsets.only(
                      left: DialogConstants.spacingXXS,
                      right: DialogConstants.spacingXXS,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(
                            DialogConstants.radiusLG,
                          ),
                          onTap: () => _handleChipTap(label),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.symmetric(
                              horizontal: DialogConstants.spacingSM,
                              vertical: DialogConstants.spacingXXS,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                DialogConstants.radiusMD,
                              ),
                              color:
                                  isSelected
                                      ? AppColors.background.withValues(
                                        alpha: 0.9,
                                      )
                                      : AppColors.mutedGreen.withValues(
                                        alpha: 0.8,
                                      ),
                              // Sombra sutil solo para el seleccionado
                              boxShadow:
                                  isSelected
                                      ? [
                                        BoxShadow(
                                          color: AppColors.mutedGreen
                                              .withValues(
                                                alpha: index == 0 ? 0.15 : 0.3,
                                              ),
                                          blurRadius: index == 0 ? 4 : 8,
                                          offset: const Offset(0, 2),
                                          spreadRadius: 0,
                                        ),
                                      ]
                                      : null,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Checkmark más sutil
                                if (isSelected) ...[
                                  Container(
                                    width: DialogConstants.iconSizeSM,
                                    height: DialogConstants.iconSizeSM,
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      CupertinoIcons.checkmark,
                                      size: DialogConstants.iconSizeXXS,
                                      color: AppColors.mutedGreen,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: DialogConstants.spacingXXS,
                                  ),
                                ],
                                Text(
                                  TextUtils.capitalizeFirstLetter(label),
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: DialogConstants.fontSizeSM,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
