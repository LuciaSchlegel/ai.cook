import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';

class DropdownSelector extends StatelessWidget {
  final String value;
  final List<String> items;
  final Function(String?) onChanged;
  final double? width;
  final String? title;

  const DropdownSelector({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.width,
    this.title,
  });

  void _showDropdownMenu(BuildContext context) {
    final overlayContext =
        Navigator.of(context, rootNavigator: true).overlay!.context;
    final int initialItem = items.indexOf(value);

    showCupertinoModalPopup<void>(
      context: overlayContext,
      builder:
          (BuildContext context) => Container(
            height: 216,
            padding: const EdgeInsets.only(top: 6.0),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            color: CupertinoColors.white,
            child: Column(
              children: [
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    border: const Border(
                      bottom: BorderSide(
                        color: CupertinoColors.systemGrey4,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        padding: const EdgeInsets.only(left: 16),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: AppColors.mutedGreen,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      CupertinoButton(
                        padding: const EdgeInsets.only(right: 16),
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.mutedGreen,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ExcludeSemantics(
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
                          items
                              .map(
                                (item) => Center(
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      color: AppColors.button,
                                      fontSize: 16,
                                    ),
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

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () => _showDropdownMenu(context),
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: width,
          constraints: const BoxConstraints(
            minHeight: 48,
          ), // ✅ Fix: asegura área de tap grande
          decoration: BoxDecoration(
            color: CupertinoColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.button.withOpacity(0.2)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(color: AppColors.button, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(
                CupertinoIcons.chevron_down,
                color: AppColors.button,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
