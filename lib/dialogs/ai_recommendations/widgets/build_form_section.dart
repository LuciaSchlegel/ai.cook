import 'package:ai_cook_project/models/recipe_tag_model.dart';
import 'package:ai_cook_project/providers/resource_provider.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/widgets/selectors/dropdown_selector.dart';
import 'package:ai_cook_project/widgets/selectors/grey_card_chips.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SectionBuilder extends StatelessWidget {
  final List<RecipeTag> selectedTags;
  final Function(List<RecipeTag>) onTagSelectionChanged;
  final TextEditingController maxTimeController;
  final TextEditingController preferencesController;
  final String selectedDifficulty;
  final Function(String) onDifficultyChanged;

  const SectionBuilder({
    super.key,
    required this.selectedTags,
    required this.onTagSelectionChanged,
    required this.maxTimeController,
    required this.preferencesController,
    required this.selectedDifficulty,
    required this.onDifficultyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.mutedGreen.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: AppColors.mutedGreen.withOpacity(0.12),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced form header with gradients
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.mutedGreen.withOpacity(0.2),
                      AppColors.lightYellow.withOpacity(0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.mutedGreen.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  CupertinoIcons.slider_horizontal_3,
                  size: 18,
                  color: AppColors.mutedGreen,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ShaderMask(
                  shaderCallback:
                      (bounds) => LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          AppColors.button,
                          AppColors.mutedGreen.withOpacity(0.8),
                        ],
                      ).createShader(bounds),
                  child: const Text(
                    'Customize Your Preferences',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Recipe Tags Selector
          Text(
            'Preferred Recipe Tags',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.button.withOpacity(0.9),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 8),
          Consumer<ResourceProvider>(
            builder: (context, resourceProvider, child) {
              if (!resourceProvider.isInitialized) {
                return const SizedBox(
                  height: 50,
                  child: Center(child: CupertinoActivityIndicator()),
                );
              }

              final availableTagNames =
                  resourceProvider.recipeTags.map((t) => t.name).toList();
              final selectedTagNames = selectedTags.map((t) => t.name).toList();

              return GreyCardChips(
                items: availableTagNames,
                selectedItems: selectedTagNames,
                onSelected: (newSelectedNames) {
                  final newTags =
                      resourceProvider.recipeTags
                          .where((tag) => newSelectedNames.contains(tag.name))
                          .toList();
                  onTagSelectionChanged(newTags);
                },
                horizontalPadding: 0,
              );
            },
          ),
          const SizedBox(height: 16),

          // Max Cooking Time and Difficulty in a row
          Row(
            children: [
              // Max Cooking Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Max Cooking Time (minutes)',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.button.withOpacity(0.9),
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.button.withOpacity(0.2),
                        ),
                      ),
                      child: CupertinoTextField(
                        controller: maxTimeController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        placeholder: 'e.g. 30',
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        placeholderStyle: TextStyle(
                          color: AppColors.button.withOpacity(0.5),
                          fontSize: 16,
                        ),
                        style: const TextStyle(
                          color: AppColors.button,
                          fontSize: 16,
                        ),
                        decoration: null,
                        cursorColor: AppColors.mutedGreen,
                        onSubmitted: (_) {
                          // Move focus to preferences field when user presses next
                          FocusScope.of(context).nextFocus();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Difficulty Selector
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preferred Difficulty',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.button.withOpacity(0.9),
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 48,
                      child: DropdownSelector(
                        value: selectedDifficulty,
                        items: ['Easy', 'Medium', 'Hard'],
                        onChanged: (newValue) {
                          if (newValue != null) {
                            onDifficultyChanged(newValue);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // User Preferences
          Text(
            'Additional Preferences (optional)',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.button.withOpacity(0.9),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.button.withOpacity(0.2)),
            ),
            child: CupertinoTextField(
              controller: preferencesController,
              placeholder: 'e.g. I prefer spicy food, vegetarian dishes...',
              maxLines: 3,
              textInputAction: TextInputAction.done,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              placeholderStyle: TextStyle(
                color: AppColors.button.withOpacity(0.5),
                fontSize: 16,
              ),
              style: const TextStyle(color: AppColors.button, fontSize: 16),
              decoration: null,
              cursorColor: AppColors.mutedGreen,
              onSubmitted: (_) {
                // Dismiss keyboard when user presses done
                FocusScope.of(context).unfocus();
              },
            ),
          ),
        ],
      ),
    );
  }
}
