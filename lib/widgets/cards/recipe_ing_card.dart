import 'package:ai_cook_project/models/recipe_ingredient_model.dart';
import 'package:ai_cook_project/models/recipe_model.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecipeIngCard extends StatelessWidget {
  final Recipe recipe;
  final List<UserIng> userIngredients;

  const RecipeIngCard({
    required this.recipe,
    required this.userIngredients,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
        ),
        border: Border.all(
          color: AppColors.mutedGreen.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
            offset: Offset(
              0,
              ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
            ),
          ),
        ],
      ),
      padding: ResponsiveUtils.padding(context, ResponsiveSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.shopping_basket_outlined,
                size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.md),
                color: AppColors.mutedGreen,
              ),
              const ResponsiveSpacingWidget.horizontal(ResponsiveSpacing.sm),
              Text(
                'Ingredients',
                style: AppTextStyles.casta(
                  fontSize:
                      ResponsiveUtils.fontSize(context, ResponsiveFontSize.lg) *
                      1.2,
                  fontWeight: AppFontWeights.semiBold,
                  color: AppColors.button,
                  letterSpacing: 0.2,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.xs,
                  ),
                  vertical: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.xxs,
                  ),
                ),
                decoration: BoxDecoration(
                  color: AppColors.mutedGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                    ResponsiveUtils.borderRadius(
                      context,
                      ResponsiveBorderRadius.sm,
                    ),
                  ),
                ),
                child: Text(
                  '${recipe.ingredients.length} items',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.sm,
                    ),
                    fontWeight: AppFontWeights.medium,
                    color: AppColors.mutedGreen,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
          const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.lg),
          if (recipe.ingredients.isNotEmpty)
            Expanded(
              child: ListView.separated(
                itemCount: recipe.ingredients.length,
                separatorBuilder:
                    (context, idx) => const ResponsiveSpacingWidget.vertical(
                      ResponsiveSpacing.sm,
                    ),
                itemBuilder:
                    (context, index) => _IngredientRow(
                      ingredient: recipe.ingredients[index],
                      userIngredients: userIngredients,
                    ),
                padding: EdgeInsets.zero,
              ),
            )
          else
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveUtils.spacing(
                  context,
                  ResponsiveSpacing.xs,
                ),
              ),
              child: Text(
                '• No ingredients listed',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: AppFontWeights.medium,
                  color: AppColors.button,
                  fontSize: ResponsiveUtils.fontSize(
                    context,
                    ResponsiveFontSize.sm,
                  ),
                  fontFamily: 'Inter',
                ),
              ),
            ),
        ],
      ),
    );
  }
}

enum IngredientAvailabilityStatus {
  available, // Green checkmark - has sufficient quantity
  insufficient, // Yellow warning - has ingredient but not enough quantity
  incompatible, // Yellow warning - has ingredient but incompatible units
  unavailable, // Red exclamation - doesn't have the ingredient
}

class _IngredientRow extends StatelessWidget {
  final RecipeIngredient ingredient;
  final List<UserIng> userIngredients;

  const _IngredientRow({
    required this.ingredient,
    required this.userIngredients,
  });

  IngredientAvailabilityStatus _getAvailabilityStatus() {
    // Find the user ingredient that matches this recipe ingredient (global id or custom name fuzzy)
    UserIng? userIng = userIngredients.firstWhere(
      (ui) => ui.ingredient?.id == ingredient.ingredient.id,
      orElse: () => UserIng(id: -1, uid: '', quantity: 0),
    );

    if (userIng.ingredient == null) {
      // Try matching by custom ingredient name (fuzzy)
      final recipeName = ingredient.ingredient.name.toLowerCase().trim();
      userIng = userIngredients.firstWhere((ui) {
        final customName = ui.customIngredient?.name.toLowerCase().trim();
        if (customName == null || customName.isEmpty) return false;
        return customName == recipeName ||
            customName.contains(recipeName) ||
            recipeName.contains(customName);
      }, orElse: () => UserIng(id: -1, uid: '', quantity: 0));
    }

    // If user doesn't have this ingredient at all
    if (userIng.ingredient == null && userIng.customIngredient == null) {
      return IngredientAvailabilityStatus.unavailable;
    }

    // If either unit is null, we can't properly compare quantities
    if (userIng.unit == null || ingredient.unit == null) {
      return IngredientAvailabilityStatus.incompatible;
    }

    // Check if units are compatible
    if (!userIng.unit!.isCompatibleWith(ingredient.unit!)) {
      return IngredientAvailabilityStatus.incompatible;
    }

    try {
      // Convert both quantities to base units for comparison
      final userQuantityInBase = userIng.unit!.convertToBase(userIng.quantity);
      final requiredQuantityInBase = ingredient.unit!.convertToBase(
        ingredient.quantity,
      );

      // Check if user has sufficient quantity
      if (userQuantityInBase >= requiredQuantityInBase) {
        return IngredientAvailabilityStatus.available;
      } else {
        return IngredientAvailabilityStatus.insufficient;
      }
    } catch (e) {
      // If conversion fails, treat as incompatible
      return IngredientAvailabilityStatus.incompatible;
    }
  }

