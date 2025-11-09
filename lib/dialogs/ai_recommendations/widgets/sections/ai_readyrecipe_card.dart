import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/utils/details_container.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/utils/image_clip.dart';
import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/utils/recipe_details.dart';
import 'package:ai_cook_project/models/ai_response_model.dart';
import 'package:ai_cook_project/screens/recipes/widgets/recipe_ov_card.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:flutter/material.dart';

class AIReadyToCookCard extends StatefulWidget {
  final CombinedRecipeViewModel viewModel;

  const AIReadyToCookCard({super.key, required this.viewModel});

  @override
  State<AIReadyToCookCard> createState() => _AIReadyToCookCardState();
}

class _AIReadyToCookCardState extends State<AIReadyToCookCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showRecipeDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RecipeOverviewCard(recipe: widget.viewModel.recipe),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.viewModel.recipe;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
          ),
          child: GestureDetector(
            onTap: () => _showRecipeDetail(context),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.xl),
                ),
                border: Border.all(
                  color: widget.viewModel.missingCount == 0
                      ? AppColors.mutedGreen
                      : AppColors.mutedGreen.withValues(alpha: 0.6),
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.mutedGreen.withValues(alpha: 0.15),
                    blurRadius: ResponsiveUtils.spacing(
                      context,
                      ResponsiveSpacing.md,
                    ),
                    offset: const Offset(0, 3),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (recipe.image != null && recipe.image!.isNotEmpty)
                    ImageClip(viewModel: widget.viewModel),
                  DetailsContainer(viewModel: widget.viewModel),
                  RecipeDetails(viewModel: widget.viewModel),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
