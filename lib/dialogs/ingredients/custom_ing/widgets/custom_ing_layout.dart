import 'package:ai_cook_project/dialogs/ingredients/custom_ing/widgets/buttons.dart';
import 'package:ai_cook_project/dialogs/ingredients/custom_ing/widgets/cat_picker.dart';
import 'package:ai_cook_project/dialogs/ingredients/custom_ing/widgets/tags_picker.dart';
import 'package:ai_cook_project/dialogs/ingredients/form/widgets/picker_modal.dart';
import 'package:ai_cook_project/models/category_model.dart';
import 'package:ai_cook_project/models/unit.dart';
import 'package:ai_cook_project/providers/resource_provider.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/text_utils.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
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

    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            padding: EdgeInsets.all(
              ResponsiveUtils.spacing(context, ResponsiveSpacing.lg),
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(
                  ResponsiveUtils.borderRadius(
                    context,
                    ResponsiveBorderRadius.xl,
                  ),
                ),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: ResponsiveUtils.spacing(
                      context,
                      ResponsiveSpacing.lg,
                    ),
                    height: ResponsiveUtils.spacing(
                      context,
                      ResponsiveSpacing.xxs,
                    ),
                    margin: EdgeInsets.only(
                      bottom: ResponsiveUtils.spacing(
                        context,
                        ResponsiveSpacing.lg,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.button.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.borderRadius(
                          context,
                          ResponsiveBorderRadius.sm,
                        ),
                      ),
                    ),
                  ),
                  ResponsiveText(
                    isEditing
                        ? 'Edit Custom Ingredient'
                        : 'Add Custom Ingredient',
                    fontSize: ResponsiveFontSize.title,
                    fontFamily: 'Casta',
                    color: AppColors.button,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    textAlign: TextAlign.center,
                  ),
                  const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.lg),
                  custom_ing_fields.ControlledIngNameField(
                    controller: nameController,
                  ),
                  const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.md),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.mutedGreen.withValues(alpha: 0.7),
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.borderRadius(
                          context,
                          ResponsiveBorderRadius.md,
                        ),
                      ),
                    ),
                    child: CupertinoButton(
                      sizeStyle: CupertinoButtonSize.large,
                      autofocus: false,
                      padding: ResponsiveUtils.padding(
                        context,
                        ResponsiveSpacing.sm,
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
                          ResponsiveText(
                            selectedCategory.name,
                            fontSize: ResponsiveFontSize.md,
                            color: AppColors.button,
                          ),
                          ResponsiveIcon(
                            CupertinoIcons.chevron_down,
                            null,
                            color: AppColors.button,
                            size: ResponsiveIconSize.md,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.md),
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
                  const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: CupertinoColors.white,
                            borderRadius: BorderRadius.circular(
                              ResponsiveUtils.borderRadius(
                                context,
                                ResponsiveBorderRadius.sm,
                              ),
                            ),
                            border: Border.all(
                              color: AppColors.button.withValues(alpha: 0.3),
                            ),
                          ),
                          child: custom_ing_fields.QuantityField(
                            controller: quantityController,
                          ),
                        ),
                      ),
                      const ResponsiveSpacingWidget.horizontal(
                        ResponsiveSpacing.md,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: CupertinoColors.white,
                            borderRadius: BorderRadius.circular(
                              ResponsiveUtils.borderRadius(
                                context,
                                ResponsiveBorderRadius.sm,
                              ),
                            ),
                            border: Border.all(
                              color: AppColors.button.withValues(alpha: 0.3),
                            ),
                          ),
                          child: CupertinoButton(
                            padding: ResponsiveUtils.padding(
                              context,
                              ResponsiveSpacing.sm,
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
                                ResponsiveText(
                                  TextUtils.capitalizeFirstLetter(
                                    selectedUnit.name,
                                  ),
                                  fontSize: ResponsiveFontSize.md,
                                  color:
                                      selectedUnit.name == 'Select unit'
                                          ? AppColors.button.withValues(
                                            alpha: 0.5,
                                          )
                                          : AppColors.button,
                                ),
                                ResponsiveIcon(
                                  CupertinoIcons.chevron_down,
                                  null,
                                  color: AppColors.button,
                                  size: ResponsiveIconSize.md,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.xl),
                  SaveButtonsRow(
                    isEditing: isEditing,
                    onDelete: onDelete,
                    onCancel: onCancel,
                    onSave: onSave,
                    isFormValid: isFormValid,
                  ),
                  SizedBox(
                    height: ResponsiveUtils.getScrollBottomPadding(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
