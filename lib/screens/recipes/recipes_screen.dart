import 'dart:async';
import 'package:ai_cook_project/models/recipe_tag_model.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/screens/recipes/widgets/recipe_image.dart';
import 'package:ai_cook_project/screens/recipes/widgets/recipe_ov_card.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:ai_cook_project/widgets/selectors/chips_dropd_card.dart';
import 'package:ai_cook_project/widgets/status/loading_indicator.dart';
import 'package:ai_cook_project/widgets/utils/screen_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/recipe_model.dart';
import '../../providers/recipes_provider.dart';
import '../../providers/resource_provider.dart';
import '../../providers/ingredients_provider.dart';
import 'logic/recipes_logic.dart';
import '../../theme.dart';
import '../../utils/responsive_utils.dart';

class RecipesScreen extends StatefulWidget {
  final VoidCallback? onProfileTap;
  final VoidCallback? onFeedTap;
  final VoidCallback? onLogoutTap;

  const RecipesScreen({
    super.key,
    this.onProfileTap,
    this.onFeedTap,
    this.onLogoutTap,
  });

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  String selectedFilter = 'All Recipes';
  final List<String> filterOptions = [
    'All Recipes',
    'With Available Ingredients',
    'Recommended Recipes',
  ];

  List<RecipeTag> selectedTags = [];

