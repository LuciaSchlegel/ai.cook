import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:flutter/cupertino.dart';

class AppBottomSheet {
  /// Shows a CupertinoPicker-based selection modal.
  /// Returns the selected item, or null if cancelled.
  static Future<T?> showPicker<T>({
    required BuildContext context,
    required List<T> items,
    required T selectedItem,
    required String Function(T) displayText,
    bool Function(T, T)? areEqual,
    String? title,
    bool immediateCallback = false,
    void Function(T)? onItemChanged,
  }) {
    return showCupertinoModalPopup<T>(
      context: context,
      builder:
          (ctx) => _PickerModal<T>(
            items: items,
            selectedItem: selectedItem,
            displayText: displayText,
            areEqual: areEqual,
            title: title,
            immediateCallback: immediateCallback,
            onItemChanged: onItemChanged,
            parentContext: context,
          ),
    );
  }

  /// Shows a CupertinoDatePicker modal.
  /// Returns the selected date, or null if cancelled.
  static Future<DateTime?> showDatePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? maximumDate,
    CupertinoDatePickerMode mode = CupertinoDatePickerMode.date,
  }) {
    return showCupertinoModalPopup<DateTime>(
      context: context,
      builder:
          (ctx) => _DatePickerModal(
            initialDate: initialDate,
            maximumDate: maximumDate,
            mode: mode,
            parentContext: context,
          ),
    );
  }
}

// ── Responsive height ──────────────────────────────────────────────────────

double _pickerHeight(BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;
  final deviceType = ResponsiveUtils.getDeviceType(context);
  return switch (deviceType) {
    DeviceType.iPhone => (screenHeight * 0.3).clamp(200.0, 250.0),
    DeviceType.iPadMini => (screenHeight * 0.25).clamp(220.0, 280.0),
    DeviceType.iPadPro => (screenHeight * 0.2).clamp(240.0, 320.0),
  };
}

// ── Shared header ──────────────────────────────────────────────────────────

Widget _buildHeader(
  BuildContext context, {
  String? title,
  required VoidCallback onCancel,
  required VoidCallback onDone,
}) {
  return SizedBox(
    height: ResponsiveUtils.spacing(context, ResponsiveSpacing.xxl),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CupertinoButton(
          padding: EdgeInsets.only(
            left: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          ),
          onPressed: onCancel,
          child: Text(
            'Cancel',
            style: AppTextStyles.inter(
              fontSize: ResponsiveUtils.fontSize(
                context,
                ResponsiveFontSize.md,
              ),
              fontWeight: AppFontWeights.medium,
              color: AppColors.button.withValues(alpha: 0.5),
              letterSpacing: 0.2,
            ),
          ),
        ),
        if (title != null)
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.inter(
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  ResponsiveFontSize.lg,
                ),
                fontWeight: AppFontWeights.bold,
                color: AppColors.button,
                decoration: TextDecoration.none,
                letterSpacing: 0.2,
              ),
            ),
          ),
        CupertinoButton(
          padding: EdgeInsets.only(
            right: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          ),
          onPressed: onDone,
          child: Text(
            'Done',
            style: AppTextStyles.inter(
              fontSize: ResponsiveUtils.fontSize(
                context,
                ResponsiveFontSize.md,
              ),
              fontWeight: AppFontWeights.semiBold,
              color: AppColors.button,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    ),
  );
}

// ── CupertinoPicker modal ──────────────────────────────────────────────────

class _PickerModal<T> extends StatefulWidget {
  final List<T> items;
  final T selectedItem;
  final String Function(T) displayText;
  final bool Function(T, T)? areEqual;
  final String? title;
  final bool immediateCallback;
  final void Function(T)? onItemChanged;
  final BuildContext parentContext;

  const _PickerModal({
    required this.items,
    required this.selectedItem,
    required this.displayText,
    required this.parentContext,
    this.areEqual,
    this.title,
    this.immediateCallback = false,
    this.onItemChanged,
  });

  @override
  State<_PickerModal<T>> createState() => _PickerModalState<T>();
}

class _PickerModalState<T> extends State<_PickerModal<T>> {
  late T _tempSelected;
  late FixedExtentScrollController _controller;

  bool _equals(T a, T b) =>
      widget.areEqual != null ? widget.areEqual!(a, b) : a == b;

  @override
  void initState() {
    super.initState();
    _tempSelected = widget.selectedItem;
    final idx = widget.items.indexWhere((i) => _equals(i, widget.selectedItem));
    _controller = FixedExtentScrollController(initialItem: idx >= 0 ? idx : 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = _pickerHeight(widget.parentContext);

    return Container(
      height: height,
      padding: ResponsiveUtils.verticalPadding(
        widget.parentContext,
        ResponsiveSpacing.xxs,
      ),
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildHeader(
              context,
              title: widget.title,
              onCancel: () => Navigator.of(context).pop(),
              onDone: () {
                if (widget.immediateCallback) {
                  widget.onItemChanged?.call(_tempSelected);
                }
                Navigator.of(context).pop(_tempSelected);
              },
            ),
            Expanded(
              child: ExcludeSemantics(
                child: CupertinoPicker(
                  magnification: 1.22,
                  squeeze: 1.2,
                  useMagnifier: true,
                  itemExtent: ResponsiveUtils.spacing(
                    widget.parentContext,
                    ResponsiveSpacing.xl,
                  ),
                  scrollController: _controller,
                  onSelectedItemChanged: (index) {
                    if (index < 0 || index >= widget.items.length) return;
                    setState(() => _tempSelected = widget.items[index]);
                    if (widget.immediateCallback) {
                      widget.onItemChanged?.call(widget.items[index]);
                    }
                  },
                  children:
                      widget.items
                          .map(
                            (item) => Center(
                              child: ResponsiveText(
                                widget.displayText(item),
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
}

// ── CupertinoDatePicker modal ──────────────────────────────────────────────

class _DatePickerModal extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? maximumDate;
  final CupertinoDatePickerMode mode;
  final BuildContext parentContext;

  const _DatePickerModal({
    required this.parentContext,
    this.initialDate,
    this.maximumDate,
    this.mode = CupertinoDatePickerMode.date,
  });

  @override
  State<_DatePickerModal> createState() => _DatePickerModalState();
}

class _DatePickerModalState extends State<_DatePickerModal> {
  late DateTime _tempDate;

  @override
  void initState() {
    super.initState();
    _tempDate = widget.initialDate ?? DateTime(2000);
  }

  @override
  Widget build(BuildContext context) {
    final height = _pickerHeight(widget.parentContext);

    return Container(
      height: height,
      padding: ResponsiveUtils.verticalPadding(
        widget.parentContext,
        ResponsiveSpacing.xxs,
      ),
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildHeader(
              context,
              onCancel: () => Navigator.of(context).pop(),
              onDone: () => Navigator.of(context).pop(_tempDate),
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: widget.mode,
                initialDateTime: _tempDate,
                maximumDate: widget.maximumDate,
                onDateTimeChanged: (date) => _tempDate = date,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
