import 'package:ai_cook_project/providers/ai_recommendations_provider.dart';
import 'package:flutter/material.dart';

class RecipeDetails extends StatelessWidget {
  final Map<String, dynamic> recipe;
  final int missingCount;
  final RecipeWithMissingIngredients recipeWithMissingInfo;

  const RecipeDetails({
    super.key,
    required this.recipe,
    required this.missingCount,
    required this.recipeWithMissingInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(width: 16),
              ],
              if (recipe['difficulty'] != null) ...[
                const Icon(Icons.bar_chart, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  recipe['difficulty'],
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ],
          ),

          const SizedBox(height: 8),

          // Description
          if (recipe['description'] != null)
            Text(
              recipe['description'],
              style: const TextStyle(fontSize: 13, color: Colors.black87),
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
                  ...recipeWithMissingInfo.missingIngredients.map((missing) {
                    final ingredient = missing['ingredient'];
                    final quantity = missing['quantity'];
                    final unit = missing['unit'];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        '• ${ingredient['name']} ($quantity ${unit?['abbreviation'] ?? 'units'})',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    );
                  }),
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
    );
  }
}
