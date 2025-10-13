import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/utils/text_utils.dart';
import 'package:flutter/material.dart';

class RecipeTags extends StatelessWidget {
  final List<String> tags;

  const RecipeTags({required this.tags, super.key});

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
      ),
      child: SizedBox(
        height: ResponsiveUtils.spacing(context, ResponsiveSpacing.xl) * 1.4,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: tags.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(
                right:
                    index < tags.length - 1
                        ? ResponsiveUtils.spacing(context, ResponsiveSpacing.sm)
                        : 0.0,
              ),
              child: _RecipeTag(tag: tags[index]),
            );
          },
        ),
      ),
    );
  }
}

class _RecipeTag extends StatelessWidget {
  final String tag;

  const _RecipeTag({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
        vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
      ),
      decoration: BoxDecoration(
        color: AppColors.mutedGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.xxl),
        ),
        border: Border.all(
          color: AppColors.mutedGreen.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.mutedGreen.withValues(alpha: 0.05),
            blurRadius: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
            offset: Offset(
              0,
              ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
            ),
          ),
        ],
      ),
      child: Center(
        child: Text(
          TextUtils.capitalizeFirstLetter(tag),
          style: TextStyle(
            fontWeight: AppFontWeights.medium,
            fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.sm),
            color: AppColors.mutedGreen,
            fontFamily: 'Inter',
            letterSpacing: 0.2,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}
