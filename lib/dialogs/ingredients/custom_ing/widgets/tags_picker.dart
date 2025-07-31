import 'package:ai_cook_project/models/tag_model.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/text_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TagsPicker extends StatelessWidget {
  final List<Tag> tags;
  final List<Tag> selectedTags;
  final ValueChanged<Tag> onTagsSelected;

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
        color: AppColors.mutedGreen.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.button.withOpacity(0.2)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tags',
            style: TextStyle(
              color: AppColors.button,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                tags.map((tag) {
                  final isSelected = selectedTags.contains(tag);
                  return Semantics(
                    label:
                        'Tag ${tag.name}, ${isSelected ? "seleccionado" : "no seleccionado"}',
                    selected: isSelected,
                    child: FilterChip(
                      label: Text(TextUtils.capitalizeFirstLetter(tag.name)),
                      selected: isSelected,
                      onSelected: (_) => onTagsSelected(tag),
                      backgroundColor:
                          isSelected
                              ? AppColors.mutedGreen
                              : AppColors.mutedGreen.withOpacity(0.18),
                      selectedColor: AppColors.mutedGreen,
                      checkmarkColor: AppColors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.white : AppColors.button,
                        fontWeight: FontWeight.w400,
                      ),
                      shape: StadiumBorder(
                        side: BorderSide(
                          color:
                              isSelected
                                  ? AppColors.mutedGreen
                                  : CupertinoColors.systemGrey6,
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
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
