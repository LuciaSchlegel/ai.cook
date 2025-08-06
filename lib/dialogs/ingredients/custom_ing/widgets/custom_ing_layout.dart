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
      child: Container(
        padding: EdgeInsets.fromLTRB(
          24,
          16,
          24,
          MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: AppColors.button.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                isEditing ? 'Edit Custom Ingredient' : 'Add Custom Ingredient',
                style: const TextStyle(
                  fontSize: 30,
                  fontFamily: 'Casta',
                  color: AppColors.button,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              custom_ing_fields.ControlledIngNameField(
                controller: nameController,
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.button.withOpacity(0.3)),
                ),
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
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
                          fontSize: 16,
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
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.button.withOpacity(0.3),
                        ),
                      ),
                      child: custom_ing_fields.QuantityField(
                        controller: quantityController,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.button.withOpacity(0.3),
                        ),
                      ),
                      child: CupertinoButton(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
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
                                fontSize: 16,
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
                  ),
                ],
              ),
              const SizedBox(height: 36),
              SaveButtonsRow(
                isEditing: isEditing,
                onDelete: onDelete,
                onCancel: onCancel,
                onSave: onSave,
                isFormValid: isFormValid,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
