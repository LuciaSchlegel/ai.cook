import 'package:flutter/material.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';

class ImageClipOvCard extends StatelessWidget {
  final String imageUrl;

  const ImageClipOvCard({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) return const SizedBox.shrink();
    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
        ),
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
