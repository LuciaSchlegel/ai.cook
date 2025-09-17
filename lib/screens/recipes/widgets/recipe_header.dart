import 'package:ai_cook_project/models/recipe_model.dart';
import 'package:ai_cook_project/screens/recipes/widgets/recipe_image.dart';
import 'package:ai_cook_project/screens/recipes/widgets/recipe_title.dart';
import 'package:flutter/cupertino.dart';

class RecipeHeader extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onClose;

  const RecipeHeader({required this.recipe, required this.onClose, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RecipeImage(imageUrl: recipe.image),
          Expanded(child: RecipeTitle(name: recipe.name)),
        ],
      ),
    );
  }
}
