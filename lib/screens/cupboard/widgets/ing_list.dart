import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';

class IngredientListView extends StatelessWidget {
  final List<UserIng> ingredients;
  final void Function(UserIng) onTap;

  const IngredientListView({
    super.key,
    required this.ingredients,
    required this.onTap,
  });

  Widget _getCategoryIcon(UserIng userIng, BuildContext context) {
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
      width: ResponsiveUtils.iconSize(context, ResponsiveIconSize.lg),
      height: ResponsiveUtils.iconSize(context, ResponsiveIconSize.lg),
      colorFilter: ColorFilter.mode(AppColors.mutedGreen, BlendMode.srcIn),
    );
  }

  List<Widget> _getDietaryIcons(UserIng userIng, BuildContext context) {
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
        ResponsiveIcon(
          Icons.eco_outlined,
          size: ResponsiveIconSize.xs,
          color: AppColors.mutedGreen,
        ),
      );
    }
    if (isVegetarian && !isVegan) {
      icons.add(
        ResponsiveIcon(
          Icons.local_dining_outlined,
          size: ResponsiveIconSize.xs,
          color: AppColors.mutedGreen,
        ),
      );
    }
    if (isGlutenFree) {
      icons.add(
        ResponsiveIcon(
          Icons.no_food_outlined,
          size: ResponsiveIconSize.xs,
          color: AppColors.mutedGreen,
        ),
      );
    }
    if (isLactoseFree) {
      icons.add(
        ResponsiveIcon(
          Icons.block_outlined,
          size: ResponsiveIconSize.xs,
          color: AppColors.mutedGreen,
        ),
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
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return ListView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.spacing(context, ResponsiveSpacing.lg),
            vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
          ),
          itemCount: ingredients.length,
          itemBuilder: (context, index) {
            final userIng = ingredients[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(
                    ResponsiveUtils.borderRadius(
                      context,
                      ResponsiveBorderRadius.xl,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: ResponsiveUtils.borderRadius(
                        context,
                        ResponsiveBorderRadius.sm,
                      ),
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onTap(userIng),
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.borderRadius(
                        context,
                        ResponsiveBorderRadius.xl,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(
                        ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
                      ),
                      child: Row(
                        children: [
                          // Icono más pequeño
                          Container(
                            width:
                                ResponsiveUtils.iconSize(
                                  context,
                                  ResponsiveIconSize.xl,
                                ) +
                                6,
                            height:
                                ResponsiveUtils.iconSize(
                                  context,
                                  ResponsiveIconSize.xl,
                                ) +
                                6,
                            decoration: BoxDecoration(
                              color: AppColors.mutedGreen.withValues(
                                alpha: 0.10,
                              ),
                              borderRadius: BorderRadius.circular(
                                ResponsiveUtils.borderRadius(
                                  context,
                                  ResponsiveBorderRadius.lg,
                                ),
                              ),
                            ),
                            child: Center(
                              child: _getCategoryIcon(userIng, context),
                            ),
                          ),
                          SizedBox(
                            width: ResponsiveUtils.spacing(
                              context,
                              ResponsiveSpacing.md,
                            ),
                          ),
                          // Detalles
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ResponsiveText(
                                  userIng.ingredient?.name ??
                                      userIng.customIngredient?.name ??
                                      '',
                                  color: AppColors.button,
                                  fontFamily: 'Casta',
                                  fontSize: ResponsiveFontSize.xl,
                                  fontWeight: FontWeight.w600,
                                  height: 1.1,
                                ),
                                SizedBox(
                                  height: ResponsiveUtils.spacing(
                                    context,
                                    ResponsiveSpacing.xxs,
                                  ),
                                ),
                                // Dietary icons
                                if (_getDietaryIcons(
                                  userIng,
                                  context,
                                ).isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(
                                      bottom:
                                          ResponsiveUtils.spacing(
                                            context,
                                            ResponsiveSpacing.xxs,
                                          ) -
                                          2,
                                    ),
                                    child: Row(
                                      children:
                                          _getDietaryIcons(userIng, context)
                                              .map(
                                                (icon) => Padding(
                                                  padding: EdgeInsets.only(
                                                    right:
                                                        ResponsiveUtils.spacing(
                                                          context,
                                                          ResponsiveSpacing.xs,
                                                        ) -
                                                        2,
                                                  ),
                                                  child: icon,
                                                ),
                                              )
                                              .toList(),
                                    ),
                                  ),
                                ResponsiveText(
                                  '${_formatQuantity(userIng.quantity)} ${userIng.unit?.abbreviation ?? ''}',
                                  color: AppColors.background,
                                  fontFamily: 'Inter',
                                  fontSize: ResponsiveFontSize.sm,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ),
                          ResponsiveIcon(
                            Icons.arrow_forward_ios,
                            color: AppColors.mutedGreen.withValues(alpha: 0.4),
                            size: ResponsiveIconSize.md,
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
      },
    );
  }
}
