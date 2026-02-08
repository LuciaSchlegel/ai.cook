import 'package:ai_cook_project/dialogs/ai_assistant/widgets/ai_loading_indicator.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/builders/build_error.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/builders/build_no_results.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/builders/build_recommendations.dart';
import 'package:ai_cook_project/models/recipe_tag_model.dart';
import 'package:ai_cook_project/providers/ai_recommendations_provider.dart';
import 'package:ai_cook_project/providers/resource_provider.dart';
import 'package:ai_cook_project/providers/user_provider.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecommendationsView extends StatefulWidget {
  const RecommendationsView({super.key});

  @override
  State<RecommendationsView> createState() => _RecommendationsViewState();
}

class _RecommendationsViewState extends State<RecommendationsView> {
  final Set<RecipeTag> _selectedTags = {};
  String? _selectedDifficulty;
  int? _selectedMaxTime;

  static const List<String> _difficulties = ['Easy', 'Medium', 'Hard'];
  static const Map<String, int> _timePresets = {
    '15 min': 15,
    '30 min': 30,
    '1 hour': 60,
  };

  void _toggleTag(RecipeTag tag) {
    setState(() {
      if (_selectedTags.any((t) => t.id == tag.id)) {
        _selectedTags.removeWhere((t) => t.id == tag.id);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  void _selectDifficulty(String difficulty) {
    setState(() {
      _selectedDifficulty =
          _selectedDifficulty == difficulty ? null : difficulty;
    });
  }

  void _selectTime(int minutes) {
    setState(() {
      _selectedMaxTime = _selectedMaxTime == minutes ? null : minutes;
    });
  }

  void _generate() {
    final aiProvider = Provider.of<AIRecommendationsProvider>(
      context,
      listen: false,
    );
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    aiProvider.generateRecommendations(
      userId: userProvider.user?.uid ?? '',
      preferredTags: _selectedTags.toList(),
      maxCookingTimeMinutes: _selectedMaxTime,
      preferredDifficulty: _selectedDifficulty,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AIRecommendationsProvider>(
      builder: (context, aiProvider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            _buildHeader(context),
            SizedBox(
              height: ResponsiveUtils.spacing(context, ResponsiveSpacing.lg),
            ),

            // Cuisine tags
            _buildSectionLabel(context, 'Cuisine'),
            _buildTagChips(context),
            SizedBox(
              height: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
            ),

            // Difficulty chips
            _buildSectionLabel(context, 'Difficulty'),
            _buildDifficultyChips(context),
            SizedBox(
              height: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
            ),

            // Time chips
            _buildSectionLabel(context, 'Max time'),
            _buildTimeChips(context),
            SizedBox(
              height: ResponsiveUtils.spacing(context, ResponsiveSpacing.lg),
            ),

            // Generate background
            _buildGeneratebackground(context, aiProvider),
            SizedBox(
              height: ResponsiveUtils.spacing(context, ResponsiveSpacing.lg),
            ),

            // Results / loading / error
            if (aiProvider.isLoading)
              const AILoadingIndicator(
                message: 'Finding recipes for you',
                accentColor: AppColors.background,
              )
            else if (aiProvider.error != null)
              aiProvider.error == 'notEnoughRecipes'
                  ? const BuildNoResults()
                  : ErrorBuild(error: aiProvider.error!)
            else if (aiProvider.currentRecommendation != null)
              RecommendationsBuilder(
                recommendation: aiProvider.currentRecommendation!,
              ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(
            ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.background,
                AppColors.background.withValues(alpha: 0.85),
              ],
            ),
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.background.withValues(alpha: 0.15),
                blurRadius: ResponsiveUtils.spacing(
                  context,
                  ResponsiveSpacing.md,
                ),
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            CupertinoIcons.sparkles,
            color: Colors.white,
            size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.xl),
          ),
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
        ),
        ShaderMask(
          shaderCallback:
              (bounds) => LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.background,
                  AppColors.background.withValues(alpha: 0.7),
                  AppColors.background,
                ],
                stops: const [0.0, 0.5, 1.0],
              ).createShader(bounds),
          child: Text(
            'Recommendations',
            style: AppTextStyles.casta(
              fontSize:
                  ResponsiveUtils.fontSize(context, ResponsiveFontSize.title) *
                  1.2,
              fontWeight: AppFontWeights.bold,
              color: AppColors.white,
              letterSpacing: 0.8,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
        ),
        Text(
          'Recipes based on what\'s in your cupboard',
          style: AppTextStyles.inter(
            fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.sm),
            fontWeight: AppFontWeights.regular,
            color: AppColors.button.withValues(alpha: 0.6),
            letterSpacing: 0.2,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  static const int _maxVisibleTags = 8;

  Widget _buildSectionLabel(BuildContext context, String label) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
      ),
      child: Text(
        label,
        style: AppTextStyles.inter(
          fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.xs),
          fontWeight: AppFontWeights.semiBold,
          color: AppColors.button.withValues(alpha: 0.5),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTagChips(BuildContext context) {
    return Consumer<ResourceProvider>(
      builder: (context, resourceProvider, _) {
        if (!resourceProvider.isInitialized) {
          return SizedBox(
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
            child: const Center(child: CupertinoActivityIndicator()),
          );
        }

        final allTags = resourceProvider.recipeTags;
        if (allTags.isEmpty) return const SizedBox.shrink();

        // Show selected tags first, then fill up to max
        final visibleTags = <RecipeTag>[];
        for (final tag in allTags) {
          if (_selectedTags.any((t) => t.id == tag.id)) {
            visibleTags.add(tag);
          }
        }
        for (final tag in allTags) {
          if (visibleTags.length >= _maxVisibleTags) break;
          if (!visibleTags.any((t) => t.id == tag.id)) {
            visibleTags.add(tag);
          }
        }

        return Wrap(
          spacing: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
          runSpacing: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
          children:
              visibleTags.map((tag) {
                final isSelected = _selectedTags.any((t) => t.id == tag.id);
                return _buildChip(
                  context,
                  label: tag.name,
                  isSelected: isSelected,
                  onTap: () => _toggleTag(tag),
                );
              }).toList(),
        );
      },
    );
  }

  Widget _buildDifficultyChips(BuildContext context) {
    return Wrap(
      spacing: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
      runSpacing: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
      children:
          _difficulties.map((d) {
            return _buildChip(
              context,
              label: d,
              isSelected: _selectedDifficulty == d,
              onTap: () => _selectDifficulty(d),
            );
          }).toList(),
    );
  }

  Widget _buildTimeChips(BuildContext context) {
    return Wrap(
      spacing: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
      runSpacing: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
      children:
          _timePresets.entries.map((e) {
            return _buildChip(
              context,
              label: e.key,
              isSelected: _selectedMaxTime == e.value,
              onTap: () => _selectTime(e.value),
              icon: CupertinoIcons.clock,
            );
          }).toList(),
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
          vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
        ),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.background
                  : AppColors.background.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
          ),
          border: Border.all(
            color:
                isSelected
                    ? AppColors.background
                    : AppColors.background.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.xs),
                color:
                    isSelected
                        ? AppColors.white
                        : AppColors.background.withValues(alpha: 0.6),
              ),
              SizedBox(
                width: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
              ),
            ],
            if (isSelected) ...[
              Icon(
                CupertinoIcons.checkmark,
                size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.xs),
                color: AppColors.white,
              ),
              SizedBox(
                width: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
              ),
            ],
            Text(
              label,
              style: AppTextStyles.inter(
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  ResponsiveFontSize.sm,
                ),
                fontWeight: AppFontWeights.medium,
                color:
                    isSelected
                        ? AppColors.white
                        : AppColors.background.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneratebackground(
    BuildContext context,
    AIRecommendationsProvider aiProvider,
  ) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color:
            aiProvider.isLoading
                ? AppColors.background.withValues(alpha: 0.3)
                : AppColors.background,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
        ),
        child: InkWell(
          onTap: aiProvider.isLoading ? null : _generate,
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.sparkles,
                  color: AppColors.white,
                  size: ResponsiveUtils.iconSize(
                    context,
                    ResponsiveIconSize.md,
                  ),
                ),
                SizedBox(
                  width: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
                ),
                Text(
                  aiProvider.currentRecommendation == null
                      ? 'Get Recommendations'
                      : 'Refresh',
                  style: AppTextStyles.inter(
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.md,
                    ),
                    fontWeight: AppFontWeights.semiBold,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
