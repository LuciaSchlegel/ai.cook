import 'package:ai_cook_project/models/ai_response_model.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:flutter/material.dart';

class RecipeDetails extends StatelessWidget {
  final CombinedRecipeViewModel viewModel;

  const RecipeDetails({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final recipe = viewModel.recipe;
    final description = viewModel.description ?? recipe.description;
    final missingIngredients = viewModel.missingIngredients;
    final missingCount = viewModel.missingCount;
    return Padding(
      padding: ResponsiveUtils.padding(context, ResponsiveSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic recipe info - Enhanced with better icons
          Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.sm),
                color: AppColors.button.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 4),
              Text(
                recipe.cookingTime ?? 'N/A',
                style: TextStyle(
                  fontSize: ResponsiveUtils.fontSize(
                    context,
                    ResponsiveFontSize.sm,
                  ),
                  fontWeight: AppFontWeights.semiBold,
                  fontFamily: 'Inter',
                  letterSpacing: 0.2,
                  color: AppColors.button.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.signal_cellular_alt_rounded,
                size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.sm),
                color: AppColors.button.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 4),
              Text(
                recipe.difficulty ?? 'N/A',
                style: TextStyle(
                  fontSize: ResponsiveUtils.fontSize(
                    context,
                    ResponsiveFontSize.sm,
                  ),
                  fontWeight: AppFontWeights.semiBold,
                  fontFamily: 'Inter',
                  letterSpacing: 0.2,
                  color: AppColors.button.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),

          const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.md),

          // AI Reasoning - PROMINENT with special styling
          Container(
            padding: ResponsiveUtils.padding(context, ResponsiveSpacing.md),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.mutedGreen.withValues(alpha: 0.1),
                  AppColors.lightYellow.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
              ),
              border: Border.all(
                color: AppColors.mutedGreen.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.mutedGreen,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.sm),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Why This Recipe',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.fontSize(
                            context,
                            ResponsiveFontSize.xs,
                          ),
                          fontWeight: AppFontWeights.bold,
                          fontFamily: 'Inter',
                          letterSpacing: 0.5,
                          color: AppColors.mutedGreen,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: ResponsiveUtils.fontSize(
                            context,
                            ResponsiveFontSize.sm,
                          ),
                          color: AppColors.button.withValues(alpha: 0.9),
                          fontWeight: AppFontWeights.medium,
                          fontFamily: 'Inter',
                          letterSpacing: 0.2,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Missing ingredients section
          if (missingCount > 0) ...[
            const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.md),
            Container(
              padding: ResponsiveUtils.padding(context, ResponsiveSpacing.md),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.button.withValues(alpha: 0.06),
                    AppColors.lightYellow.withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
                ),
                border: Border.all(
                  color: AppColors.button.withValues(alpha: 0.25),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.button.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.shopping_basket_outlined,
                          size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.sm),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
                      ),
                      Text(
                        'Missing Ingredients',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.fontSize(
                            context,
                            ResponsiveFontSize.sm,
                          ),
                          fontWeight: AppFontWeights.bold,
                          fontFamily: 'Inter',
                          letterSpacing: 0.3,
                          color: AppColors.button.withValues(alpha: 0.85),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
                          vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.button.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$missingCount',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.fontSize(
                              context,
                              ResponsiveFontSize.xs,
                            ),
                            fontWeight: AppFontWeights.bold,
                            fontFamily: 'Inter',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Ingredients list
                  ...missingIngredients!.asMap().entries.map((entry) {
                    final missing = entry.value;
                    final displayText = missing.quantity != null
                        ? '${missing.name} (${missing.quantity} ${missing.unit ?? 'units'})'
                        : missing.name;

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: entry.key < missingIngredients.length - 1 ? 8 : 0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: AppColors.button.withValues(alpha: 0.6),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              displayText,
                              style: TextStyle(
                                fontSize: ResponsiveUtils.fontSize(
                                  context,
                                  ResponsiveFontSize.sm,
                                ),
                                fontWeight: AppFontWeights.medium,
                                fontFamily: 'Inter',
                                letterSpacing: 0.2,
                                height: 1.5,
                                color: AppColors.button.withValues(alpha: 0.8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],

          // AI Cooking Tips section (shown by default)
          if (viewModel.cookingTips.isNotEmpty) ...[
            const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.md),
            _CookingTipsSection(cookingTips: viewModel.cookingTips),
          ],

          // Recipe-specific substitutions section
          if (viewModel.recipeSubstitutions.isNotEmpty) ...[
            const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.md),
            Container(
              padding: ResponsiveUtils.padding(context, ResponsiveSpacing.md),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.mutedGreen.withValues(alpha: 0.08),
                    AppColors.lightYellow.withValues(alpha: 0.12),
                  ],
                ),
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
                ),
                border: Border.all(
                  color: AppColors.mutedGreen.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.mutedGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.swap_horiz_rounded,
                          size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.sm),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
                      ),
                      Text(
                        'Suggested Substitutions',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.fontSize(
                            context,
                            ResponsiveFontSize.sm,
                          ),
                          fontWeight: AppFontWeights.bold,
                          fontFamily: 'Inter',
                          letterSpacing: 0.3,
                          color: AppColors.mutedGreen,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
                          vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.mutedGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${viewModel.recipeSubstitutions.length}',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.fontSize(
                              context,
                              ResponsiveFontSize.xs,
                            ),
                            fontWeight: AppFontWeights.bold,
                            fontFamily: 'Inter',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Substitutions list
                  ...viewModel.recipeSubstitutions.asMap().entries.map((entry) {
                    final sub = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: entry.key < viewModel.recipeSubstitutions.length - 1 ? 10 : 0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 3),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.mutedGreen.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              size: 14,
                              color: AppColors.mutedGreen,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.fontSize(
                                    context,
                                    ResponsiveFontSize.sm,
                                  ),
                                  fontWeight: AppFontWeights.medium,
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.2,
                                  height: 1.5,
                                  color: AppColors.button.withValues(alpha: 0.85),
                                ),
                                children: [
                                  TextSpan(
                                    text: sub.original,
                                    style: TextStyle(
                                      fontWeight: AppFontWeights.semiBold,
                                      color: AppColors.button,
                                    ),
                                  ),
                                  const TextSpan(text: ' → '),
                                  TextSpan(
                                    text: sub.alternatives.join(", "),
                                    style: TextStyle(
                                      color: AppColors.mutedGreen,
                                      fontWeight: AppFontWeights.semiBold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],

          // Tags if available - Enhanced with app colors
          if (recipe.tags.isNotEmpty) ...[
            const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.md),
            Wrap(
              spacing: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
              runSpacing: ResponsiveUtils.spacing(
                context,
                ResponsiveSpacing.xs,
              ),
              children:
                  (recipe.tags).take(4).map((tag) {
                    return Container(
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
                      decoration: BoxDecoration(
                        color: AppColors.lightYellow.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.borderRadius(
                            context,
                            ResponsiveBorderRadius.lg,
                          ),
                        ),
                        border: Border.all(
                          color: AppColors.button.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        tag.name,
                        style: TextStyle(
                          fontSize: ResponsiveUtils.fontSize(
                            context,
                            ResponsiveFontSize.xs,
                          ),
                          color: AppColors.button,
                          fontWeight: AppFontWeights.semiBold,
                          fontFamily: 'Inter',
                          letterSpacing: 0.3,
                          height: 1,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

// AI Cooking Tips section - Always expanded with enhanced visuals
class _CookingTipsSection extends StatelessWidget {
  final List<String> cookingTips;

  const _CookingTipsSection({required this.cookingTips});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveUtils.padding(context, ResponsiveSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.lightYellow.withValues(alpha: 0.15),
            AppColors.orange.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
        ),
        border: Border.all(
          color: AppColors.orange.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.lightbulb,
                  size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.sm),
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
              ),
              Text(
                'AI Cooking Tips',
                style: TextStyle(
                  fontSize: ResponsiveUtils.fontSize(
                    context,
                    ResponsiveFontSize.sm,
                  ),
                  fontWeight: AppFontWeights.bold,
                  fontFamily: 'Inter',
                  letterSpacing: 0.3,
                  color: AppColors.orange,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
                  vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
                ),
                decoration: BoxDecoration(
                  color: AppColors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${cookingTips.length}',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.xs,
                    ),
                    fontWeight: AppFontWeights.bold,
                    fontFamily: 'Inter',
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Tips list
          ...cookingTips.asMap().entries.map((entry) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: entry.key < cookingTips.length - 1 ? 8 : 0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.orange.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.fontSize(
                            context,
                            ResponsiveFontSize.xs,
                          ),
                          fontWeight: AppFontWeights.bold,
                          fontFamily: 'Inter',
                          color: AppColors.orange,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        fontSize: ResponsiveUtils.fontSize(
                          context,
                          ResponsiveFontSize.sm,
                        ),
                        fontWeight: AppFontWeights.medium,
                        fontFamily: 'Inter',
                        letterSpacing: 0.2,
                        height: 1.5,
                        color: AppColors.button.withValues(alpha: 0.85),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
