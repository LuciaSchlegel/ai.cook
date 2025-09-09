import 'package:ai_cook_project/dialogs/ai_recommendations/constants/dialog_constants.dart';
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

  void _showDropdownMenu(BuildContext context) {
    // Early return if disabled or no items
    if (!isEnabled || items.isEmpty) return;

    final overlayContext =
        Navigator.of(context, rootNavigator: true).overlay!.context;
    final int initialItem = items.indexOf(value);

    // Calculate responsive modal height - matches GenericPickerModal
    final double pickerHeight = _calculatePickerHeight(context);

    // Track pending selection for confirm-on-done behavior
    String pendingSelection = value;

    showCupertinoModalPopup<void>(
      context: overlayContext,
      barrierDismissible: true,
      semanticsDismissible: true,
      builder:
          (BuildContext context) => Container(
            height: pickerHeight,
            padding: const EdgeInsets.symmetric(
              vertical: DialogConstants.spacingXXS,
            ),
            color: CupertinoColors.systemBackground.resolveFrom(context),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  // Header with Cancel/Done buttons - matches GenericPickerModal
                  SizedBox(
                    height: DialogConstants.adaptiveSpacing(context, 44.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Cancel button
                        CupertinoButton(
                          padding: const EdgeInsets.only(
                            left: DialogConstants.spacingSM,
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: AppColors.mutedGreen),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),

                        // Optional title
                        if (title != null)
                          Expanded(
                            child: Text(
                              title!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: DialogConstants.fontSizeMD + 1,
                                fontWeight: FontWeight.w600,
                                color: AppColors.button,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),

                        // Done button
                        CupertinoButton(
                          padding: const EdgeInsets.only(
                            right: DialogConstants.spacingSM,
                          ),
                          child: const Text(
                            'Done',
                            style: TextStyle(
                              color: AppColors.mutedGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () {
                            // Apply selection based on behavior mode
                            if (confirmOnDone) {
                              onChanged(pendingSelection);
                            }
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                  // Picker content - matches GenericPickerModal exactly
                  Expanded(
                    child: CupertinoPicker(
                      magnification: 1.22,
                      squeeze: 1.2,
                      useMagnifier: true,
                      itemExtent: DialogConstants.adaptiveSpacing(
                        context,
                        32.0,
                      ),
                      scrollController: FixedExtentScrollController(
                        initialItem: initialItem != -1 ? initialItem : 0,
                      ),
                      onSelectedItemChanged: (int selectedItem) {
                        if (confirmOnDone) {
                          // Store pending selection for confirm-on-done behavior
                          pendingSelection = items[selectedItem];
                        } else {
                          // Immediate behavior (backward compatibility)
                          onChanged(items[selectedItem]);
                        }
                      },
                      children:
                          items
                              .map(
                                (item) => Center(
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      fontSize: DialogConstants.adaptiveSpacing(
                                        context,
                                        20.0,
                                      ),
                                      color: AppColors.button,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  /// Calculate responsive height based on screen size - matches GenericPickerModal
  double _calculatePickerHeight(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    // Responsive height calculation - same as GenericPickerModal
    if (screenWidth < DialogConstants.mobileBreakpoint) {
      // Mobile: más compacto
      return (screenHeight * 0.3).clamp(200.0, 250.0);
    } else if (screenWidth < DialogConstants.tabletBreakpoint) {
      // Tablet: tamaño medio
      return (screenHeight * 0.25).clamp(220.0, 280.0);
    } else {
      // Desktop: más generoso
      return (screenHeight * 0.2).clamp(240.0, 320.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = !isEnabled || items.isEmpty;
    final effectiveSemanticLabel =
        semanticLabel ??
        (title != null ? '$title: $value' : 'Dropdown selector: $value');

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
              minHeight: DialogConstants.adaptiveSpacing(context, 48.0),
            ),
            decoration: BoxDecoration(
              color:
                  isDisabled
                      ? CupertinoColors.systemGrey6
                      : CupertinoColors.white,
              borderRadius: BorderRadius.circular(DialogConstants.radiusLG),
              border: Border.all(
                color:
                    isDisabled
                        ? AppColors.button.withValues(alpha: 0.1)
                        : AppColors.button.withValues(alpha: 0.2),
              ),
              boxShadow: isDisabled ? null : DialogConstants.lightShadow,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: DialogConstants.spacingSM,
              vertical: DialogConstants.spacingXS,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      color:
                          isDisabled
                              ? AppColors.button.withValues(alpha: 0.4)
                              : AppColors.button,
                      fontSize: DialogConstants.fontSizeMD,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  CupertinoIcons.chevron_down,
                  color:
                      isDisabled
                          ? AppColors.button.withValues(alpha: 0.3)
                          : AppColors.button,
                  size: DialogConstants.iconSizeMD,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
