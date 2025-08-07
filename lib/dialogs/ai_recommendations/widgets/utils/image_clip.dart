import 'package:ai_cook_project/models/ai_response_model.dart';
import 'package:flutter/material.dart';

class ImageClip extends StatelessWidget {
  final CombinedRecipeViewModel viewModel;

  const ImageClip({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final imageUrl = viewModel.recipe.image;
    if (imageUrl == null || imageUrl.isEmpty) return const SizedBox.shrink();
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.grey[200]),
        child: Image.network(
          imageUrl,
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
              child: const Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }
}