  Widget _buildStatusIcon(
    IngredientAvailabilityStatus status,
    BuildContext context,
  ) {
    switch (status) {
      case IngredientAvailabilityStatus.available:
        return Icon(
          CupertinoIcons.checkmark_circle_fill,
          size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.sm),
          color: AppColors.mutedGreen.withValues(alpha: 0.8),
        );
      case IngredientAvailabilityStatus.insufficient:
      case IngredientAvailabilityStatus.incompatible:
        return Icon(
          Icons.warning,
          size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.sm),
          color: const Color.fromARGB(255, 228, 209, 43),
        );
      case IngredientAvailabilityStatus.unavailable:
        return Icon(
          Icons.error,
          size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.sm),
          color: AppColors.orange,
        );
    }
  }

  Color _getQuantityTextColor(IngredientAvailabilityStatus status) {
    switch (status) {
      case IngredientAvailabilityStatus.available:
        return AppColors.mutedGreen.withValues(alpha: 0.8);
      case IngredientAvailabilityStatus.insufficient:
      case IngredientAvailabilityStatus.incompatible:
        return const Color.fromARGB(255, 198, 183, 47);
      case IngredientAvailabilityStatus.unavailable:
        return AppColors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _getAvailabilityStatus();

    return Container(
      constraints: BoxConstraints(
        minHeight: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
      ),
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
        horizontal: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
      ),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.mutedGreen.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showIngredientDetailDialog(context, status),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: _getQuantityTextColor(status),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const ResponsiveSpacingWidget.horizontal(ResponsiveSpacing.sm),
            Expanded(
              flex: 5,
              child: Text(
                ingredient.ingredient.name,
                style: TextStyle(
                  color: AppColors.button,
                  fontSize: ResponsiveUtils.fontSize(
                    context,
                    ResponsiveFontSize.sm,
                  ),
                  fontFamily: 'Inter',
                  fontWeight: AppFontWeights.medium,
                  height: 1.3,
                  letterSpacing: 0.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const ResponsiveSpacingWidget.horizontal(ResponsiveSpacing.xs),
            Expanded(
              flex: 3,
              child: Text(
                '${ingredient.quantity} ${ingredient.unit?.abbreviation ?? ""}',
                style: TextStyle(
                  color: _getQuantityTextColor(status),
                  fontSize: ResponsiveUtils.fontSize(
                    context,
                    ResponsiveFontSize.sm,
                  ),
                  fontFamily: 'Inter',
                  fontWeight: AppFontWeights.medium,
                  height: 1.2,
                  letterSpacing: 0.2,
                ),
                textAlign: TextAlign.end,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const ResponsiveSpacingWidget.horizontal(ResponsiveSpacing.xs),
            _buildStatusIcon(status, context),
          ],
        ),
      ),
    );
  }

  void _showIngredientDetailDialog(
    BuildContext context,
    IngredientAvailabilityStatus status,
  ) {
    String title;
    String message;
    IconData icon;
    Color iconColor;

    switch (status) {
      case IngredientAvailabilityStatus.available:
        title = 'Ingredient available';
        message = 'Nothing to worry about. You have enough for this recipe.';
        icon = CupertinoIcons.check_mark_circled_solid;
        iconColor = AppColors.mutedGreen;
        break;
      case IngredientAvailabilityStatus.insufficient:
        title = 'Insufficient quantity';
        message =
            'You have this ingredient, but not enough. Consider topping it up or asking AI for substitutions.';
        icon = Icons.warning_amber_rounded;
        iconColor = const Color.fromARGB(255, 198, 183, 47);
        break;
      case IngredientAvailabilityStatus.incompatible:
        title = 'Unit compatibility issue';
        message =
            'Units are incompatible or cannot be compared. You may adjust manually or ask AI for help.';
        icon = Icons.swap_horiz;
        iconColor = const Color.fromARGB(255, 198, 183, 47);
        break;
      case IngredientAvailabilityStatus.unavailable:
        title = 'Unavailable ingredient';
        message =
            'Please buy it, top it up, or check with AI for substitutions.';
        icon = Icons.error_outline;
        iconColor = AppColors.orange;
        break;
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (BuildContext dialogContext) => CupertinoAlertDialog(
            title: Icon(
              icon,
              color: iconColor,
              size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.lg),
            ),
            content: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.spacing(
                  context,
                  ResponsiveSpacing.xs,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.sm),
                  Text(
                    ingredient.ingredient.name,
                    style: AppTextStyles.casta(
                      color: AppColors.black,
                      fontSize:
                          ResponsiveUtils.fontSize(
                            context,
                            ResponsiveFontSize.xxl,
                          ) *
                          1.2,
                      fontWeight: AppFontWeights.semiBold,
                      letterSpacing: 1.8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.sm),
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        ResponsiveFontSize.lg,
                      ),
                      fontWeight: AppFontWeights.medium,
                      letterSpacing: 0.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.xs),
                  Text(
                    message,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        ResponsiveFontSize.sm,
                      ),
                      height: 1.4,
                      letterSpacing: 0.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.md),
                  Container(
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
                      color: AppColors.mutedGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Recipe requires: ${ingredient.quantity} ${ingredient.unit?.abbreviation ?? ''}',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.fontSize(
                          context,
                          ResponsiveFontSize.sm,
                        ),
                        color: AppColors.mutedGreen,
                        fontWeight: AppFontWeights.medium,
                        letterSpacing: 0.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: AppColors.orange,
                    fontWeight: AppFontWeights.medium,
                    letterSpacing: 0.2,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
