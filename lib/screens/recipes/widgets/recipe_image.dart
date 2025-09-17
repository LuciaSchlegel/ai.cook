import 'package:ai_cook_project/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';

class RecipeImage extends StatelessWidget {
  final String? imageUrl;

  const RecipeImage({this.imageUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.xl),
      ),
      child:
          imageUrl != null && imageUrl!.isNotEmpty
              ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                width:
                    ResponsiveUtils.spacing(context, ResponsiveSpacing.xxl) *
                    3.5,
                height:
                    ResponsiveUtils.spacing(context, ResponsiveSpacing.xxl) *
                    3.5,
                placeholder:
                    (context, url) => const CupertinoActivityIndicator(),
                errorWidget:
                    (context, url, error) => Icon(
                      CupertinoIcons.photo,
                      color: AppColors.button,
                      size:
                          ResponsiveUtils.iconSize(
                            context,
                            ResponsiveIconSize.xxl,
                          ) *
                          3.5,
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
      width: ResponsiveUtils.spacing(context, ResponsiveSpacing.xxl) * 3.5,
      height: ResponsiveUtils.spacing(context, ResponsiveSpacing.xxl) * 3.5,
      color: AppColors.mutedGreen.withValues(alpha: 0.2),
      child: Icon(
        CupertinoIcons.photo,
        color: AppColors.button,
        size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.xxl) * 3.5,
      ),
    );
  }
}
