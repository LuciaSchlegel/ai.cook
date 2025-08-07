import 'package:ai_cook_project/models/ai_response_model.dart';
import 'package:flutter/material.dart';

class DetailsContainer extends StatelessWidget {
  final CombinedRecipeViewModel viewModel;

  const DetailsContainer({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            viewModel.missingCount == 0
                ? Colors.green.shade50
                : viewModel.missingCount == 1
                ? Colors.orange.shade50
                : Colors.red.shade50,
        borderRadius:
            viewModel.recipe.image != null &&
                    viewModel.recipe.image.toString().isNotEmpty
                ? null // No top border radius if image is present
                : const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
      ),
      child: Row(
        children: [
          Icon(
            viewModel.missingCount == 0
                ? Icons.check_circle
                : viewModel.missingCount == 1
                ? Icons.shopping_cart
                : Icons.add_shopping_cart,
            color:
                viewModel.missingCount == 0
                    ? Colors.green
                    : viewModel.missingCount == 1
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
                  viewModel.recipe.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  viewModel.missingCount == 0
                      ? '✅ Ready to cook!'
                      : viewModel.missingCount == 1
                      ? '🛒 Need 1 ingredient'
                      : '🛒 Need `${viewModel.missingCount}` ingredients',
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        viewModel.missingCount == 0
                            ? Colors.green.shade700
                            : viewModel.missingCount == 1
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
                    viewModel.missingCount == 0
                        ? Colors.green
                        : viewModel.missingCount == 1
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
