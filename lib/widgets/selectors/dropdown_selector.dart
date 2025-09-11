import 'package:ai_cook_project/dialogs/ai_recommendations/constants/dialog_constants.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:ai_cook_project/widgets/pickers/generic_picker_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';

class DropdownSelector extends StatelessWidget {
  final String value;
  final List<String> items;
  final Function(String?) onChanged;
  final double? width;
  final String? title;
  final bool confirmOnDone; // New parameter to control behavior
  final String? semanticLabel; // For accessibility
  final bool isEnabled; // For disabled state

  const DropdownSelector({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.width,
    this.title,
    this.confirmOnDone =
        false, // Default to old behavior for backward compatibility
    this.semanticLabel,
    this.isEnabled = true,
  });

  void _showDropdownMenu(BuildContext context) async {
    // Early return if disabled or no items
    if (!isEnabled || items.isEmpty) return;

    final overlayContext =
        Navigator.of(context, rootNavigator: true).overlay!.context;

    if (confirmOnDone) {
      // Use GenericPickerModal with confirm-on-done behavior
      final selectedValue = await showGenericPicker<String>(
        context: overlayContext,
        items: items,
        selectedItem: value,
        getDisplayText: (item) => item,
        areEqual: (a, b) => a == b,
        title: title,
        cancelText: 'Cancel',
        doneText: 'Done',
      );

      // Only call onChanged if user selected something (didn't cancel)
      if (selectedValue != null) {
        onChanged(selectedValue);
      }
    } else {
      // Use GenericPickerModal with immediate behavior (backward compatibility)
      await showCupertinoModalPopup<void>(
        context: overlayContext,
        builder:
            (context) => GenericPickerModal<String>(
              items: items,
              selectedItem: value,
              getDisplayText: (item) => item,
              areEqual: (a, b) => a == b,
              onSelected: (selectedItem) {
                // Immediate behavior - call onChanged immediately
                onChanged(selectedItem);
              },
              title: title,
              cancelText: 'Cancel',
              doneText: 'Done',
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = !isEnabled || items.isEmpty;
    final effectiveSemanticLabel =
        semanticLabel ??
        (title != null ? '$title: $value' : 'Dropdown selector: $value');

    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return Semantics(
          label: effectiveSemanticLabel,
          hint: isDisabled ? 'Dropdown is disabled' : 'Tap to select an option',
          button: true,
          enabled: !isDisabled,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: isDisabled ? null : () => _showDropdownMenu(context),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: width,
                constraints: BoxConstraints(
                  minHeight:
                      ResponsiveUtils.spacing(context, ResponsiveSpacing.xxl) +
                      8,
                ),
                decoration: BoxDecoration(
                  color:
                      isDisabled
                          ? CupertinoColors.systemGrey6
                          : CupertinoColors.white,
                  borderRadius: BorderRadius.circular(
                    ResponsiveUtils.borderRadius(
                      context,
                      ResponsiveBorderRadius.lg,
                    ),
                  ),
                  border: Border.all(
                    color:
                        isDisabled
                            ? AppColors.button.withValues(alpha: 0.1)
                            : AppColors.button.withValues(alpha: 0.2),
                  ),
                  boxShadow: isDisabled ? null : DialogConstants.lightShadow,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.sm,
                  ),
                  vertical: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.xs,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ResponsiveText(
                        value,
                        fontSize: ResponsiveFontSize.md,
                        fontWeight: FontWeight.w500,
                        color:
                            isDisabled
                                ? AppColors.button.withValues(alpha: 0.4)
                                : AppColors.button,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ResponsiveIcon(
                      CupertinoIcons.chevron_down,
                      null,
                      size: ResponsiveIconSize.md,
                      color:
                          isDisabled
                              ? AppColors.button.withValues(alpha: 0.3)
                              : AppColors.button,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
