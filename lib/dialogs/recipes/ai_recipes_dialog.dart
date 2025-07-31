import 'package:ai_cook_project/models/recipe_tag_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_cook_project/providers/ai_recommendations_provider.dart';
import 'package:ai_cook_project/providers/ingredients_provider.dart';
import 'package:ai_cook_project/providers/resource_provider.dart';
import 'package:ai_cook_project/widgets/status/loading_indicator.dart';
import 'package:ai_cook_project/widgets/selectors/grey_card_chips.dart';
import 'package:ai_cook_project/widgets/selectors/dropdown_selector.dart';
import 'package:ai_cook_project/theme.dart';
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
  final TextEditingController _maxTimeController = TextEditingController(
    text: '30',
  );
  String _selectedDifficulty = 'Easy';
  final TextEditingController _preferencesController = TextEditingController(
    text: 'I enjoy Mediterranean cuisine',
  );

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
                                    color: Colors.black26,
                                    blurRadius: 20,
                                    offset: const Offset(0, -5),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // Handle bar
                                  Container(
                                    margin: const EdgeInsets.only(top: 12),
                                    width: 40,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),

                                  // Close button
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      onPressed: _handleClose,
                                      icon: const Icon(
                                        CupertinoIcons.xmark,
                                        color: Colors.grey,
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
            const Text(
              'AI Recipe Recommendations',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

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

            // Generate/Regenerate recommendations button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  debugPrint('🔄 AI Dialog: Manual regeneration triggered');
                  _generateAIRecommendations();
                },
                icon: const Icon(Icons.auto_awesome),
                label: Text(
                  aiProvider.currentRecommendation == null
                      ? 'Generate AI Recommendations'
                      : 'Update Recommendations',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.button,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoadingContent() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingIndicator(),
            SizedBox(height: 16),
            Text(
              '🤖 AI is analyzing your ingredients...',
              style: TextStyle(fontSize: 16, color: Colors.blue),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'This may take a few seconds',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorContent(String error) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                '❌ AI Error',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error,
                style: const TextStyle(fontSize: 14, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationsContent(AIRecommendation recommendation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Success indicator with stats
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '✅ AI processed ${recommendation.totalRecipesConsidered} recipes in ${recommendation.processingTime}ms',
                  style: const TextStyle(fontSize: 12, color: Colors.green),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // AI Recommendations text
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🤖 AI Recommendations:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                recommendation.recommendations,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),

        // Filtered recipes info
        if (recommendation.filteredRecipes.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            '📖 ${recommendation.filteredRecipes.length} Recipes Considered:',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recommendation.filteredRecipes.length,
              itemBuilder: (context, index) {
                final recipe = recommendation.filteredRecipes[index];
                return Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 8),
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe['name'] ?? 'Unknown Recipe',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Time: ${recipe['cookingTime'] ?? 'N/A'}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'Difficulty: ${recipe['difficulty'] ?? 'N/A'}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
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
        ],
      ],
    );
  }

  Widget _buildEmptyContent() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.sparkles, size: 48, color: Colors.blue),
            SizedBox(height: 16),
            Text(
              'Ready to generate AI recommendations!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Click the button below to start',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🎯 Customize Your AI Recommendations',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Recipe Tags Selector
          const Text(
            'Preferred Recipe Tags',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
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
                    const Text(
                      'Max Cooking Time (minutes)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
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
                    const Text(
                      'Preferred Difficulty',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownSelector(
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
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // User Preferences
          const Text(
            'Additional Preferences (optional)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
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
