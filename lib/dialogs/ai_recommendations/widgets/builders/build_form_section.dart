import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/form/form_comments.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/form/form_header.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/form/form_options.dart';
import 'package:ai_cook_project/models/recipe_tag_model.dart';
import 'package:ai_cook_project/providers/resource_provider.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/widgets/selectors/grey_card_chips.dart';
import 'package:flutter/cupertino.dart';
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
          const FormHeader(),
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
                horizontalPadding: 10,
              );
            },
          ),
          const SizedBox(height: 16),

          // Max Cooking Time and Difficulty in a row
          FormOptions(
            maxTimeController: maxTimeController,
            preferencesController: preferencesController,
            selectedDifficulty: selectedDifficulty,
            onDifficultyChanged: onDifficultyChanged,
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
          FormComments(preferencesController: preferencesController),
        ],
      ),
    );
  }
}
