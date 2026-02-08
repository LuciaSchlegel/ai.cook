import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/widgets/bottom_sheet/app_bottom_sheet.dart';
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
  final bool confirmOnDone;
  final String? semanticLabel;
  final bool isEnabled;

  const DropdownSelector({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.width,
    this.title,
    this.confirmOnDone = false,
    this.semanticLabel,
    this.isEnabled = true,
  });

  void _showDropdownMenu(BuildContext context) async {
    if (!isEnabled || items.isEmpty) return;

    if (confirmOnDone) {
      final selectedValue = await AppBottomSheet.showPicker<String>(
        context: context,
        items: items,
        selectedItem: value,
        displayText: (item) => item,
        title: title,
      );
      if (selectedValue != null) {
        onChanged(selectedValue);
      }
    } else {
      await AppBottomSheet.showPicker<String>(
        context: context,
        items: items,
        selectedItem: value,
        displayText: (item) => item,
        title: title,
        immediateCallback: true,
        onItemChanged: onChanged,
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
                  boxShadow:
                      isDisabled
                          ? null
                          : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: ResponsiveUtils.spacing(
                                context,
                                ResponsiveSpacing.md,
                              ),
                            ),
                          ],
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
                        fontFamily: 'Inter',
                        value,
                        fontSize: ResponsiveUtils.fontSize(
                          context,
                          ResponsiveFontSize.md,
                        ),
                        fontWeight: AppFontWeights.medium,
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
