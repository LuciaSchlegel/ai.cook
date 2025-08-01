import 'package:ai_cook_project/models/recipe_tag_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_cook_project/providers/ai_recommendations_provider.dart';
import 'package:ai_cook_project/providers/ingredients_provider.dart';
import 'package:ai_cook_project/providers/resource_provider.dart';

import 'package:ai_cook_project/widgets/selectors/grey_card_chips.dart';
import 'package:ai_cook_project/widgets/selectors/dropdown_selector.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/dialogs/recipes/widgets/ai_recipe_card.dart';
import 'package:ai_cook_project/dialogs/recipes/widgets/skeleton_loader.dart';
import 'package:ai_cook_project/dialogs/recipes/widgets/ai_response_sections.dart';
import 'dart:math' as math;

class AiRecipesDialog extends StatefulWidget {
  final VoidCallback onToggle;
  final bool isOpen;

  const AiRecipesDialog({
    super.key,
    required this.onToggle,
    required this.isOpen,
  });

  @override
  State<AiRecipesDialog> createState() => _AiRecipesDialogState();
}

class _AiRecipesDialogState extends State<AiRecipesDialog>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _apertureAnimation;
  late Animation<double> _contentOpacityAnimation;
  late Animation<double> _contentScaleAnimation;
  bool _hasGeneratedRecommendations = false;

  // Form state variables
  List<RecipeTag> _selectedTags = [];
  final TextEditingController _maxTimeController = TextEditingController();
  String _selectedDifficulty = 'Easy';
  final TextEditingController _preferencesController = TextEditingController();

  // Available options
  final List<String> _difficultyLevels = ['Easy', 'Medium', 'Hard'];

  @override
  void initState() {
    super.initState();

    // Single controller for all animations
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // Aperture animation (0.0 to 0.5)
    _apertureAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    // Content opacity (delayed, 0.3 to 1.0)
    _contentOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Content scale (delayed, 0.3 to 1.0)
    _contentScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutBack),
      ),
    );

    // Start animation if dialog should be open
    if (widget.isOpen) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AiRecipesDialog oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isOpen != oldWidget.isOpen) {
      if (widget.isOpen) {
        _controller.forward();
        // Generate AI recommendations when dialog opens
        if (!_hasGeneratedRecommendations) {
          _generateAIRecommendations();
          _hasGeneratedRecommendations = true;
        }
      } else {
        _controller.reverse();
        // Reset the flag when dialog closes
        _hasGeneratedRecommendations = false;
      }
    }
  }

  void _generateAIRecommendations() {
    debugPrint('🤖 AI Dialog: Starting recommendation generation...');

    final ingredientsProvider = Provider.of<IngredientsProvider>(
      context,
      listen: false,
    );

    final aiProvider = Provider.of<AIRecommendationsProvider>(
      context,
      listen: false,
    );

    debugPrint(
      '🥘 User ingredients count: ${ingredientsProvider.userIngredients.length}',
    );
    debugPrint(
      '🏷️ Selected tags: ${_selectedTags.map((t) => t.name).join(', ')}',
    );
    debugPrint('⏱️ Max cooking time: ${_maxTimeController.text} minutes');
    debugPrint('🎯 Difficulty: $_selectedDifficulty');
    debugPrint('💭 User preferences: ${_preferencesController.text}');

    final maxTime = int.tryParse(_maxTimeController.text) ?? 30;

    aiProvider.generateRecommendations(
      input: AIRecomendationInput(
        userIngredients: ingredientsProvider.userIngredients,
        preferredTags: _selectedTags, // Use selected RecipeTag objects directly
        maxCookingTimeMinutes: maxTime,
        preferredDifficulty: _selectedDifficulty,
        userPreferences:
            _preferencesController.text.trim().isEmpty
                ? null
                : _preferencesController.text.trim(),
        numberOfRecipes: 5,
      ),
    );

    debugPrint('🚀 AI Dialog: Recommendation request sent!');
  }

  void _handleClose() {
    widget.onToggle();
  }

  @override
  void dispose() {
    _controller.dispose();
    _maxTimeController.dispose();
    _preferencesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Only build when open or animating
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Don't render if completely closed
        if (!widget.isOpen && _controller.value == 0.0) {
          return const SizedBox.shrink();
        }

        final size = MediaQuery.of(context).size;
        final maxRadius = math.sqrt(
          size.width * size.width + size.height * size.height,
        );

        return Material(
          type: MaterialType.transparency,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black54.withOpacity(_controller.value * 0.5),
            child: Stack(
              children: [
                // Background overlay
                GestureDetector(
                  onTap: _handleClose,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.transparent,
                  ),
                ),

                // Main dialog with aperture animation
                ClipPath(
                  clipper: OptimizedApertureClipper(
                    progress: _apertureAnimation.value,
                    maxRadius: maxRadius,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: DraggableScrollableSheet(
                      initialChildSize: 0.9,
                      minChildSize: 0.5,
                      maxChildSize: 0.95,
                      builder: (context, scrollController) {
                        return Transform.scale(
                          scale: _contentScaleAnimation.value,
                          child: Opacity(
                            opacity: _contentOpacityAnimation.value,
                            child: Container(
                              decoration: BoxDecoration(
                                color: CupertinoColors.white,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(30),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.button.withOpacity(0.08),
                                    blurRadius: 32,
                                    offset: const Offset(0, -8),
                                    spreadRadius: 0,
                                  ),
                                  BoxShadow(
                                    color: AppColors.mutedGreen.withOpacity(
                                      0.04,
                                    ),
                                    blurRadius: 16,
                                    offset: const Offset(0, -4),
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // Handle bar - Enhanced
                                  Container(
                                    margin: const EdgeInsets.only(top: 12),
                                    width: 40,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.mutedGreen.withOpacity(0.2),
                                          AppColors.mutedGreen.withOpacity(0.4),
                                          AppColors.mutedGreen.withOpacity(0.2),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),

                                  // Close button - Enhanced
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 8,
                                        right: 8,
                                      ),
                                      child: Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: AppColors.mutedGreen
                                              .withOpacity(0.08),
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                        ),
                                        child: IconButton(
                                          onPressed: _handleClose,
                                          icon: Icon(
                                            CupertinoIcons.xmark,
                                            color: AppColors.button.withOpacity(
                                              0.6,
                                            ),
                                            size: 16,
                                          ),
                                          padding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Content area
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: SingleChildScrollView(
                                        controller: scrollController,
                                        child: _buildDialogContent(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogContent() {
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
            _buildFormSection(),
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
                  _generateAIRecommendations();
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

  Widget _buildLoadingContent() {
    return const SkeletonLoader();
  }

  Widget _buildErrorContent(String error) {
    return Container(
      height: 220,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.orange.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(color: AppColors.orange.withOpacity(0.2), width: 1),
      ),
      child: Stack(
        children: [
          // Subtle gradient background
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.orange.withOpacity(0.03),
                  AppColors.lightYellow.withOpacity(0.03),
                ],
              ),
            ),
          ),
          // Main content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Error icon
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.orange.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      CupertinoIcons.exclamationmark_triangle,
                      size: 32,
                      color: AppColors.orange,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Title
                  const Text(
                    'AI Chef Unavailable',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.button,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  // Error message
                  Text(
                    error,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.button.withOpacity(0.7),
                      height: 1.4,
                      letterSpacing: 0.1,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsContent(AIRecommendation recommendation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Success indicator with stats - Enhanced design
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.mutedGreen.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 2),
                spreadRadius: 0,
              ),
            ],
            border: Border.all(
              color: AppColors.mutedGreen.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.mutedGreen.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  CupertinoIcons.checkmark_alt,
                  color: AppColors.mutedGreen,
                  size: 14,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Successfully analyzed ${recommendation.totalRecipesConsidered} recipes in ${recommendation.processingTime}ms',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.button.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Structured AI Response Sections
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            AIGreetingSection(greeting: recommendation.parsedResponse.greeting),

            // Almost ready recipes
            AIAlmostReadySection(
              content: recommendation.parsedResponse.almostReadySection,
            ),

            // Recipe cards with missing ingredient info - Moved here between sections
            if (recommendation.recipesWithMissingInfo != null &&
                recommendation.recipesWithMissingInfo!.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildRecipeCards(recommendation.recipesWithMissingInfo!),
              const SizedBox(height: 20),
            ],

            // Shopping suggestions
            AIShoppingSuggestionsSection(
              suggestions: recommendation.parsedResponse.shoppingSuggestions,
            ),

            // Substitutions
            AISubstitutionsSection(
              substitutions: recommendation.parsedResponse.substitutions,
            ),

            // Conclusion
            AIConclusionSection(
              conclusion: recommendation.parsedResponse.conclusion,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecipeCards(
    List<RecipeWithMissingIngredients> recipesWithMissingInfo,
  ) {
    // Group recipes by missing count
    final perfectMatches = <RecipeWithMissingIngredients>[];
    final almostReady = <RecipeWithMissingIngredients>[];

    for (final recipeData in recipesWithMissingInfo) {
      if (recipeData.missingCount == 0) {
        perfectMatches.add(recipeData);
      } else {
        almostReady.add(recipeData);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Perfect matches section
        if (perfectMatches.isNotEmpty) ...[
          Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              Text(
                'Ready to Cook (${perfectMatches.length})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...perfectMatches
              .map(
                (recipeData) => AIRecipeCard(recipeWithMissingInfo: recipeData),
              )
              .toList(),
        ],

        // Almost ready section
        if (almostReady.isNotEmpty) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.shopping_cart, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              Text(
                'Almost Ready (${almostReady.length})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...almostReady
              .map(
                (recipeData) => AIRecipeCard(recipeWithMissingInfo: recipeData),
              )
              .toList(),
        ],
      ],
    );
  }

  Widget _buildEmptyContent() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.mutedGreen.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: AppColors.mutedGreen.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Subtle gradient background
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.lightYellow.withOpacity(0.02),
                  AppColors.mutedGreen.withOpacity(0.02),
                ],
              ),
            ),
          ),
          // Main content with flexible layout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon with background
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.mutedGreen.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    CupertinoIcons.sparkles,
                    size: 28,
                    color: AppColors.mutedGreen,
                  ),
                ),
                const SizedBox(height: 16),
                // Title
                const Text(
                  'AI Chef Ready',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.button,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // Subtitle with flexible text
                Flexible(
                  child: Text(
                    'Set your preferences above and tap the button below to get personalized recipe recommendations',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.button.withOpacity(0.7),
                      height: 1.3,
                      letterSpacing: 0.1,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
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
              final selectedTagNames =
                  _selectedTags.map((t) => t.name).toList();

              return GreyCardChips(
                items: availableTagNames,
                selectedItems: selectedTagNames,
                onSelected: (newSelectedNames) {
                  setState(() {
                    // Convert selected tag names back to RecipeTag objects
                    _selectedTags =
                        resourceProvider.recipeTags
                            .where((tag) => newSelectedNames.contains(tag.name))
                            .toList();
                  });
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
                        controller: _maxTimeController,
                        keyboardType: TextInputType.number,
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
                        value: _selectedDifficulty,
                        items: _difficultyLevels,
                        onChanged: (newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedDifficulty = newValue;
                            });
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
              controller: _preferencesController,
              placeholder: 'e.g. I prefer spicy food, vegetarian dishes...',
              maxLines: 3,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              placeholderStyle: TextStyle(
                color: AppColors.button.withOpacity(0.5),
                fontSize: 16,
              ),
              style: const TextStyle(color: AppColors.button, fontSize: 16),
              decoration: null,
              cursorColor: AppColors.mutedGreen,
            ),
          ),
        ],
      ),
    );
  }
}

// Optimized clipper that caches expensive calculations
class OptimizedApertureClipper extends CustomClipper<Path> {
  final double progress;
  final double maxRadius;

  // Cache for expensive calculations
  static final Map<String, Path> _pathCache = {};

  OptimizedApertureClipper({required this.progress, required this.maxRadius});

  @override
  Path getClip(Size size) {
    // Create cache key
    final key = '${size.width}-${size.height}-${progress.toStringAsFixed(3)}';

    // Return cached path if available
    if (_pathCache.containsKey(key)) {
      return _pathCache[key]!;
    }

    // Calculate and cache new path
    final center = Offset(size.width / 2, size.height / 2);
    final radius = maxRadius * progress;

    final path = Path();
    path.addOval(Rect.fromCircle(center: center, radius: radius));

    // Cache the path (limit cache size)
    if (_pathCache.length > 50) {
      _pathCache.clear();
    }
    _pathCache[key] = path;

    return path;
  }

  @override
  bool shouldReclip(OptimizedApertureClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}
