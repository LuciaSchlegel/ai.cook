import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class DropdownSelector extends StatelessWidget {
  final String value;
  final List<String> items;
  final Function(String?) onChanged;
  final double? width;

  const DropdownSelector({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.width,
  });

  void _showDropdownMenu(BuildContext context) {
    final int initialItem = items.indexOf(value);

    showCupertinoModalPopup<void>(
      context: context,
      builder:
          (BuildContext context) => Container(
            height: 216,
            padding: const EdgeInsets.only(top: 6.0),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            color: Colors.grey[300],
            child: Column(
              children: [
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[500]!, width: 1.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Group by:',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter',
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            color: CupertinoColors.activeBlue,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Inter',
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    magnification: 1.22,
                    squeeze: 1.2,
                    useMagnifier: true,
                    itemExtent: 32.0,
                    scrollController: FixedExtentScrollController(
                      initialItem: initialItem != -1 ? initialItem : 0,
                    ),
                    onSelectedItemChanged: (int selectedItem) {
                      onChanged(items[selectedItem]);
                    },
                    children:
                        items.map((item) {
                          return Center(
                            child: Text(
                              item,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => _showDropdownMenu(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const Icon(
              CupertinoIcons.chevron_down,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
