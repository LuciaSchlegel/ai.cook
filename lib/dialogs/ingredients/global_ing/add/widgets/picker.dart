// 📁 quantity_unit_picker.dart
import 'package:ai_cook_project/models/unit.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:flutter/cupertino.dart';

class QuantityUnitPicker extends StatefulWidget {
  final List<Unit> units;

  const QuantityUnitPicker({super.key, required this.units});

  @override
  State<QuantityUnitPicker> createState() => _QuantityUnitPickerState();
}

class _QuantityUnitPickerState extends State<QuantityUnitPicker> {
  String quantityInput = '1';
  late Unit selectedUnit;

  @override
  void initState() {
    super.initState();
    selectedUnit = widget.units.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(24)),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: AppColors.button.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Text(
            'Enter Quantity',
            style: TextStyle(
              decoration: TextDecoration.none,
              color: AppColors.button,
              fontFamily: 'Casta',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          CupertinoTextField(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.button.withOpacity(0.2)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            keyboardType: TextInputType.number,
            placeholder: 'e.g. 2',
            style: const TextStyle(color: AppColors.button, fontSize: 16),
            onChanged: (value) => quantityInput = value,
          ),
          const SizedBox(height: 32),
          const Text(
            'Select Unit',
            style: TextStyle(
              decoration: TextDecoration.none,
              color: AppColors.button,
              fontFamily: 'Casta',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.button.withOpacity(0.2)),
            ),
            child: ExcludeSemantics(
              child: CupertinoPicker(
                itemExtent: 32.0,
                scrollController: FixedExtentScrollController(initialItem: 0),
                onSelectedItemChanged:
                    (index) => setState(() {
                      selectedUnit = widget.units[index];
                    }),
                children:
                    widget.units
                        .map((unit) => Center(child: Text(unit.name)))
                        .toList(),
              ),
            ),
          ),
          const SizedBox(height: 32),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              final parsedQty = double.tryParse(quantityInput);
              if (parsedQty != null && parsedQty > 0) {
                Navigator.pop(context, (parsedQty, selectedUnit));
              } else {
                // optional: mostrar mensaje de error
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.mutedGreen,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Text(
                'Confirm',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
