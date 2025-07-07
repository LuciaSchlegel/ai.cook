import 'package:flutter/cupertino.dart';

final List<String> genders = ['Male', 'Female', 'Other', 'Prefer not to say'];

Future<void> selectDate({
  required BuildContext context,
  required DateTime? initialDate,
  required void Function(DateTime) onDateSelected,
}) async {
  DateTime selectedDate = initialDate ?? DateTime(2000);

  await showCupertinoModalPopup(
    context: context,
    builder:
        (BuildContext context) => Container(
          height: 300,
          padding: const EdgeInsets.only(top: 6.0),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        onDateSelected(selectedDate);
                        Navigator.pop(context);
                      },
                      child: const Text('Done'),
                    ),
                  ],
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: selectedDate,
                    maximumDate: DateTime.now(),
                    onDateTimeChanged: (DateTime newDate) {
                      selectedDate = newDate;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
  );
}

Future<void> selectGender({
  required BuildContext context,
  required String? selectedGender,
  required void Function(String) onGenderSelected,
}) async {
  int selectedIndex =
      selectedGender != null ? genders.indexOf(selectedGender) : 0;

  await showCupertinoModalPopup(
    context: context,
    builder:
        (BuildContext context) => Container(
          height: 250,
          padding: const EdgeInsets.only(top: 6.0),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        onGenderSelected(genders[selectedIndex]);
                        Navigator.pop(context);
                      },
                      child: const Text('Done'),
                    ),
                  ],
                ),
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 44,
                    scrollController: FixedExtentScrollController(
                      initialItem: selectedIndex,
                    ),
                    onSelectedItemChanged: (int index) {
                      selectedIndex = index;
                    },
                    children:
                        genders
                            .map((gender) => Center(child: Text(gender)))
                            .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
  );
}
