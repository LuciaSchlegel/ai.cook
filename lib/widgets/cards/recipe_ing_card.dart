import 'package:ai_cook_project/models/recipe_ingredient_model.dart';
import 'package:ai_cook_project/models/recipe_model.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecipeIngCard extends StatelessWidget {
  final Recipe recipe;
  final Size size;
  final List<UserIng> userIngredients;

  const RecipeIngCard({
    required this.recipe,
    required this.size,
    required this.userIngredients,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.mutedGreen.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.shopping_basket_outlined,
                size: 20,
                color: AppColors.mutedGreen,
              ),
              const SizedBox(width: 8),
              Text(
                'Ingredients',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.button,
                  fontFamily: 'Casta',
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.mutedGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${recipe.ingredients.length} items',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mutedGreen,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (recipe.ingredients.isNotEmpty)
            Expanded(
              child: ListView.separated(
                itemCount: recipe.ingredients.length,
                separatorBuilder: (context, idx) => const SizedBox(height: 8),
                itemBuilder:
                    (context, index) => _IngredientRow(
                      ingredient: recipe.ingredients[index],
                      userIngredients: userIngredients,
                    ),
                padding: EdgeInsets.zero,
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                '• No ingredients listed',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: AppColors.button,
                  fontSize: 14,
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

  Widget _buildStatusIcon(IngredientAvailabilityStatus status) {
    switch (status) {
      case IngredientAvailabilityStatus.available:
        return Icon(
          CupertinoIcons.checkmark_circle_fill,
          size: 18,
          color: AppColors.mutedGreen.withOpacity(0.8),
        );
      case IngredientAvailabilityStatus.insufficient:
      case IngredientAvailabilityStatus.incompatible:
        return Icon(
          Icons.warning,
          size: 18,
          color: const Color.fromARGB(255, 228, 209, 43),
        );
      case IngredientAvailabilityStatus.unavailable:
        return Icon(Icons.error, size: 18, color: AppColors.orange);
    }
  }

  Color _getQuantityTextColor(IngredientAvailabilityStatus status) {
    switch (status) {
      case IngredientAvailabilityStatus.available:
        return AppColors.mutedGreen.withOpacity(0.8);
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.mutedGreen.withOpacity(0.1),
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
            const SizedBox(width: 12),
            Expanded(
              flex: 5,
              child: Text(
                ingredient.ingredient.name,
                style: const TextStyle(
                  color: AppColors.button,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: Text(
                '${ingredient.quantity} ${ingredient.unit?.abbreviation ?? ""}',
                style: TextStyle(
                  color: _getQuantityTextColor(status),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                  letterSpacing: 0.2,
                ),
                textAlign: TextAlign.end,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            _buildStatusIcon(status),
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
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Casta',
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: AppColors.button,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ingredient.ingredient.name,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: AppColors.button,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: AppColors.button,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Recipe requires: ${ingredient.quantity} ${ingredient.unit?.abbreviation ?? ''}',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: AppColors.mutedGreen,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text(
                'Close',
                style: TextStyle(
                  color: AppColors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
