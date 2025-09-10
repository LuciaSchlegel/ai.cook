import 'package:ai_cook_project/dialogs/ai_recommendations/constants/dialog_constants.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
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
          (BuildContext context) => ResponsiveBuilder(
            builder: (context, deviceType) {
              return Container(
                height: pickerHeight,
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.xs,
                  ),
                ),
                color: CupertinoColors.systemBackground.resolveFrom(context),
                child: SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      // Header with Cancel/Done buttons
                      SizedBox(
                        height:
                            ResponsiveUtils.spacing(
                              context,
                              ResponsiveSpacing.xxl,
                            ) +
                            4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Cancel button
                            CupertinoButton(
                              padding: EdgeInsets.only(
                                left: ResponsiveUtils.spacing(
                                  context,
                                  ResponsiveSpacing.sm,
                                ),
                              ),
                              child: ResponsiveText(
                                'Cancel',
                                fontSize: ResponsiveFontSize.md,
                                color: AppColors.mutedGreen,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),

                            // Optional title
                            if (title != null)
                              Expanded(
                                child: ResponsiveText(
                                  title!,
                                  fontSize: ResponsiveFontSize.lg,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.button,
                                  textAlign: TextAlign.center,
                                  decoration: TextDecoration.none,
                                ),
                              ),

                            // Done button
                            CupertinoButton(
                              padding: EdgeInsets.only(
                                right: ResponsiveUtils.spacing(
                                  context,
                                  ResponsiveSpacing.sm,
                                ),
                              ),
                              child: ResponsiveText(
                                'Done',
                                fontSize: ResponsiveFontSize.md,
                                fontWeight: FontWeight.w600,
                                color: AppColors.mutedGreen,
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
                      // Picker content with responsive sizing
                      Expanded(
                        child: CupertinoPicker(
                          magnification: 1.22,
                          squeeze: 1.2,
                          useMagnifier: true,
                          itemExtent: ResponsiveUtils.spacing(
                            context,
                            ResponsiveSpacing.xl,
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
                                      child: ResponsiveText(
                                        item,
                                        fontSize: ResponsiveFontSize.lg,
                                        color: AppColors.button,
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }

  /// Calculate responsive height based on device type using new responsive system
  double _calculatePickerHeight(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final deviceType = ResponsiveUtils.getDeviceType(context);

    return switch (deviceType) {
      DeviceType.iPhone => (screenHeight * 0.3).clamp(200.0, 250.0),
      DeviceType.iPadMini => (screenHeight * 0.25).clamp(220.0, 280.0),
      DeviceType.iPadPro => (screenHeight * 0.2).clamp(240.0, 320.0),
    };
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
