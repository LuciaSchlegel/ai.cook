import 'package:flutter/material.dart';
import 'package:ai_cook_project/models/recipe_model.dart';
import 'package:ai_cook_project/providers/ai_recommendations_provider.dart';
import 'package:ai_cook_project/screens/recipes/widgets/recipe_ov_card.dart';

class AIRecipeCard extends StatelessWidget {
  final RecipeWithMissingIngredients recipeWithMissingInfo;

  const AIRecipeCard({super.key, required this.recipeWithMissingInfo});

  void _showRecipeDetail(BuildContext context) {
    try {
      final recipe = Recipe.fromJson(recipeWithMissingInfo.recipe);
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => RecipeOverviewCard(recipe: recipe),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error opening recipe: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipe = recipeWithMissingInfo.recipe;
    final missingCount = recipeWithMissingInfo.missingCount;
    final matchPercentage = recipeWithMissingInfo.matchPercentage;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () => _showRecipeDetail(context),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border:
                missingCount > 0
                    ? Border.all(
                      color: missingCount == 1 ? Colors.orange : Colors.red,
                      width: 2,
                    )
                    : Border.all(color: Colors.green, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipe image (if available)
              if (recipe['image'] != null &&
                  recipe['image'].toString().isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    child: Image.network(
                      recipe['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                              size: 40,
                            ),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                    ),
                  ),
                ),

              // Header with recipe name and match status
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      missingCount == 0
                          ? Colors.green.shade50
                          : missingCount == 1
                          ? Colors.orange.shade50
                          : Colors.red.shade50,
                  borderRadius:
                      recipe['image'] != null &&
                              recipe['image'].toString().isNotEmpty
                          ? null // No top border radius if image is present
                          : const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                ),
                child: Row(
                  children: [
                    Icon(
                      missingCount == 0
                          ? Icons.check_circle
                          : missingCount == 1
                          ? Icons.shopping_cart
                          : Icons.add_shopping_cart,
                      color:
                          missingCount == 0
                              ? Colors.green
                              : missingCount == 1
                              ? Colors.orange
                              : Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe['name'] ?? 'Unknown Recipe',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            missingCount == 0
                                ? '✅ Ready to cook!'
                                : missingCount == 1
                                ? '🛒 Need 1 ingredient'
                                : '🛒 Need $missingCount ingredients',
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  missingCount == 0
                                      ? Colors.green.shade700
                                      : missingCount == 1
                                      ? Colors.orange.shade700
                                      : Colors.red.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Match percentage badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              missingCount == 0
                                  ? Colors.green
                                  : missingCount == 1
                                  ? Colors.orange
                                  : Colors.red,
                        ),
                      ),
                      child: Text(
                        '${matchPercentage.toInt()}%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color:
                              missingCount == 0
                                  ? Colors.green
                                  : missingCount == 1
                                  ? Colors.orange
                                  : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Recipe details
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Basic recipe info
                    Row(
                      children: [
                        if (recipe['cookingTime'] != null) ...[
                          const Icon(Icons.timer, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            recipe['cookingTime'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                        if (recipe['difficulty'] != null) ...[
                          const Icon(
                            Icons.bar_chart,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            recipe['difficulty'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Description
                    if (recipe['description'] != null)
                      Text(
                        recipe['description'],
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                    // Missing ingredients section
                    if (missingCount > 0) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '🛒 Missing ingredients:',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            ...recipeWithMissingInfo.missingIngredients.map((
                              missing,
                            ) {
                              final ingredient = missing['ingredient'];
                              final quantity = missing['quantity'];
                              final unit = missing['unit'];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Text(
                                  '• ${ingredient['name']} (${quantity} ${unit?['abbreviation'] ?? 'units'})',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ],

                    // Tags if available
                    if (recipe['tags'] != null &&
                        (recipe['tags'] as List).isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children:
                            (recipe['tags'] as List).take(3).map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  tag['name'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
