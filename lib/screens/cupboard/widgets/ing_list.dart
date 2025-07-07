import 'package:flutter/material.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IngredientListView extends StatelessWidget {
  final List<UserIng> ingredients;
  final double horizontalPadding;
  final void Function(UserIng) onTap;

  const IngredientListView({
    super.key,
    required this.ingredients,
    required this.horizontalPadding,
    required this.onTap,
  });

  Widget _getCategoryIcon(UserIng userIng) {
    final categoryName = userIng.ingredient?.category?.name?.toLowerCase() ??
        userIng.customIngredient?.category?.name?.toLowerCase() ?? '';

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
      color: AppColors.mutedGreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        final userIng = ingredients[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onTap(userIng),
                borderRadius: BorderRadius.circular(24),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      // Elegant icon container
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.mutedGreen.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Center(
                          child: _getCategoryIcon(userIng),
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Ingredient details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userIng.ingredient?.name ??
                                  userIng.customIngredient?.name ??
                                  '',
                              style: TextStyle(
                                color: AppColors.button.withOpacity(0.85),
                                fontFamily: 'Casta',
                                fontSize: 24,
                                letterSpacing: 0.3,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${userIng.quantity} ${userIng.unit?.abbreviation ?? ''}',
                              style: TextStyle(
                                color: AppColors.mutedGreen,
                                fontFamily: 'Inter',
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Subtle chevron
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.mutedGreen.withOpacity(0.6),
                        size: 24,
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


