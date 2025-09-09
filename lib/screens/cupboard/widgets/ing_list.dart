import 'package:flutter/material.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IngredientListView extends StatelessWidget {
  final List<UserIng> ingredients;
  final void Function(UserIng) onTap;

  const IngredientListView({
    super.key,
    required this.ingredients,
    required this.onTap,
  });

  Widget _getCategoryIcon(UserIng userIng) {
    final categoryName =
        userIng.ingredient?.category?.name.toLowerCase() ??
        userIng.customIngredient?.category?.name.toLowerCase() ??
        '';

    String assetPath;
    switch (categoryName) {
      case 'fruits':
        assetPath = 'assets/icons/cherries.svg';
        break;
      case 'vegetables':
        assetPath = 'assets/icons/carrot.svg';
        break;
      case 'meat':
        assetPath = 'assets/icons/cow.svg';
        break;
      case 'fish':
        assetPath = 'assets/icons/fish.svg';
        break;
      case 'grain':
        assetPath = 'assets/icons/grains.svg';
        break;
      case 'dairies':
        assetPath = 'assets/icons/cheese.svg';
        break;
      case 'groceries':
        assetPath = 'assets/icons/tote-simple.svg';
        break;
      default:
        assetPath = 'assets/icons/tote-simple.svg';
    }

    return SvgPicture.asset(
      assetPath,
      width: 26,
      height: 26,
      colorFilter: ColorFilter.mode(AppColors.mutedGreen, BlendMode.srcIn),
    );
  }

  List<Widget> _getDietaryIcons(UserIng userIng) {
    final icons = <Widget>[];

    // Unified approach using tag-based logic for both ingredient types
    bool isVegan = false;
    bool isVegetarian = false;
    bool isGlutenFree = false;
    bool isLactoseFree = false;

    if (userIng.ingredient != null) {
      // For regular ingredients, use the new getter methods (which check tags)
      final ingredient = userIng.ingredient!;
      isVegan = ingredient.isVegan;
      isVegetarian = ingredient.isVegetarian;
      isGlutenFree = ingredient.isGlutenFree;
      isLactoseFree = ingredient.isLactoseFree;
    } else if (userIng.customIngredient != null) {
      // For custom ingredients, check tags directly
      final tags = userIng.customIngredient!.dietaryTags;
      final tagNames = tags.map((tag) => tag.name.toLowerCase()).toList();

      isVegan = tagNames.contains('vegan');
      isVegetarian = tagNames.contains('vegetarian');
      isGlutenFree = tagNames.contains('gluten-free');
      isLactoseFree = tagNames.contains('lactose-free');
    }

    // Add dietary icons based on unified logic
    if (isVegan) {
      icons.add(
        Icon(Icons.eco_outlined, size: 14, color: AppColors.mutedGreen),
      );
    }
    if (isVegetarian && !isVegan) {
      icons.add(
        Icon(
          Icons.local_dining_outlined,
          size: 14,
          color: AppColors.mutedGreen,
        ),
      );
    }
    if (isGlutenFree) {
      icons.add(
        Icon(Icons.no_food_outlined, size: 14, color: AppColors.mutedGreen),
      );
    }
    if (isLactoseFree) {
      icons.add(
        Icon(Icons.block_outlined, size: 14, color: AppColors.mutedGreen),
      );
    }

    return icons;
  }

  String _formatQuantity(double quantity) {
    // Remove unnecessary decimal places
    if (quantity == quantity.round()) {
      return quantity.round().toString();
    }
    // Show up to 2 decimal places, removing trailing zeros
    return quantity
        .toStringAsFixed(2)
        .replaceAll(RegExp(r'0*$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: screenHeight * 0.025,
        vertical: screenHeight * 0.01,
      ),
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        final userIng = ingredients[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onTap(userIng),
                borderRadius: BorderRadius.circular(18),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // Icono más pequeño
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.mutedGreen.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(child: _getCategoryIcon(userIng)),
                      ),
                      const SizedBox(width: 14),
                      // Detalles
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userIng.ingredient?.name ??
                                  userIng.customIngredient?.name ??
                                  '',
                              style: TextStyle(
                                color: AppColors.button,
                                fontFamily: 'Casta',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            // Dietary icons
                            if (_getDietaryIcons(userIng).isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Row(
                                  children:
                                      _getDietaryIcons(userIng)
                                          .map(
                                            (icon) => Padding(
                                              padding: const EdgeInsets.only(
                                                right: 4,
                                              ),
                                              child: icon,
                                            ),
                                          )
                                          .toList(),
                                ),
                              ),
                            Text(
                              '${_formatQuantity(userIng.quantity)} ${userIng.unit?.abbreviation ?? ''}',
                              style: TextStyle(
                                color: AppColors.mutedGreen,
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.mutedGreen.withValues(alpha: 0.4),
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
