// 📁 quantity_unit_picker.dart
import 'package:ai_cook_project/models/unit.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/text_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/constants/dialog_constants.dart';

class QuantityUnitPicker extends StatefulWidget {
  final List<Unit> units;

  const QuantityUnitPicker({super.key, required this.units});

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
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  /// Calculate responsive height for the picker container
  double _calculatePickerContainerHeight(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < DialogConstants.mobileBreakpoint) {
      return 120.0; // Más compacto en móvil
    } else if (screenWidth < DialogConstants.tabletBreakpoint) {
      return 140.0; // Tamaño medio en tablet
    } else {
      return 160.0; // Más generoso en desktop
    }
  }

  /// Calculate responsive padding for the main container
  EdgeInsets _calculateContainerPadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: DialogConstants.adaptiveSpacing(
        context,
        DialogConstants.spacingMD,
      ),
      vertical: DialogConstants.spacingSM,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pickerHeight = _calculatePickerContainerHeight(context);
    final containerPadding = _calculateContainerPadding(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DialogConstants.radiusXL),
        ),
        boxShadow: DialogConstants.dialogShadow,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: containerPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: DialogConstants.adaptiveSpacing(context, 40.0),
                height: DialogConstants.spacingXXS / 2,
                margin: EdgeInsets.only(bottom: DialogConstants.spacingMD),
                decoration: BoxDecoration(
                  color: AppColors.button.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(
                    DialogConstants.radiusXXS,
                  ),
                ),
              ),

              // Quantity section
              Text(
                'Enter Quantity',
                style: TextStyle(
                  decoration: TextDecoration.none,
                  color: AppColors.button,
                  fontFamily: 'Casta',
                  fontSize: DialogConstants.adaptiveSpacing(
                    context,
                    DialogConstants.fontSizeTitle,
                  ),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: DialogConstants.spacingSM),

              CupertinoTextField(
                controller: _quantityController,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(DialogConstants.radiusSM),
                  border: Border.all(
                    color: AppColors.button.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: DialogConstants.spacingSM,
                  vertical: DialogConstants.spacingSM,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                placeholder: 'e.g. 2.5',
                style: TextStyle(
                  color: AppColors.button,
                  fontSize: DialogConstants.adaptiveSpacing(
                    context,
                    DialogConstants.fontSizeXL,
                  ),
                ),
                onChanged: (value) => quantityInput = value,
              ),

              SizedBox(height: DialogConstants.spacingLG),

              // Unit section
              Text(
                'Select Unit',
                style: TextStyle(
                  decoration: TextDecoration.none,
                  color: AppColors.button,
                  fontFamily: 'Casta',
                  fontSize: DialogConstants.adaptiveSpacing(
                    context,
                    DialogConstants.fontSizeTitle,
                  ),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: DialogConstants.spacingSM),

              // Responsive picker container
              Container(
                height: pickerHeight,
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(DialogConstants.radiusSM),
                  border: Border.all(
                    color: AppColors.button.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(DialogConstants.radiusSM),
                  child: ExcludeSemantics(
                    child: CupertinoPicker(
                      magnification: 1.2,
                      squeeze: 1.2,
                      useMagnifier: true,
                      itemExtent: DialogConstants.adaptiveSpacing(
                        context,
                        32.0,
                      ),
                      scrollController: FixedExtentScrollController(
                        initialItem: 0,
                      ),
                      onSelectedItemChanged:
                          (index) => setState(() {
                            selectedUnit = widget.units[index];
                          }),
                      children:
                          widget.units
                              .map(
                                (unit) => Center(
                                  child: Text(
                                    TextUtils.capitalizeFirstLetter(unit.name),
                                    style: TextStyle(
                                      fontSize: DialogConstants.adaptiveSpacing(
                                        context,
                                        DialogConstants.fontSizeXL,
                                      ),
                                      color: AppColors.button.withValues(
                                        alpha: 0.9,
                                      ),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ),
              ),

              SizedBox(height: DialogConstants.spacingLG),

              // Confirm button
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  final parsedQty = double.tryParse(quantityInput.trim());
                  if (parsedQty != null && parsedQty > 0) {
                    Navigator.pop(context, (parsedQty, selectedUnit));
                  } else {
                    // Show error feedback
                    _showErrorFeedback();
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: DialogConstants.spacingSM,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.mutedGreen,
                    borderRadius: BorderRadius.circular(
                      DialogConstants.radiusMD,
                    ),
                    boxShadow: DialogConstants.lightShadow,
                  ),
                  child: Text(
                    'Confirm',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: DialogConstants.adaptiveSpacing(
                        context,
                        DialogConstants.fontSizeXL,
                      ),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorFeedback() {
    // Simple haptic feedback and visual indication
    // You could also show a toast or highlight the text field
    _quantityController.clear();
    _quantityController.text = '';
    setState(() {
      quantityInput = '';
    });
  }
}
