import 'package:ai_cook_project/dialogs/ingredients/custom_ing/widgets/buttons.dart';
import 'package:ai_cook_project/dialogs/ingredients/custom_ing/widgets/cat_picker.dart';
import 'package:ai_cook_project/dialogs/ingredients/custom_ing/widgets/tags_picker.dart';
import 'package:ai_cook_project/dialogs/ingredients/form/widgets/picker_modal.dart';
import 'package:ai_cook_project/models/category_model.dart';
import 'package:ai_cook_project/models/unit.dart';
import 'package:ai_cook_project/providers/resource_provider.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/text_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:ai_cook_project/dialogs/ingredients/form/widgets/fields.dart'
    as custom_ing_fields;
import 'package:ai_cook_project/dialogs/ai_recommendations/constants/dialog_constants.dart';

class CustomIngLayout extends StatelessWidget {
  final bool isEditing;
  final TextEditingController nameController;
  final TextEditingController quantityController;
  final Category selectedCategory;
  final List<Category> categories;
  final void Function(Category) onCategoryChanged;
  final Set<String> selectedTags;
  final void Function(String) onTagToggle;
  final Unit selectedUnit;
  final List<Unit> availableUnits;
  final void Function(Unit) onUnitChanged;
  final VoidCallback onCancel;
  final VoidCallback? onDelete;
  final bool isFormValid;
  final VoidCallback onSave;
  final ResourceProvider resourceProvider;
  const CustomIngLayout({
    super.key,
    required this.isEditing,
    required this.nameController,
    required this.quantityController,
    required this.selectedCategory,
    required this.categories,
    required this.onCategoryChanged,
    required this.selectedTags,
    required this.onTagToggle,
    required this.selectedUnit,
    required this.availableUnits,
    required this.onUnitChanged,
    required this.onCancel,
    required this.onSave,
    this.onDelete,
    required this.isFormValid,
    required this.resourceProvider,
  });

  @override
  Widget build(BuildContext context) {
    final dietaryFlags = resourceProvider.dietaryTags;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: AnimatedPadding(
        padding: EdgeInsets.only(
          bottom: DialogConstants.adaptiveSpacing(
            context,
            MediaQuery.of(context).viewInsets.bottom,
          ),
        ),
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: DialogConstants.spacingMD,
            vertical: DialogConstants.spacingMD,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(DialogConstants.radiusMD),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 20,
                  height: 2,
                  margin: const EdgeInsets.only(
                    bottom: DialogConstants.spacingMD,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.button.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(
                      DialogConstants.radiusSM,
                    ),
                  ),
                ),
                Text(
                  isEditing
                      ? 'Edit Custom Ingredient'
                      : 'Add Custom Ingredient',
                  style: const TextStyle(
                    fontSize: DialogConstants.fontSizeTitle,
                    fontFamily: 'Casta',
                    color: AppColors.button,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: DialogConstants.spacingMD),
                custom_ing_fields.ControlledIngNameField(
                  controller: nameController,
                ),
                const SizedBox(height: DialogConstants.spacingSM),
                Container(
                  decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    borderRadius: BorderRadius.circular(
                      DialogConstants.radiusMD,
                    ),
                    border: Border.all(
                      color: AppColors.button.withOpacity(0.3),
                    ),
                  ),
                  child: CupertinoButton(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DialogConstants.spacingSM,
                      vertical: DialogConstants.spacingSM,
                    ),
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder:
                            (BuildContext context) => CategoryPickerModal(
                              categories: categories,
                              selectedCategory: selectedCategory,
                              onSelected: onCategoryChanged,
                            ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedCategory.name,
                          style: const TextStyle(
                            color: AppColors.button,
                            fontSize: DialogConstants.fontSizeMD,
                          ),
                        ),
                        const Icon(
                          CupertinoIcons.chevron_down,
                          color: AppColors.button,
                          size: DialogConstants.iconSizeMD,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: DialogConstants.spacingSM),
                TagsPicker(
                  tags: dietaryFlags,
                  selectedTags:
                      dietaryFlags
                          .where((tag) => selectedTags.contains(tag.name))
                          .toList(),
                  onTagsSelected: (String tagName) {
                    onTagToggle(tagName);
                  },
                ),
                const SizedBox(height: DialogConstants.spacingSM),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: CupertinoColors.white,
                          borderRadius: BorderRadius.circular(
                            DialogConstants.radiusSM,
                          ),
                          border: Border.all(
                            color: AppColors.button.withOpacity(0.3),
                          ),
                        ),
                        child: custom_ing_fields.QuantityField(
                          controller: quantityController,
                        ),
                      ),
                    ),
                    const SizedBox(width: DialogConstants.spacingSM),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: CupertinoColors.white,
                          borderRadius: BorderRadius.circular(
                            DialogConstants.radiusSM,
                          ),
                          border: Border.all(
                            color: AppColors.button.withOpacity(0.3),
                          ),
                        ),
                        child: CupertinoButton(
                          padding: const EdgeInsets.symmetric(
                            horizontal: DialogConstants.spacingSM,
                            vertical: DialogConstants.spacingSM,
                          ),
                          onPressed: () {
                            showCupertinoModalPopup(
                              context: context,
                              builder:
                                  (context) => UnitPickerModal(
                                    selectedUnit: selectedUnit,
                                    units: availableUnits,
                                    onSelected: onUnitChanged,
                                  ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                TextUtils.capitalizeFirstLetter(
                                  selectedUnit.name,
                                ),
                                style: TextStyle(
                                  color:
                                      selectedUnit.name == 'Select unit'
                                          ? AppColors.button.withOpacity(0.5)
                                          : AppColors.button,
                                  fontSize: DialogConstants.fontSizeMD,
                                ),
                              ),
                              const Icon(
                                CupertinoIcons.chevron_down,
                                color: AppColors.button,
                                size: DialogConstants.iconSizeMD,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DialogConstants.spacingLG),
                SaveButtonsRow(
                  isEditing: isEditing,
                  onDelete: onDelete,
                  onCancel: onCancel,
                  onSave: onSave,
                  isFormValid: isFormValid,
                ),
                const SizedBox(height: DialogConstants.spacingSM),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
