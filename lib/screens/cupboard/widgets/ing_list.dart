import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/theme.dart';

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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12),
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        final userIng = ingredients[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppColors.mutedGreen, width: 0.5),
            ),
            color: CupertinoColors.systemGrey6,
            child: InkWell(
              onTap: () => onTap(userIng),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        userIng.ingredient?.name ??
                            userIng.customIngredient?.name ??
                            '',
                        style: const TextStyle(
                          color: AppColors.button,
                          fontFamily: 'Times New Roman',
                          fontSize: 17,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${userIng.quantity} ${userIng.unit?.abbreviation ?? ''}',
                      style: const TextStyle(
                        color: AppColors.button,
                        fontFamily: 'Times New Roman',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


