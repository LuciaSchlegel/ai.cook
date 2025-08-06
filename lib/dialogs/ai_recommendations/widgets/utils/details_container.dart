import 'package:flutter/material.dart';

class DetailsContainer extends StatelessWidget {
  final Map<String, dynamic> recipe;
  final int missingCount;
  final double matchPercentage;

  const DetailsContainer({
    super.key,
    required this.recipe,
    required this.missingCount,
    required this.matchPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            missingCount == 0
                ? Colors.green.shade50
                : missingCount == 1
                ? Colors.orange.shade50
                : Colors.red.shade50,
        borderRadius:
            recipe['image'] != null && recipe['image'].toString().isNotEmpty
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
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
    );
  }
}
