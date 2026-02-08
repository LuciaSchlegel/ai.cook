import 'package:ai_cook_project/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';

final List<String> genders = ['Male', 'Female', 'Other', 'Prefer not to say'];

Future<void> selectDate({
  required BuildContext context,
  required DateTime? initialDate,
  required void Function(DateTime) onDateSelected,
}) async {
  final result = await AppBottomSheet.showDatePicker(
    context: context,
    initialDate: initialDate,
    maximumDate: DateTime.now(),
  );
  if (result != null) {
    onDateSelected(result);
  }
}

Future<void> selectGender({
  required BuildContext context,
  required String? selectedGender,
  required void Function(String) onGenderSelected,
}) async {
  final result = await AppBottomSheet.showPicker<String>(
    context: context,
    items: genders,
    selectedItem: selectedGender ?? genders.first,
    displayText: (g) => g,
    title: 'Select Gender',
  );
  if (result != null) {
    onGenderSelected(result);
  }
}
