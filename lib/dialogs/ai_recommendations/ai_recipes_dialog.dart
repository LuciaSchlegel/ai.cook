import 'package:ai_cook_project/dialogs/ai_recommendations/utils/helpers.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/ai_dialog_scaffold.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/builders/build_dialog.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/utils/close_button.dart';
import 'package:ai_cook_project/models/recipe_tag_model.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';

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
  List<RecipeTag> _selectedTags = [];
  final TextEditingController _maxTimeController = TextEditingController();
  String _selectedDifficulty = 'Easy';
  final TextEditingController _preferencesController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _apertureAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    _contentOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );

    _contentScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutBack),
      ),
    );

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
        if (!_hasGeneratedRecommendations) {
          _generateAIRecommendations();
          _hasGeneratedRecommendations = true;
        }
      } else {
        _controller.reverse();
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
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return AiDialogScaffold(
          isOpen: widget.isOpen,
          controller: _controller,
          apertureAnimation: _apertureAnimation,
          contentOpacityAnimation: _contentOpacityAnimation,
          contentScaleAnimation: _contentScaleAnimation,
          onClose: _handleClose,
          scrollContentBuilder: (scrollController) {
            final mq = MediaQuery.of(context);
            final safeHeight =
                mq.size.height - mq.padding.top - mq.padding.bottom;
            final maxH = safeHeight * 0.9; // o 0.88–0.95 según diseño

            return SafeArea(
              // Handle top safe area (notch/status bar) but let bottom be handled by scroll content
              top: true,
              bottom: false, // Let scroll content handle bottom safe area
              child: AnimatedPadding(
                // sube el contenido con teclado
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
                child: Center(
                  // centra y limita alto máx
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: maxH),
                    child: Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(
                            ResponsiveUtils.borderRadius(
                              context,
                              ResponsiveBorderRadius.xl,
                            ),
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.button.withValues(alpha: 0.1),
                            blurRadius: ResponsiveUtils.spacing(
                              context,
                              ResponsiveSpacing.sm,
                            ),
                            offset: Offset(
                              0,
                              ResponsiveUtils.spacing(
                                context,
                                ResponsiveSpacing.sm,
                              ),
                            ),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(
                            ResponsiveUtils.borderRadius(
                              context,
                              ResponsiveBorderRadius.xl,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            // Fixed header with close button (non-scrollable)
                            SizedBox(
                              height: ResponsiveUtils.getDialogTopPadding(
                                context,
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: ResponsiveUtils.spacing(
                                      context,
                                      ResponsiveSpacing.sm,
                                    ),
                                    right: ResponsiveUtils.spacing(
                                      context,
                                      ResponsiveSpacing.sm,
                                    ),
                                    child: CloseButtonExt(
                                      handleClose: _handleClose,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Scrollable content area
                            Expanded(
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () => FocusScope.of(context).unfocus(),
                                child: CustomScrollView(
                                  controller: scrollController,
                                  physics: const ClampingScrollPhysics(),
                                  slivers: [
                                    // Main dialog content
                                    SliverPadding(
                                      padding: ResponsiveUtils.padding(
                                        context,
                                        ResponsiveSpacing.md,
                                      ),
                                      sliver: SliverToBoxAdapter(
                                        child: BuildDialog(
                                          selectedTags: _selectedTags,
                                          onTagSelectionChanged: (tags) {
                                            setState(
                                              () => _selectedTags = tags,
                                            );
                                          },
                                          maxTimeController: _maxTimeController,
                                          preferencesController:
                                              _preferencesController,
                                          selectedDifficulty:
                                              _selectedDifficulty,
                                          onDifficultyChanged: (value) {
                                            setState(
                                              () => _selectedDifficulty = value,
                                            );
                                          },
                                          generateAiRecommendations:
                                              _generateAIRecommendations,
                                        ),
                                      ),
                                    ),
                                    // Add safe area padding at bottom for proper scrolling
                                    SliverToBoxAdapter(
                                      child: SizedBox(
                                        height:
                                            ResponsiveUtils.getScrollBottomPadding(
                                              context,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
