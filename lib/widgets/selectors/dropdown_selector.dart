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
      // Use inline picker with confirm-on-done behavior
      final selectedValue = await showCupertinoModalPopup<String>(
        context: context,
        builder:
            (BuildContext modalContext) => _InlineConfirmPicker(
              items: items,
              selectedItem: value,
              title: title,
              context: context,
            ),
      );

      if (selectedValue != null) {
        onChanged(selectedValue);
      }
    } else {
      // Legacy immediate selection behavior
      await showCupertinoModalPopup<void>(
        context: context,
        builder:
            (BuildContext modalContext) => _InlineImmediatePicker(
              items: items,
              selectedItem: value,
              title: title,
              onSelected: onChanged,
              context: context,
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

// Confirm-on-done picker that follows your app's styling
class _InlineConfirmPicker extends StatefulWidget {
  final List<String> items;
  final String selectedItem;
  final String? title;
  final BuildContext context;

  const _InlineConfirmPicker({
    required this.items,
    required this.selectedItem,
    required this.context,
    this.title,
  });

  @override
  State<_InlineConfirmPicker> createState() => _InlineConfirmPickerState();
}

class _InlineConfirmPickerState extends State<_InlineConfirmPicker> {
  late String _tempSelected;
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _tempSelected = widget.selectedItem;

    final initialIndex = widget.items.indexWhere(
      (item) => item == widget.selectedItem,
    );
    _controller = FixedExtentScrollController(
      initialItem: initialIndex >= 0 ? initialIndex : 0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _calculatePickerHeight() {
    final mediaQuery = MediaQuery.of(widget.context);
    final screenHeight = mediaQuery.size.height;
    final deviceType = ResponsiveUtils.getDeviceType(widget.context);

    return switch (deviceType) {
      DeviceType.iPhone => (screenHeight * 0.3).clamp(200.0, 250.0),
      DeviceType.iPadMini => (screenHeight * 0.25).clamp(220.0, 280.0),
      DeviceType.iPadPro => (screenHeight * 0.2).clamp(240.0, 320.0),
    };
  }

  @override
  Widget build(BuildContext context) {
    final pickerHeight = _calculatePickerHeight();

    return Container(
      height: pickerHeight,
      padding: ResponsiveUtils.verticalPadding(
        widget.context,
        ResponsiveSpacing.xxs,
      ),
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Header with title and buttons
            SizedBox(
              height: ResponsiveUtils.spacing(
                widget.context,
                ResponsiveSpacing.xxl,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Cancel button
                  CupertinoButton(
                    padding: EdgeInsets.only(
                      left: ResponsiveUtils.spacing(
                        widget.context,
                        ResponsiveSpacing.sm,
                      ),
                    ),
                    child: ResponsiveText(
                      'Cancel',
                      fontFamily: 'Inter',
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        ResponsiveFontSize.md,
                      ),
                      color: AppColors.mutedGreen,
                    ),
                    onPressed: () => Navigator.of(context).pop(null),
                  ),

                  // Optional title
                  if (widget.title != null)
                    Expanded(
                      child: ResponsiveText(
                        widget.title!,
                        textAlign: TextAlign.center,
                        fontSize: ResponsiveUtils.fontSize(
                          context,
                          ResponsiveFontSize.lg,
                        ),
                        fontWeight: AppFontWeights.medium,
                        fontFamily: 'Inter',
                        color: AppColors.button,
                        decoration: TextDecoration.none,
                      ),
                    ),

                  // Done button
                  CupertinoButton(
                    padding: EdgeInsets.only(
                      right: ResponsiveUtils.spacing(
                        widget.context,
                        ResponsiveSpacing.sm,
                      ),
                    ),
                    child: ResponsiveText(
                      'Done',
                      fontFamily: 'Inter',
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        ResponsiveFontSize.md,
                      ),
                      color: AppColors.mutedGreen,
                      fontWeight: AppFontWeights.medium,
                    ),
                    onPressed: () => Navigator.of(context).pop(_tempSelected),
                  ),
                ],
              ),
            ),

            // Picker content
            Expanded(
              child: ExcludeSemantics(
                child: CupertinoPicker(
                  magnification: 1.22,
                  squeeze: 1.2,
                  useMagnifier: true,
                  itemExtent: ResponsiveUtils.spacing(
                    widget.context,
                    ResponsiveSpacing.xl,
                  ),
                  scrollController: _controller,
                  onSelectedItemChanged: (index) {
                    if (index >= 0 && index < widget.items.length) {
                      setState(() {
                        _tempSelected = widget.items[index];
                      });
                    }
                  },
                  children:
                      widget.items
                          .map(
                            (item) => Center(
                              child: ResponsiveText(
                                item,
                                fontFamily: 'Inter',
                                fontSize: ResponsiveUtils.fontSize(
                                  context,
                                  ResponsiveFontSize.lg,
                                ),
                                color: AppColors.button,
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Immediate selection picker with Done button for consistent UX
class _InlineImmediatePicker extends StatefulWidget {
  final List<String> items;
  final String selectedItem;
  final String? title;
  final Function(String?) onSelected;
  final BuildContext context;

  const _InlineImmediatePicker({
    required this.items,
    required this.selectedItem,
    required this.onSelected,
    required this.context,
    this.title,
  });

  @override
  State<_InlineImmediatePicker> createState() => _InlineImmediatePickerState();
}

class _InlineImmediatePickerState extends State<_InlineImmediatePicker> {
  late String _currentSelection;
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _currentSelection = widget.selectedItem;
    final initialIndex = widget.items.indexWhere(
      (item) => item == widget.selectedItem,
    );
    _controller = FixedExtentScrollController(
      initialItem: initialIndex >= 0 ? initialIndex : 0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _calculatePickerHeight() {
    final mediaQuery = MediaQuery.of(widget.context);
    final screenHeight = mediaQuery.size.height;
    final deviceType = ResponsiveUtils.getDeviceType(widget.context);

    return switch (deviceType) {
      DeviceType.iPhone => (screenHeight * 0.3).clamp(200.0, 250.0),
      DeviceType.iPadMini => (screenHeight * 0.25).clamp(220.0, 280.0),
      DeviceType.iPadPro => (screenHeight * 0.2).clamp(240.0, 320.0),
    };
  }

  @override
  Widget build(BuildContext context) {
    final pickerHeight = _calculatePickerHeight();

    return Container(
      height: pickerHeight,
      padding: ResponsiveUtils.verticalPadding(
        widget.context,
        ResponsiveSpacing.xxs,
      ),
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Header with title and buttons
            SizedBox(
              height: ResponsiveUtils.spacing(
                widget.context,
                ResponsiveSpacing.xxl,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Cancel button
                  CupertinoButton(
                    padding: EdgeInsets.only(
                      left: ResponsiveUtils.spacing(
                        widget.context,
                        ResponsiveSpacing.sm,
                      ),
                    ),
                    child: ResponsiveText(
                      'Cancel',
                      fontFamily: 'Inter',
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        ResponsiveFontSize.md,
                      ),
                      color: AppColors.mutedGreen,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),

                  // Optional title
                  if (widget.title != null)
                    Expanded(
                      child: ResponsiveText(
                        widget.title!,
                        textAlign: TextAlign.center,
                        fontSize: ResponsiveUtils.fontSize(
                          context,
                          ResponsiveFontSize.lg,
                        ),
                        fontWeight: AppFontWeights.medium,
                        fontFamily: 'Inter',
                        color: AppColors.button,
                        decoration: TextDecoration.none,
                      ),
                    ),

                  // Done button
                  CupertinoButton(
                    padding: EdgeInsets.only(
                      right: ResponsiveUtils.spacing(
                        widget.context,
                        ResponsiveSpacing.sm,
                      ),
                    ),
                    child: ResponsiveText(
                      'Done',
                      fontFamily: 'Inter',
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        ResponsiveFontSize.md,
                      ),
                      color: AppColors.mutedGreen,
                      fontWeight: AppFontWeights.medium,
                    ),
                    onPressed: () {
                      widget.onSelected(_currentSelection);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),

            // Picker content
            Expanded(
              child: ExcludeSemantics(
                child: CupertinoPicker(
                  magnification: 1.22,
                  squeeze: 1.2,
                  useMagnifier: true,
                  itemExtent: ResponsiveUtils.spacing(
                    widget.context,
                    ResponsiveSpacing.xl,
                  ),
                  scrollController: _controller,
                  onSelectedItemChanged: (index) {
                    if (index >= 0 && index < widget.items.length) {
                      setState(() {
                        _currentSelection = widget.items[index];
                      });
                      // For immediate mode: call the callback right away for real-time filtering
                      widget.onSelected(widget.items[index]);
                    }
                  },
                  children:
                      widget.items
                          .map(
                            (item) => Center(
                              child: ResponsiveText(
                                item,
                                fontFamily: 'Inter',
                                fontSize: ResponsiveUtils.fontSize(
                                  context,
                                  ResponsiveFontSize.lg,
                                ),
                                color: AppColors.button,
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
