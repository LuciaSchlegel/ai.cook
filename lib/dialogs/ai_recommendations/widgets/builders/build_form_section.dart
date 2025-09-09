import 'package:ai_cook_project/dialogs/ai_recommendations/constants/dialog_constants.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/form/form_comments.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/form/form_header.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/form/form_options.dart';
import 'package:ai_cook_project/models/recipe_tag_model.dart';
import 'package:ai_cook_project/providers/resource_provider.dart';
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
      padding: DialogConstants.adaptivePadding(context),
      margin: const EdgeInsets.symmetric(vertical: DialogConstants.spacingXS),
      decoration: DialogConstants.sectionDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced form header with gradients
          const FormHeader(),
          const SizedBox(height: DialogConstants.spacingMD),
          // Recipe Tags Selector
          Text(
            'Preferred Recipe Tags',
            style: DialogConstants.bodyTextStyle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: DialogConstants.spacingXS),
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
          const SizedBox(height: DialogConstants.spacingSM),

          // Max Cooking Time and Difficulty in a row
          FormOptions(
            maxTimeController: maxTimeController,
            preferencesController: preferencesController,
            selectedDifficulty: selectedDifficulty,
            onDifficultyChanged: onDifficultyChanged,
          ),
          const SizedBox(height: DialogConstants.spacingSM),

          // User Preferences
          Text(
            'Additional Preferences (optional)',
            style: DialogConstants.bodyTextStyle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: DialogConstants.spacingXS),
          FormComments(preferencesController: preferencesController),
        ],
      ),
    );
  }
}
