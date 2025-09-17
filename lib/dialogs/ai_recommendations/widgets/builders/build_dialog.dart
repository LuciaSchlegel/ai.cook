import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/sections/ai_recom_header.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/builders/build_empty.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/builders/build_error.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/builders/build_form_section.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/builders/build_recommendations.dart';
import 'package:ai_cook_project/models/ai_response_model.dart';
import 'package:ai_cook_project/widgets/loader/skeleton_loader.dart';
import 'package:ai_cook_project/models/recipe_tag_model.dart';
import 'package:ai_cook_project/providers/ai_recommendations_provider.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuildDialog extends StatelessWidget {
  final List<RecipeTag> selectedTags;
  final Function(List<RecipeTag>) onTagSelectionChanged;
  final TextEditingController maxTimeController;
  final TextEditingController preferencesController;
  final String selectedDifficulty;
  final Function(String) onDifficultyChanged;
  final VoidCallback generateAiRecommendations;

  const BuildDialog({
    super.key,
    required this.selectedTags,
    required this.onTagSelectionChanged,
    required this.maxTimeController,
    required this.preferencesController,
    required this.selectedDifficulty,
    required this.onDifficultyChanged,
    required this.generateAiRecommendations,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AIRecommendationsProvider>(
      builder: (context, aiProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enhanced dialog title with gradient
            const AiRecomHeader(),
            SizedBox(
              height: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
            ),

            // AI Recommendation Form Section
            SectionBuilder(
              selectedTags: selectedTags,
              onTagSelectionChanged: onTagSelectionChanged,
              maxTimeController: maxTimeController,
              preferencesController: preferencesController,
              selectedDifficulty: selectedDifficulty,
              onDifficultyChanged: onDifficultyChanged,
            ),
            SizedBox(
              height: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
            ),

            // Show loading, error, or recommendations based on provider state
            if (aiProvider.isLoading)
              _buildLoadingContent()
            else if (aiProvider.error != null)
              _buildErrorContent(aiProvider.error!)
            else if (aiProvider.currentRecommendation != null)
              _buildRecommendationsContent(aiProvider.currentRecommendation!)
            else
              _buildEmptyContent(),

            SizedBox(
              height: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
            ),

            // Generate/Regenerate recommendations button - Enhanced
            Container(
              width: double.infinity,
              height:
                  ResponsiveUtils.spacing(context, ResponsiveSpacing.xxl) +
                  ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
              margin: EdgeInsets.symmetric(
                vertical: ResponsiveUtils.spacing(
                  context,
                  ResponsiveSpacing.xs,
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.borderRadius(
                    context,
                    ResponsiveBorderRadius.lg,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.button.withValues(alpha: 0.15),
                    blurRadius: ResponsiveUtils.spacing(
                      context,
                      ResponsiveSpacing.sm,
                    ),
                    offset: const Offset(0, 2),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  debugPrint('🔄 AI Dialog: Manual regeneration triggered');
                  generateAiRecommendations();
                },
                icon: Icon(
                  CupertinoIcons.sparkles,
                  size: ResponsiveUtils.iconSize(
                    context,
                    ResponsiveIconSize.sm,
                  ),
                ),
                label: Text(
                  aiProvider.currentRecommendation == null
                      ? 'Generate AI Recommendations'
                      : 'Update Recommendations',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.md,
                    ),
                    fontWeight: AppFontWeights.semiBold,
                    fontFamily: 'Inter',
                    letterSpacing: 0.2,
                    height: 1.4,
                    color: AppColors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.button,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.borderRadius(
                        context,
                        ResponsiveBorderRadius.lg,
                      ),
                    ),
                  ),
                  padding: ResponsiveUtils.padding(
                    context,
                    ResponsiveSpacing.md,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

Widget _buildLoadingContent() {
  return const SkeletonLoader();
}

Widget _buildErrorContent(String error) {
  return ErrorBuild(error: error);
}

Widget _buildRecommendationsContent(StructuredAIRecommendation recommendation) {
  return RecommendationsBuilder(recommendation: recommendation);
}

Widget _buildEmptyContent() {
  return BuildEmpty();
}