  // Debouncing support
  Timer? _debounceTimer;
  static const Duration _debounceDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      if (!mounted) return;
      final recipesProvider = Provider.of<RecipesProvider>(
        context,
        listen: false,
      );
      final ingredientsProvider = Provider.of<IngredientsProvider>(
        context,
        listen: false,
      );
      await recipesProvider.getRecipes();
      if (!mounted) return;
      // Also fetch missing ingredients using current user ingredients
      await recipesProvider.getMissingIngredients(
        userIngredients: ingredientsProvider.userIngredients,
      );
    });
  }

  void _applyFiltersDebounced() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDuration, () {
      _applyFilters();
    });
  }

  Future<void> _applyFilters() async {
    if (!mounted) return;
    await filterRecipesLogic(
      context: context,
      selectedFilter: selectedFilter,
      selectedTags: selectedTags.map((t) => t.name).toList(),
      maxCookingTimeMinutes: null,
      preferredDifficulty: null,
    );
    if (!mounted) return;
    // Refresh backend-computed missing counts for the current (filtered) recipes
    final recipesProvider = Provider.of<RecipesProvider>(
      context,
      listen: false,
    );
    final ingredientsProvider = Provider.of<IngredientsProvider>(
      context,
      listen: false,
    );
    await recipesProvider.getMissingIngredients(
      userIngredients: ingredientsProvider.userIngredients,
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resourceProvider = Provider.of<ResourceProvider>(context);
    final tagNames = resourceProvider.recipeTags.map((t) => t.name).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              onProfileTap: widget.onProfileTap ?? () {},
              onFeedTap: widget.onFeedTap ?? () {},
              onLogoutTap: widget.onLogoutTap ?? () {},
              currentIndex: 0,
            ),
            ChipsDropdownCard(
              dropdownValue: selectedFilter,
              dropdownItems: filterOptions,
              confirmDropdownOnDone:
                  true, // Enable confirm-on-done for better UX
              onDropdownChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedFilter = value;
                  });
                  _applyFiltersDebounced();
                } else {}
              },
              chipsItems: tagNames,
              chipsSelectedItems: selectedTags.map((t) => t.name).toList(),
              onChipsSelected: (selectedTagNames) {
                setState(() {
                  selectedTags =
                      resourceProvider.recipeTags
                          .where((t) => selectedTagNames.contains(t.name))
                          .toList();
                });
                _applyFiltersDebounced();
              },
            ),
            Expanded(
              child: Consumer<RecipesProvider>(
                builder: (context, recipesProvider, child) {
                  if (recipesProvider.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Error: ${recipesProvider.error}',
                            style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const ResponsiveSpacingWidget.vertical(
                            ResponsiveSpacing.sm,
                          ),
                          ElevatedButton(
                            onPressed: () => recipesProvider.getRecipes(),
                            child: Text(
                              'Retry',
                              style: TextStyle(fontFamily: 'Inter'),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (recipesProvider.isLoading) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const LoadingIndicator(),
                          if (recipesProvider.loadingMessage != null) ...[
                            const ResponsiveSpacingWidget.vertical(
                              ResponsiveSpacing.sm,
                            ),
                            Text(
                              recipesProvider.loadingMessage!,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: ResponsiveUtils.fontSize(
                                  context,
                                  ResponsiveFontSize.sm,
                                ),
                                color: AppColors.mutedGreen,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
                    );
                  }

                  final recipes = recipesProvider.recipes;

                  if (recipes.isEmpty) {
                    return Center(
                      child: Text(
                        'No recipes found',
                        style: TextStyle(
                          fontFamily: 'Casta',
                          fontSize: ResponsiveUtils.fontSize(
                            context,
                            ResponsiveFontSize.xl,
                          ),
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.spacing(
                        context,
                        ResponsiveSpacing.sm,
                      ),
                      vertical: ResponsiveUtils.spacing(
                        context,
                        ResponsiveSpacing.xs,
                      ),
                    ),
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: ResponsiveUtils.padding(
                          context,
                          ResponsiveSpacing.xxs,
                        ),
                        child: _ContainerRecipeCard(
                          key: ValueKey(recipes[index].id),
                          recipe: recipes[index],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContainerRecipeCard extends StatefulWidget {
  final Recipe recipe;

  const _ContainerRecipeCard({super.key, required this.recipe});

  @override
  State<_ContainerRecipeCard> createState() => _ContainerRecipeCardState();
}

class _ContainerRecipeCardState extends State<_ContainerRecipeCard> {
  void _showRecipeDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RecipeOverviewCard(recipe: widget.recipe),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ingredientsProvider = Provider.of<IngredientsProvider>(
      context,
      listen: false,
    );

    return GestureDetector(
      onTap: () => _showRecipeDetail(context),
      child: _ContainerRecipeCardContent(
        recipe: widget.recipe,
        userIngredients: ingredientsProvider.userIngredients,
      ),
    );
  }
}

class _ContainerRecipeCardContent extends StatelessWidget {
  final Recipe recipe;
  final List<UserIng> userIngredients;

  const _ContainerRecipeCardContent({
    required this.recipe,
    required this.userIngredients,
  });

  String _getIngredientsStatusText(BuildContext context) {
    final recipesProvider = Provider.of<RecipesProvider>(
      context,
      listen: false,
    );
    final missingCount = recipesProvider.missingCountFor(recipe.id);
    if (missingCount > 0) {
      return '$missingCount missing';
    }
    return 'All available';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.xl),
          ),
        ),
      ),
      color: AppColors.white.withValues(alpha: 0.95),
      child: Padding(
        padding: ResponsiveUtils.padding(context, ResponsiveSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RecipeImage(imageUrl: recipe.image),
            const ResponsiveSpacingWidget.horizontal(ResponsiveSpacing.md),
            Expanded(
              child: _ContainerRecipeDetails(
                recipe: recipe,
                ingredientsStatusText: _getIngredientsStatusText(context),
                warning: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContainerRecipeDetails extends StatelessWidget {
  final Recipe recipe;
  final String ingredientsStatusText;
  final bool warning;

  const _ContainerRecipeDetails({
    required this.recipe,
    required this.ingredientsStatusText,
    this.warning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          recipe.name,
          style: AppTextStyles.casta(
            letterSpacing: 1.7,
            fontSize:
                ResponsiveUtils.fontSize(context, ResponsiveFontSize.xl) * 1.2,
            height: 1.1,
            fontWeight: AppFontWeights.bold,
            color: AppColors.button,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.sm),
        _RecipeInfoChips(
          recipe: recipe,
          ingredientsStatusText: ingredientsStatusText,
          warning: warning,
        ),
      ],
    );
  }
}

/// Elegant chips displaying recipe information with descriptive icons
class _RecipeInfoChips extends StatelessWidget {
  final Recipe recipe;
  final String ingredientsStatusText;
  final bool warning;

  const _RecipeInfoChips({
    required this.recipe,
    required this.ingredientsStatusText,
    this.warning = false,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return Wrap(
          spacing: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
          runSpacing: ResponsiveUtils.spacing(context, ResponsiveSpacing.xxs),
          children: [
            _InfoChip(
              icon: Icons.access_time_rounded,
              label: recipe.cookingTime ?? "N/A",
              backgroundColor: AppColors.mutedGreen.withValues(alpha: 0.1),
              iconColor: AppColors.mutedGreen,
              textColor: AppColors.mutedGreen,
            ),
            _InfoChip(
              icon: _getDifficultyIcon(recipe.difficulty),
              label: recipe.difficulty ?? "N/A",
              backgroundColor: AppColors.lightYellow.withValues(alpha: 0.08),
              iconColor: AppColors.background,
              textColor: AppColors.background,
            ),
            _InfoChip(
              icon:
                  ingredientsStatusText.contains('missing')
                      ? Icons.inventory_2_outlined
                      : Icons.check_circle_outline_rounded,
              label: ingredientsStatusText,
              backgroundColor: _getIngredientsChipColor().withValues(
                alpha: 0.1,
              ),
              iconColor: _getIngredientsChipColor(),
              textColor: _getIngredientsChipColor(),
            ),
          ],
        );
      },
    );
  }

  IconData _getDifficultyIcon(String? difficulty) {
    switch (difficulty?.toLowerCase()) {
      case 'easy':
        return Icons.sentiment_very_satisfied_rounded;
      case 'medium':
        return Icons.sentiment_satisfied_rounded;
      case 'hard':
        return Icons.sentiment_neutral_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  Color _getIngredientsChipColor() {
    if (warning) return AppColors.orange;
    return ingredientsStatusText.contains('missing')
        ? AppColors.orange
        : AppColors.mutedGreen;
  }
}

/// Individual info chip component with icon and text
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.iconColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        final chipPadding = switch (deviceType) {
          DeviceType.iPhone => EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
            vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.xxs),
          ),
          DeviceType.iPadMini => EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
          ),
          DeviceType.iPadPro => EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
          ),
        };

        return Container(
          padding: chipPadding,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
            ),
            border: Border.all(
              color: iconColor.withValues(alpha: 0.2),
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.sm),
                color: iconColor,
              ),
              ResponsiveSpacingWidget.horizontal(ResponsiveSpacing.xxs),
              Text(
                label,
                style: TextStyle(
                  fontSize: ResponsiveUtils.fontSize(
                    context,
                    ResponsiveFontSize.xs,
                  ),
                  color: textColor,
                  fontFamily: 'Inter',
                  fontWeight: AppFontWeights.medium,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}
