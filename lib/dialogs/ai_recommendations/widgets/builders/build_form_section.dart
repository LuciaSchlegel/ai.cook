import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/form/form_comments.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/form/form_header.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/form/form_options.dart';
import 'package:ai_cook_project/models/recipe_tag_model.dart';
import 'package:ai_cook_project/providers/resource_provider.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
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
      padding: ResponsiveUtils.padding(context, ResponsiveSpacing.md),
      margin: EdgeInsets.symmetric(
        vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.xl),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.button.withValues(alpha: 0.1),
            blurRadius: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            offset: Offset(
              0,
              ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced form header with gradients
          const FormHeader(),
          SizedBox(
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
          ),
          // Recipe Tags Selector
          Text(
            'Preferred Recipe Tags',
            style: TextStyle(
              fontSize: ResponsiveUtils.fontSize(
                context,
                ResponsiveFontSize.md,
              ),
              color: AppColors.button,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
          ),
          Consumer<ResourceProvider>(
            builder: (context, resourceProvider, child) {
              if (!resourceProvider.isInitialized) {
                return SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.md,
                  ),
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
              );
            },
          ),
          SizedBox(
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          ),

          // Max Cooking Time and Difficulty in a row
          FormOptions(
            maxTimeController: maxTimeController,
            preferencesController: preferencesController,
            selectedDifficulty: selectedDifficulty,
            onDifficultyChanged: onDifficultyChanged,
          ),
          SizedBox(
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          ),

          // User Preferences
          Text(
            'Additional Preferences (optional)',
            style: TextStyle(
              fontSize: ResponsiveUtils.fontSize(
                context,
                ResponsiveFontSize.md,
              ),
              color: AppColors.button,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
          ),
          FormComments(preferencesController: preferencesController),
        ],
      ),
    );
  }
}
