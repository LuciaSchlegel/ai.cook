// 📁 quantity_unit_picker.dart
import 'package:ai_cook_project/models/unit.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/text_utils.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

/// Shows the quantity unit picker with responsive design
/// - iPhone: Modal bottom sheet
/// - iPad: Centered popup dialog
///
/// Usage:
/// ```dart
/// final result = await showQuantityUnitPicker(
///   context: context,
///   units: availableUnits,
/// );
/// if (result != null) {
///   final (quantity, unit) = result;
///   ('Selected: $quantity ${unit.name}');
/// }
/// ```
Future<(double, Unit)?> showQuantityUnitPicker({
  required BuildContext context,
  required List<Unit> units,
}) {
  final deviceType = ResponsiveUtils.getDeviceType(context);
  ('🔍 Device type detected: $deviceType'); // Debug

  return deviceType == DeviceType.iPhone
      ? _showAsBottomSheet(context, units)
      : _showAsPopup(context, units);
}

/// Shows picker as modal bottom sheet (iPhone)
Future<(double, Unit)?> _showAsBottomSheet(
  BuildContext context,
  List<Unit> units,
) {
  ('📱 Showing as bottom sheet for iPhone'); // Debug
  return showCupertinoModalPopup<(double, Unit)?>(
    context: context,
    builder: (context) => QuantityUnitPicker(units: units),
  );
}

/// Shows picker as centered popup (iPad)
Future<(double, Unit)?> _showAsPopup(BuildContext context, List<Unit> units) {
  ('📱 Showing as popup dialog for iPad'); // Debug
  return showCupertinoDialog<(double, Unit)?>(
    context: context,
    barrierDismissible: true,
    builder:
        (context) => ResponsiveBuilder(
          builder: (context, deviceType) {
            final maxWidth = switch (deviceType) {
              DeviceType.iPhone => 350.0, // Shouldn't happen but just in case
              DeviceType.iPadMini => 400.0,
              DeviceType.iPadPro => 450.0,
            };

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: QuantityUnitPicker(
                  units: units,
                  isPopup: true, // Tell the picker it's in popup mode
                ),
              ),
            );
          },
        ),
  );
}

class QuantityUnitPicker extends StatefulWidget {
  final List<Unit> units;
  final bool isPopup;

  const QuantityUnitPicker({
    super.key,
    required this.units,
    this.isPopup = false,
  });

  @override
  State<QuantityUnitPicker> createState() => _QuantityUnitPickerState();
}

