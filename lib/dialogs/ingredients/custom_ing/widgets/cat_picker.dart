import 'package:flutter/cupertino.dart';
import 'package:ai_cook_project/models/category_model.dart';
import 'package:ai_cook_project/theme.dart';

class CategoryPickerModal extends StatelessWidget {
  final List<Category> categories;
  final Category selectedCategory;
  final ValueChanged<Category> onSelected;

  const CategoryPickerModal({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final controller = FixedExtentScrollController(
      initialItem: categories.indexOf(selectedCategory),
    );

    return Container(
      height: 216,
      padding: const EdgeInsets.only(top: 6.0),
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Header
            Container(
              height: 44,
              decoration: const BoxDecoration(
                color: CupertinoColors.white,
                border: Border(
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
                      style: TextStyle(color: AppColors.mutedGreen),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoButton(
                    padding: const EdgeInsets.only(right: 16),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        color: AppColors.mutedGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      final selected = categories[controller.selectedItem];
                      onSelected(selected);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            // Picker
            Expanded(
              child: CupertinoPicker(
                magnification: 1.22,
                squeeze: 1.2,
                useMagnifier: true,
                itemExtent: 32.0,
                scrollController: controller,
                onSelectedItemChanged: (_) {},
                children:
                    categories
                        .map(
                          (category) => Center(
                            child: Text(
                              category.name,
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.button,
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
