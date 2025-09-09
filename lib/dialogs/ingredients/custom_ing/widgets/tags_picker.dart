import 'package:ai_cook_project/models/dietary_tag_model.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/constants/dialog_constants.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/text_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TagsPicker extends StatelessWidget {
  final List<DietaryTag> tags;
  final List<DietaryTag> selectedTags;
  final ValueChanged<String> onTagsSelected;

  const TagsPicker({
    super.key,
    required this.tags,
    required this.selectedTags,
    required this.onTagsSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(DialogConstants.radiusMD),
        border: Border.all(color: AppColors.button.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.all(DialogConstants.spacingSM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dietary Restrictions',
            style: TextStyle(
              color: AppColors.button,
              fontSize: DialogConstants.fontSizeMD,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: DialogConstants.spacingXS),
          Wrap(
            spacing: DialogConstants.spacingXS,
            runSpacing: DialogConstants.spacingXS,
            children:
                tags.map((tag) {
                  final isSelected = selectedTags.contains(tag);
                  return Semantics(
                    label:
                        'Dietary restriction $tag, ${isSelected ? "selected" : "not selected"}',
                    selected: isSelected,
                    child: FilterChip(
                      label: Text(TextUtils.capitalizeFirstLetter(tag.name)),
                      selected: isSelected,
                      onSelected: (_) => onTagsSelected(tag.name),
                      backgroundColor: AppColors.mutedGreen.withValues(
                        alpha: 0.6,
                      ),
                      selectedColor: AppColors.background.withValues(
                        alpha: 0.8,
                      ),
                      checkmarkColor: AppColors.white,
                      labelStyle: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.none,
                      ),
                      shape: StadiumBorder(
                        side: BorderSide(
                          color:
                              isSelected
                                  ? AppColors.mutedGreen.withValues(alpha: 0.9)
                                  : CupertinoColors.systemGrey6,
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: DialogConstants.spacingXS,
                        vertical: DialogConstants.spacingXXS,
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
