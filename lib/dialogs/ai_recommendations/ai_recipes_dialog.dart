import 'package:ai_cook_project/dialogs/ai_recommendations/utils/recommendations_function.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/ai_dialog_scaffold.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/build_dialog.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/close_button.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/handle_bar.dart';
import 'package:ai_cook_project/models/recipe_tag_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    return AiDialogScaffold(
      isOpen: widget.isOpen,
      controller: _controller,
      apertureAnimation: _apertureAnimation,
      contentOpacityAnimation: _contentOpacityAnimation,
      contentScaleAnimation: _contentScaleAnimation,
      onClose: _handleClose,
      scrollContentBuilder:
          (scrollController) => Container(
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.08),
                  blurRadius: 32,
                  offset: const Offset(0, -8),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.secondary.withOpacity(0.04),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                const HandleBar(),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, right: 8),
                    child: CloseButtonExt(handleClose: _handleClose),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: BuildDialog(
                          selectedTags: _selectedTags,
                          onTagSelectionChanged: (tags) {
                            setState(() => _selectedTags = tags);
                          },
                          maxTimeController: _maxTimeController,
                          preferencesController: _preferencesController,
                          selectedDifficulty: _selectedDifficulty,
                          onDifficultyChanged: (value) {
                            setState(() => _selectedDifficulty = value);
                          },
                          generateAiRecommendations: _generateAIRecommendations,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
