import 'package:ai_cook_project/dialogs/ai_recommendations/utils/recommendations_function.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/build_dialog.dart';
import 'package:ai_cook_project/models/recipe_tag_model.dart';
import 'package:ai_cook_project/widgets/clippers/optimized_aperture_clipper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  final TextEditingController _maxTimeController = TextEditingController();
  String _selectedDifficulty = 'Easy';
  final TextEditingController _preferencesController = TextEditingController();

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
    generateAIRecommendationsHelper(
      context: context,
      selectedTags: _selectedTags,
      selectedDifficulty: _selectedDifficulty,
      maxTimeController: _maxTimeController,
      preferencesController: _preferencesController,
    );
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
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        // Dismiss keyboard when tapping outside input fields
                                        FocusScope.of(context).unfocus();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: SingleChildScrollView(
                                          controller: scrollController,
                                          child: BuildDialog(
                                            selectedTags: _selectedTags,
                                            onTagSelectionChanged: (tags) {
                                              setState(() {
                                                _selectedTags = tags;
                                              });
                                            },
                                            maxTimeController:
                                                _maxTimeController,
                                            preferencesController:
                                                _preferencesController,
                                            selectedDifficulty:
                                                _selectedDifficulty,
                                            onDifficultyChanged: (value) {
                                              setState(() {
                                                _selectedDifficulty = value;
                                              });
                                            },
                                            generateAiRecommendations:
                                                _generateAIRecommendations,
                                          ),
                                        ),
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
}
