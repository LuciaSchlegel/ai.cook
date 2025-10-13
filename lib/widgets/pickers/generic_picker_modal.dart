import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:flutter/cupertino.dart';

/// Generic picker modal that can be used for any type of data
/// Follows the design system and provides responsive behavior
class GenericPickerModal<T> extends StatefulWidget {
  /// List of items to choose from
  final List<T> items;

  /// Currently selected item
  final T selectedItem;

  /// Function to get display text for each item
  final String Function(T) getDisplayText;

  /// Function to compare items for equality
  final bool Function(T, T) areEqual;

  /// Callback when item is selected
  final void Function(T) onSelected;

  /// Optional title for the picker
  final String? title;

  /// Cancel button text (defaults to "Cancel")
  final String cancelText;

  /// Done button text (defaults to "Done")
  final String doneText;

  const GenericPickerModal({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.getDisplayText,
    required this.areEqual,
    required this.onSelected,
    this.title,
    this.cancelText = 'Cancel',
    this.doneText = 'Done',
  });

  @override
  State<GenericPickerModal<T>> createState() => _GenericPickerModalState<T>();
}

class _GenericPickerModalState<T> extends State<GenericPickerModal<T>> {
  late T _tempSelected;
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _tempSelected = widget.selectedItem;

    // Find initial index
    final initialIndex = widget.items.indexWhere(
      (item) => widget.areEqual(item, widget.selectedItem),
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

  /// Calculate responsive height using the responsive system
  double _calculatePickerHeight(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final deviceType = ResponsiveUtils.getDeviceType(context);

    // Use device-specific height calculations
    return switch (deviceType) {
      DeviceType.iPhone => (screenHeight * 0.3).clamp(200.0, 250.0),
      DeviceType.iPadMini => (screenHeight * 0.25).clamp(220.0, 280.0),
      DeviceType.iPadPro => (screenHeight * 0.2).clamp(240.0, 320.0),
    };
  }

  @override
  Widget build(BuildContext context) {
    final pickerHeight = _calculatePickerHeight(context);

    return Container(
      height: pickerHeight,
      padding: ResponsiveUtils.verticalPadding(context, ResponsiveSpacing.xxs),
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Header with title and buttons
            _buildHeader(context),

            // Picker content
            Expanded(
              child: ExcludeSemantics(
                child: CupertinoPicker(
                  magnification: 1.22,
                  squeeze: 1.2,
                  useMagnifier: true,
                  itemExtent: ResponsiveUtils.spacing(
                    context,
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
                                widget.getDisplayText(item),
                                fontSize: ResponsiveUtils.fontSize(
                                  context,
                                  ResponsiveFontSize.md,
                                ),
                                fontFamily: 'Inter',
                                fontWeight: AppFontWeights.regular,
                                letterSpacing: 0.2,
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

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: ResponsiveUtils.spacing(context, ResponsiveSpacing.xxl),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Cancel button
            CupertinoButton(
              padding: EdgeInsets.only(
                left: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
              ),
              child: ResponsiveText(
                widget.cancelText,
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  ResponsiveFontSize.md,
                ),
                color: AppColors.mutedGreen,
                fontFamily: 'Inter',
                fontWeight: AppFontWeights.medium,
                letterSpacing: 0.2,
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
                  fontWeight: AppFontWeights.bold,
                  fontFamily: 'Inter',
                  letterSpacing: 0.2,
                  color: AppColors.button,
                  decoration: TextDecoration.none,
                ),
              ),

            // Done button
            CupertinoButton(
              padding: EdgeInsets.only(
                right: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
              ),
              child: ResponsiveText(
                widget.doneText,
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  ResponsiveFontSize.md,
                ),
                color: AppColors.mutedGreen,
                fontFamily: 'Inter',
                fontWeight: AppFontWeights.medium,
                letterSpacing: 0.2,
              ),
              onPressed: () {
                widget.onSelected(_tempSelected);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Convenience function to show the generic picker modal
Future<T?> showGenericPicker<T>({
  required BuildContext context,
  required List<T> items,
  required T selectedItem,
  required String Function(T) getDisplayText,
  required bool Function(T, T) areEqual,
  String? title,
  String cancelText = 'Cancel',
  String doneText = 'Done',
}) {
  return showCupertinoModalPopup<T>(
    context: context,
    builder:
        (context) => GenericPickerModal<T>(
          items: items,
          selectedItem: selectedItem,
          getDisplayText: getDisplayText,
          areEqual: areEqual,
          onSelected: (item) => Navigator.of(context).pop(item),
          title: title,
          cancelText: cancelText,
          doneText: doneText,
        ),
  );
}
