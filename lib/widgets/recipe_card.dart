import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../models/user_ing.dart';
import 'recipe_ov_card.dart';

class RecipeCard extends StatefulWidget {
  final Recipe recipe;
  final List<UserIng> userIngredients;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.userIngredients,
  });

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  void _showRecipeDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RecipeOverviewCard(recipe: widget.recipe),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        children: [
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _showRecipeDetail(context),
            child: SizedBox(
              height: 120,
              child: _RecipeCardContent(
                recipe: widget.recipe,
                userIngredients: widget.userIngredients,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecipeCardContent extends StatelessWidget {
  final Recipe recipe;
  final List<UserIng> userIngredients;

  const _RecipeCardContent({
    required this.recipe,
    required this.userIngredients,
  });

  String _getMissingIngredientsText() {
    final missingIngredients = recipe.getMissingIngredients(userIngredients);
    if (missingIngredients.isEmpty) {
      return 'All available';
    }
    return '${missingIngredients.length} missing';
  }

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      elevation: 10,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      color: CupertinoColors.systemGrey6.resolveFrom(context),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _RecipeImage(imageUrl: recipe.imageUrl),
            const SizedBox(width: 12),
            Expanded(
              child: _RecipeDetails(
                recipe: recipe,
                missingIngredientsText: _getMissingIngredientsText(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecipeImage extends StatelessWidget {
  final String? imageUrl;

  const _RecipeImage({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.22,
      height: MediaQuery.of(context).size.width * 0.22,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child:
            imageUrl != null
                ? Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  cacheWidth:
                      (MediaQuery.of(context).size.width *
                              0.22 *
                              MediaQuery.of(context).devicePixelRatio)
                          .round(),
                  errorBuilder: (_, __, ___) => const _PlaceholderImage(),
                )
                : const _PlaceholderImage(),
      ),
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  const _PlaceholderImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.systemGrey4,
      child: const Icon(
        CupertinoIcons.photo,
        color: CupertinoColors.systemGrey2,
      ),
    );
  }
}

class _RecipeDetails extends StatelessWidget {
  final Recipe recipe;
  final String missingIngredientsText;

  const _RecipeDetails({
    required this.recipe,
    required this.missingIngredientsText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          recipe.name,
          style: const TextStyle(
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
        _DetailRow(label: 'Est. time: ', value: recipe.cookingTime ?? "N/A"),
        const SizedBox(height: 2),
        _DetailRow(label: 'Difficulty: ', value: recipe.difficulty ?? "N/A"),
        const SizedBox(height: 2),
        _DetailRow(
          label: 'Ingredients: ',
          value: missingIngredientsText,
          valueColor: recipe.ingredients.isEmpty ? Colors.red : Colors.green,
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor = CupertinoColors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: CupertinoColors.systemGrey,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 13, color: valueColor),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