class _QuantityUnitPickerState extends State<QuantityUnitPicker> {
  String quantityInput = '';
  late Unit selectedUnit;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    selectedUnit = widget.units.first;
    _quantityController = TextEditingController(text: quantityInput);
    // Listen to text changes for real-time validation
    _quantityController.addListener(_onQuantityChanged);
  }

  void _onQuantityChanged() {
    setState(() {
      quantityInput = _quantityController.text;
    });
  }

  bool get _isQuantityValid {
    final trimmed = quantityInput.trim();
    if (trimmed.isEmpty) return false;
    final parsed = double.tryParse(trimmed);
    return parsed != null && parsed > 0;
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showDragHandle =
        !widget.isPopup; // Only show drag handle for bottom sheet

    // Use different container approach for popup vs bottom sheet
    if (widget.isPopup) {
      return Container(
        padding: ResponsiveUtils.padding(context, ResponsiveSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.button.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _buildContent(context, showDragHandle),
        ),
      );
    }

    // Bottom sheet mode (iPhone)
    return ResponsiveContainer(
      padding: ResponsiveSpacing.lg,
      borderRadius: ResponsiveBorderRadius.xl,
      backgroundColor: AppColors.white,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _buildContent(context, showDragHandle),
        ),
      ),
    );
  }

  List<Widget> _buildContent(BuildContext context, bool showDragHandle) {
    return [
      // Drag handle (only for bottom sheet)
      if (showDragHandle)
        Container(
          width: ResponsiveUtils.spacing(context, ResponsiveSpacing.xl),
          height: ResponsiveUtils.spacing(context, ResponsiveSpacing.xxs),
          margin: EdgeInsets.only(
            bottom: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
          ),
          decoration: BoxDecoration(
            color: AppColors.button.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.sm),
            ),
          ),
        ),

      // Quantity section
      ResponsiveText(
        'Enter Quantity',
        fontSize: ResponsiveFontSize.xxl,
        fontFamily: 'Casta',
        decoration: TextDecoration.none,
        fontWeight: FontWeight.bold,
        color: AppColors.button,
        letterSpacing: 0.5,
      ),
      ResponsiveSpacingWidget.vertical(ResponsiveSpacing.sm),

      Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
        ),
        child: CupertinoTextField(
          controller: _quantityController,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.sm),
            ),
            border: Border.all(
              color:
                  _isQuantityValid
                      ? AppColors.mutedGreen.withValues(alpha: 0.7)
                      : quantityInput.isNotEmpty
                      ? AppColors.button.withValues(alpha: 0.3) // Invalid input
                      : AppColors.mutedGreen.withValues(alpha: 0.7), // Empty
              width: 0.5,
            ),
          ),
          padding: ResponsiveUtils.padding(context, ResponsiveSpacing.sm),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          placeholder: 'e.g. 2.5',
          style: TextStyle(
            color: AppColors.button,
            fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.lg),
          ),
        ),
      ),

      ResponsiveSpacingWidget.vertical(ResponsiveSpacing.lg),

      // Unit section
      ResponsiveText(
        'Select Unit',
        fontSize: ResponsiveFontSize.xxl,
        decoration: TextDecoration.none,
        fontFamily: 'Casta',
        fontWeight: FontWeight.bold,
        color: AppColors.button,
        letterSpacing: 0.5,
      ),
      ResponsiveSpacingWidget.vertical(ResponsiveSpacing.sm),

      // Responsive picker container
      Container(
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          border: Border.all(
            color: AppColors.mutedGreen.withValues(alpha: 0.7),
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.sm),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.sm),
          ),
          child: SizedBox(
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.xxl) * 4,
            child: ExcludeSemantics(
              child: CupertinoPicker(
                magnification: 1.1,
                squeeze: 1.1,
                useMagnifier: true,
                itemExtent: ResponsiveUtils.spacing(
                  context,
                  ResponsiveSpacing.xl,
                ),
                scrollController: FixedExtentScrollController(initialItem: 0),
                onSelectedItemChanged:
                    (index) => setState(() {
                      selectedUnit = widget.units[index];
                    }),
                children:
                    widget.units
                        .map(
                          (unit) => Center(
                            child: ResponsiveText(
                              TextUtils.capitalizeFirstLetter(unit.name),
                              fontSize: ResponsiveFontSize.lg,
                              color: AppColors.button.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
          ),
        ),
      ),

      ResponsiveSpacingWidget.vertical(ResponsiveSpacing.lg),

      // Confirm button
      CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed:
            _isQuantityValid
                ? () {
                  final parsedQty = double.tryParse(quantityInput.trim())!;
                  Navigator.pop(context, (parsedQty, selectedUnit));
                }
                : null, // Disabled when invalid
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          ),
          decoration: BoxDecoration(
            color:
                _isQuantityValid
                    ? AppColors.mutedGreen
                    : AppColors.button.withValues(alpha: 0.3), // Disabled color
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.md),
            ),
            boxShadow:
                _isQuantityValid
                    ? [
                      BoxShadow(
                        color: AppColors.mutedGreen.withValues(alpha: 0.3),
                        blurRadius: ResponsiveUtils.spacing(
                          context,
                          ResponsiveSpacing.xs,
                        ),
                        offset: Offset(
                          0,
                          ResponsiveUtils.spacing(
                            context,
                            ResponsiveSpacing.xxs,
                          ),
                        ),
                      ),
                    ]
                    : [], // No shadow when disabled
          ),
          child: ResponsiveText(
            'Confirm',
            fontSize: ResponsiveFontSize.lg,
            fontWeight: FontWeight.w600,
            color:
                _isQuantityValid
                    ? AppColors.white
                    : AppColors.white.withValues(
                      alpha: 0.6,
                    ), // Dimmed text when disabled
            letterSpacing: 0.5,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ];
  }
}
