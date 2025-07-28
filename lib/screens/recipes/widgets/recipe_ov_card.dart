import 'package:ai_cook_project/dialogs/recipes/expanded_recipe_dialog.dart';
import 'package:ai_cook_project/screens/recipes/widgets/recipe_glance_card.dart';
import 'package:ai_cook_project/screens/recipes/widgets/recipe_header.dart';
import 'package:ai_cook_project/screens/recipes/widgets/recipe_tags.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/widgets/utils/swipe.dart';
import 'package:flutter/material.dart';
import '../../../models/recipe_model.dart';

class RecipeOverviewCard extends StatefulWidget {
  final Recipe recipe;

  const RecipeOverviewCard({super.key, required this.recipe});

  @override
  State<RecipeOverviewCard> createState() => _RecipeOverviewCardState();
}

class _RecipeOverviewCardState extends State<RecipeOverviewCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  double _dragStart = 0;
  static const double _dragThreshold = 50.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (details.primaryDelta! < 0) {
      if (_dragStart == 0) {
        _dragStart = details.globalPosition.dy;
      }
      if (_dragStart - details.globalPosition.dy > _dragThreshold) {
        _showExpandedDialog();
      }
    } else if (details.primaryDelta! > 0) {
      if (_dragStart == 0) {
        _dragStart = details.globalPosition.dy;
      }
      if (details.globalPosition.dy - _dragStart > _dragThreshold) {
        Navigator.pop(context);
      }
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    _dragStart = 0;
  }

  void _showExpandedDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      transitionAnimationController: _animationController,
      builder: (context) => RecipeExpandedDialog(recipe: widget.recipe),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: size.height * 0.04,
      ),
      child: GestureDetector(
        onVerticalDragUpdate: _handleDragUpdate,
        onVerticalDragEnd: _handleDragEnd,
        child: Card(
          elevation: 6,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          clipBehavior: Clip.antiAlias,
          color: AppColors.white,
          child: SizedBox(
            height: size.height * 0.85,
            width: size.width * 0.88,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RecipeHeader(
                        recipe: widget.recipe,
                        onClose: () => Navigator.pop(context),
                      ),
                      const SizedBox(height: 16),
                      RecipeTags(
                        tags:
                            widget.recipe.tags.map((tag) => tag.name).toList(),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: RecipeGlanceCard(
                          recipe: widget.recipe,
                          size: size,
                        ),
                      ),
                    ],
                  ),
                ),
                const SwipeIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
