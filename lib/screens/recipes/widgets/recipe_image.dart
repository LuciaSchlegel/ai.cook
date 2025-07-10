import 'package:ai_cook_project/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class RecipeImage extends StatelessWidget {
  final String? imageUrl;
  final double height;
  final double width;

  const RecipeImage({
    this.imageUrl,
    super.key,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child:
          imageUrl != null && imageUrl!.isNotEmpty
              ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                width: width,
                height: height,
                placeholder:
                    (context, url) => const CupertinoActivityIndicator(),
                errorWidget:
                    (context, url, error) => const Icon(
                      CupertinoIcons.photo,
                      color: AppColors.button,
                      size: 40,
                    ),
                fadeInDuration: const Duration(milliseconds: 0),
              )
              : const _PlaceholderImage(),
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  const _PlaceholderImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      color: AppColors.mutedGreen.withOpacity(0.2),
      child: const Icon(
        CupertinoIcons.photo,
        color: AppColors.button,
        size: 40,
      ),
    );
  }
}
