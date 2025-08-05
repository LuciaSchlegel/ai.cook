import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/build_empty.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/build_error.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/build_form_section.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/build_recommendations.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/skeleton_loader.dart';
import 'package:ai_cook_project/models/recipe_tag_model.dart';
import 'package:ai_cook_project/providers/ai_recommendations_provider.dart';
import 'package:ai_cook_project/theme.dart';
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
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.mutedGreen.withOpacity(0.2),
                        AppColors.lightYellow.withOpacity(0.3),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.mutedGreen.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    CupertinoIcons.sparkles,
                    size: 24,
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
                            AppColors.mutedGreen,
                            AppColors.button,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ).createShader(bounds),
                    child: const Text(
                      'AI Recipe Recommendations',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // AI Recommendation Form Section
            SectionBuilder(
              selectedTags: selectedTags,
              onTagSelectionChanged: onTagSelectionChanged,
              maxTimeController: maxTimeController,
              preferencesController: preferencesController,
              selectedDifficulty: selectedDifficulty,
              onDifficultyChanged: onDifficultyChanged,
            ),
            const SizedBox(height: 24),

            // Show loading, error, or recommendations based on provider state
            if (aiProvider.isLoading)
              _buildLoadingContent()
            else if (aiProvider.error != null)
              _buildErrorContent(aiProvider.error!)
            else if (aiProvider.currentRecommendation != null)
              _buildRecommendationsContent(aiProvider.currentRecommendation!)
            else
              _buildEmptyContent(),

            const SizedBox(height: 20),

            // Generate/Regenerate recommendations button - Enhanced
            Container(
              width: double.infinity,
              height: 54,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.button.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  debugPrint('🔄 AI Dialog: Manual regeneration triggered');
                  generateAiRecommendations();
                },
                icon: Icon(CupertinoIcons.sparkles, size: 18),
                label: Text(
                  aiProvider.currentRecommendation == null
                      ? 'Generate AI Recommendations'
                      : 'Update Recommendations',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.button,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
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

Widget _buildRecommendationsContent(AIRecommendation recommendation) {
  return RecommendationsBuilder(recommendation: recommendation);
}

Widget _buildEmptyContent() {
  return BuildEmpty();
}
