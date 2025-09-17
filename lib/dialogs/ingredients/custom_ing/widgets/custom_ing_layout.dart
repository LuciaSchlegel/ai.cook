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
  final bool isPopup; // New parameter to detect popup mode

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
    this.isPopup = false, // Default to false for backward compatibility
  });

  @override
  Widget build(BuildContext context) {
    final dietaryFlags = resourceProvider.dietaryTags;
    final showDragHandle = !isPopup; // Only show drag handle for bottom sheet

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
            decoration:
                isPopup
                    ? BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.borderRadius(
                          context,
                          ResponsiveBorderRadius.lg,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.button.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    )
                    : null, // No decoration for bottom sheet - handled by wrapper
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding:
                    deviceType == DeviceType.iPadPro ||
                            deviceType == DeviceType.iPadMini
                        ? ResponsiveUtils.padding(context, ResponsiveSpacing.md)
                        : EdgeInsets.zero,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Drag handle (only for bottom sheet)
                    if (showDragHandle)
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
                          ? 'EDIT CUSTOM INGREDIENT'
                          : 'ADD CUSTOM INGREDIENT',
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        ResponsiveFontSize.title2,
                      ),
                      fontFamily: 'Melodrama',
                      color: AppColors.button,
                      fontWeight: AppFontWeights.semiBold,
                      textAlign: TextAlign.center,
                      letterSpacing: 1.8,
                    ),
                    const ResponsiveSpacingWidget.vertical(
                      ResponsiveSpacing.lg,
                    ),
                    custom_ing_fields.ControlledIngNameField(
                      controller: nameController,
                    ),
                    const ResponsiveSpacingWidget.vertical(
                      ResponsiveSpacing.md,
                    ),
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
                              fontSize: ResponsiveUtils.fontSize(
                                context,
                                ResponsiveFontSize.md,
                              ),
                              color: AppColors.button,
                              fontFamily: 'Inter',
                              fontWeight: AppFontWeights.medium,
                              letterSpacing: 0.2,
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
                    const ResponsiveSpacingWidget.vertical(
                      ResponsiveSpacing.md,
                    ),
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
                    const ResponsiveSpacingWidget.vertical(
                      ResponsiveSpacing.md,
                    ),
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
                                color: AppColors.mutedGreen.withValues(
                                  alpha: 0.7,
                                ),
                                width: 0.5,
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
                                color: AppColors.mutedGreen.withValues(
                                  alpha: 0.7,
                                ),
                                width: 0.5,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ResponsiveText(
                                    TextUtils.capitalizeFirstLetter(
                                      selectedUnit.name,
                                    ),
                                    fontSize: ResponsiveUtils.fontSize(
                                      context,
                                      ResponsiveFontSize.md,
                                    ),
                                    color:
                                        selectedUnit.name == 'Select unit'
                                            ? AppColors.button.withValues(
                                              alpha: 0.5,
                                            )
                                            : AppColors.button,
                                    fontFamily: 'Inter',
                                    fontWeight: AppFontWeights.medium,
                                    letterSpacing: 0.2,
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
                    const ResponsiveSpacingWidget.vertical(
                      ResponsiveSpacing.xl,
                    ),
                    SaveButtonsRow(
                      isEditing: isEditing,
                      onDelete: onDelete,
                      onCancel: onCancel,
                      onSave: onSave,
                      isFormValid: isFormValid,
                    ),
                    SizedBox(
                      height:
                          isPopup
                              ? ResponsiveUtils.spacing(
                                context,
                                ResponsiveSpacing.md,
                              )
                              : ResponsiveUtils.spacing(
                                context,
                                ResponsiveSpacing.sm,
                              ),
                    ),
                    // Add bottom safe area padding inside the modal
                    SizedBox(
                      height:
                          isPopup ? 0 : MediaQuery.of(context).padding.bottom,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
