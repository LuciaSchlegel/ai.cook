import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../models/user_ing.dart';
import 'recipe_ov_card.dart';
import 'recipe_steps_view.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final List<UserIng> userIngredients;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.userIngredients,
  });

  void _showRecipeDetail(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      builder:
          (BuildContext context) => RecipeOverviewCard(
            recipe: recipe,
            onExpand: () {
              Navigator.of(context).pop(); // Close the dialog first
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => RecipeStepsView(
                        recipe: recipe,
                        onClose: () => Navigator.of(context).pop(),
                      ),
                ),
              );
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        children: [
          SizedBox(height: 16),
          GestureDetector(
            onTap: () => _showRecipeDetail(context),
            child: SizedBox(
              height: 120, // Reduced from 140 for better proportions
              child: Card.filled(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                color: CupertinoColors.systemGrey6.resolveFrom(context),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width:
                            MediaQuery.of(context).size.width *
                            0.22, // Reduced from 0.25
                        height:
                            MediaQuery.of(context).size.width *
                            0.22, // Reduced from 0.25
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child:
                              recipe.imageUrl != null
                                  ? Image.network(
                                    recipe.imageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: CupertinoColors.systemGrey4,
                                        child: Icon(
                                          CupertinoIcons.photo,
                                          color: CupertinoColors.systemGrey2,
                                        ),
                                      );
                                    },
                                  )
                                  : Container(
                                    color: CupertinoColors.systemGrey4,
                                    child: Icon(
                                      CupertinoIcons.photo,
                                      color: CupertinoColors.systemGrey2,
                                    ),
                                  ),
                        ),
                      ),
                      SizedBox(width: 12), // Reduced from 16
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              recipe.name.toLowerCase(),
                              style: TextStyle(
                                fontFamily: 'Times New Roman',
                                letterSpacing: -0.5,
                                fontSize: 22,
                                height: 1.0,
                                fontWeight: FontWeight.w500,
                                color: CupertinoColors.black,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  'Est. time: ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: CupertinoColors.systemGrey,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '${recipe.cookingTime ?? "N/A"}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: CupertinoColors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Text(
                                  'Difficulty: ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: CupertinoColors.systemGrey,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    recipe.difficulty ?? "N/A",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: CupertinoColors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Text(
                                  'Ingredients: ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: CupertinoColors.systemGrey,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    _getMissingIngredientsText(),
                                    style: TextStyle(
                                      fontSize: 13,
                                      color:
                                          recipe.ingredients.isEmpty
                                              ? Colors.red
                                              : Colors.green,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMissingIngredientsText() {
    final missingIngredients = recipe.getMissingIngredients(userIngredients);
    if (missingIngredients.isEmpty) {
      return 'All available';
    }
    return '${missingIngredients.length} missing';
  }
}
