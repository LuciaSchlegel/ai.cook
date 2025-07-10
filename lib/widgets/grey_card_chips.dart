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
    this.horizontalPadding = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
        // Sombra más suave y consistente con tu diseño
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.065,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 10.0,
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
            borderRadius: BorderRadius.circular(24),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final label = items[index];
                final isSelected = label == selectedItem;

                return Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 10 : 0,
                    right: 10,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(22),
                        onTap: () => onSelected(label),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            color:
                                isSelected
                                    ? AppColors.mutedGreen
                                    : Colors.grey.withOpacity(0.08),
                            // Sombra sutil solo para el seleccionado
                            boxShadow:
                                isSelected
                                    ? [
                                      BoxShadow(
                                        color: AppColors.mutedGreen.withOpacity(
                                          index == 0 ? 0.15 : 0.3,
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
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    CupertinoIcons.checkmark,
                                    size: 10,
                                    color: AppColors.mutedGreen,
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Text(
                                label,
                                style: TextStyle(
                                  color:
                                      isSelected
                                          ? AppColors.white
                                          : AppColors.button,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                  fontSize: 14,
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
    );
  }
}
