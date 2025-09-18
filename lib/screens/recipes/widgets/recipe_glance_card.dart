import 'package:ai_cook_project/models/recipe_model.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/widgets/cards/recipe_ing_card.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:flutter/material.dart';

class RecipeGlanceCard extends StatelessWidget {
  final Recipe recipe;
  final Size size;
  final List<UserIng> userIngredients;

  const RecipeGlanceCard({
    required this.recipe,
    required this.size,
    required this.userIngredients,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        // Responsive sizing
        final cardWidth = switch (deviceType) {
          DeviceType.iPhone => size.width * 0.92,
          DeviceType.iPadMini => size.width * 0.85,
          DeviceType.iPadPro => size.width * 0.75,
        };

        final cardHeight = switch (deviceType) {
          DeviceType.iPhone => size.height * 0.58,
          DeviceType.iPadMini => size.height * 0.48,
          DeviceType.iPadPro => size.height * 0.45,
        };

        return Container(
          width: cardWidth,
          height: cardHeight,
          padding: ResponsiveUtils.padding(context, ResponsiveSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.xl),
            ),
            border: Border.all(
              color: AppColors.mutedGreen.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.08),
                blurRadius: ResponsiveUtils.spacing(
                  context,
                  ResponsiveSpacing.md,
                ),
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section with responsive spacing
              Row(
                children: [
                  Container(
                    padding: ResponsiveUtils.padding(
                      context,
                      ResponsiveSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.mutedGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.borderRadius(
                          context,
                          ResponsiveBorderRadius.md,
                        ),
                      ),
                    ),
                    child: Icon(
                      Icons.visibility_outlined,
                      size: ResponsiveUtils.iconSize(
                        context,
                        ResponsiveIconSize.md,
                      ),
                      color: AppColors.mutedGreen,
                    ),
                  ),
                  ResponsiveSpacingWidget.horizontal(ResponsiveSpacing.sm),
                  Expanded(
                    child: Text(
                      'Quick Overview',
                      style: AppTextStyles.casta(
                        fontSize:
                            ResponsiveUtils.fontSize(
                              context,
                              ResponsiveFontSize.xxl,
                            ) *
                            1.2,
                        fontWeight: AppFontWeights.semiBold,
                        letterSpacing: 0.4,
                        color: AppColors.button,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),

              ResponsiveSpacingWidget.vertical(ResponsiveSpacing.md),

              // Info Chips Section (replacing cards)
              _RecipeInfoChips(recipe: recipe),

              ResponsiveSpacingWidget.vertical(ResponsiveSpacing.lg),

              // Ingredients Section
              Expanded(
                child: _IngredientsSection(
                  recipe: recipe,
                  size: size,
                  userIngredients: userIngredients,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Elegant chips displaying recipe information with descriptive icons (Glance Card version)
class _RecipeInfoChips extends StatelessWidget {
  final Recipe recipe;

  const _RecipeInfoChips({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return Wrap(
          spacing: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
          runSpacing: ResponsiveUtils.spacing(context, ResponsiveSpacing.xxs),
          children: [
            _GlanceInfoChip(
              icon: Icons.access_time_rounded,
              label: recipe.cookingTime ?? "N/A",
              backgroundColor: AppColors.mutedGreen.withValues(alpha: 0.1),
              iconColor: AppColors.mutedGreen,
              textColor: AppColors.mutedGreen,
            ),
            _GlanceInfoChip(
              icon: _getDifficultyIcon(recipe.difficulty),
              label: recipe.difficulty ?? "N/A",
              backgroundColor: AppColors.lightYellow.withValues(alpha: 0.08),
              iconColor: AppColors.background,
              textColor: AppColors.background,
            ),
            _GlanceInfoChip(
              icon: Icons.people_outline_rounded,
              label: '${recipe.servings ?? 'N/A'} serves',
              backgroundColor: AppColors.orange.withValues(alpha: 0.1),
              iconColor: AppColors.orange,
              textColor: AppColors.orange,
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
}

/// Individual info chip component for glance card
class _GlanceInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;

  const _GlanceInfoChip({
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
            horizontal: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
          ),
          DeviceType.iPadMini => EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
            vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          ),
          DeviceType.iPadPro => EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
            vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          ),
        };

        return Container(
          padding: chipPadding,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.xl),
            ),
            border: Border.all(
              color: iconColor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.md),
                color: iconColor,
              ),
              ResponsiveSpacingWidget.horizontal(ResponsiveSpacing.xs),
              Text(
                label,
                style: AppTextStyles.inter(
                  fontSize: ResponsiveUtils.fontSize(
                    context,
                    ResponsiveFontSize.sm,
                  ),
                  color: textColor,
                  fontWeight: AppFontWeights.medium,
                  height: 1.2,
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

class _IngredientsSection extends StatelessWidget {
  final Recipe recipe;
  final Size size;
  final List<UserIng> userIngredients;

  const _IngredientsSection({
    required this.recipe,
    required this.size,
    required this.userIngredients,
  });

  @override
  Widget build(BuildContext context) {
    return RecipeIngCard(recipe: recipe, userIngredients: userIngredients);
  }
}
