import 'package:ai_cook_project/models/dietary_tag_model.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/utils/text_utils.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TagsPicker extends StatelessWidget {
  final List<DietaryTag> tags;
  final List<DietaryTag> selectedTags;
  final ValueChanged<String> onTagsSelected;

  const TagsPicker({
    super.key,
    required this.tags,
    required this.selectedTags,
    required this.onTagsSelected,
  });

  /// Get the appropriate SVG icon path for each dietary tag
  Widget _getIcon(String tagName) {
    final wheatSvgIcon = SvgAssetLoader('assets/icons/grains.svg');
    final lacFreeSvgIcon = SvgAssetLoader('assets/icons/lac-free.svg');

    final lowerTagName = tagName.toLowerCase();
    switch (lowerTagName) {
      case 'vegan':
        return ResponsiveIcon(
          Icons.cruelty_free_outlined,
          null,
          size: ResponsiveIconSize.sm,
          color: AppColors.white,
        );
      case 'vegetarian':
        return ResponsiveIcon(
          Icons.eco_outlined,
          null,
          size: ResponsiveIconSize.sm,
          color: AppColors.white,
        );
      case 'gluten-free':
        return ResponsiveIcon(
          null,
          wheatSvgIcon,
          size: ResponsiveIconSize.sm,
          color: AppColors.white,
        );
      case 'lactose-free':
        return ResponsiveIcon(
          null,
          lacFreeSvgIcon,
          size: ResponsiveIconSize.sm,
          color: AppColors.white,
        );
      default:
        return ResponsiveIcon(
          Icons.eco_outlined,
          null,
          size: ResponsiveIconSize.sm,
          color: AppColors.white,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.md),
            ),
            border: Border.all(
              color: AppColors.mutedGreen.withValues(alpha: 0.7),
              width: 0.5,
            ),
          ),
          padding: ResponsiveUtils.padding(context, ResponsiveSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResponsiveText(
                'Dietary Restrictions',
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  ResponsiveFontSize.md,
                ),
                fontWeight: FontWeight.w600,
                color: AppColors.button,
              ),
              const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.md),
              Wrap(
                spacing: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
                runSpacing: ResponsiveUtils.spacing(
                  context,
                  ResponsiveSpacing.sm,
                ),
                children:
                    tags.map((tag) {
                      final isSelected = selectedTags.contains(tag);
                      return Semantics(
                        label:
                            'Dietary restriction $tag, ${isSelected ? "selected" : "not selected"}',
                        selected: isSelected,
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            onTagsSelected(tag.name);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? AppColors.background.withValues(
                                        alpha: 0.8,
                                      )
                                      : AppColors.mutedGreen.withValues(
                                        alpha: 0.6,
                                      ),
                              borderRadius: BorderRadius.circular(
                                ResponsiveUtils.borderRadius(
                                  context,
                                  ResponsiveBorderRadius.xxl,
                                ),
                              ),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? AppColors.mutedGreen.withValues(
                                          alpha: 0.9,
                                        )
                                        : CupertinoColors.systemGrey6,
                                width: 1,
                              ),
                              // Add subtle shadow for depth
                              boxShadow:
                                  isSelected
                                      ? [
                                        BoxShadow(
                                          color: AppColors.mutedGreen
                                              .withValues(alpha: 0.3),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                      : null,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveUtils.spacing(
                                context,
                                ResponsiveSpacing.sm,
                              ),
                              vertical: ResponsiveUtils.spacing(
                                context,
                                ResponsiveSpacing.xs,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _getIcon(tag.name),
                                SizedBox(
                                  width: ResponsiveUtils.spacing(
                                    context,
                                    ResponsiveSpacing.xs,
                                  ),
                                ),
                                ResponsiveText(
                                  TextUtils.capitalizeFirstLetter(tag.name),
                                  fontSize: ResponsiveUtils.fontSize(
                                    context,
                                    ResponsiveFontSize.sm,
                                  ),
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.white,
                                ),
                                // Add checkmark for selected state
                                if (isSelected) ...[
                                  SizedBox(
                                    width: ResponsiveUtils.spacing(
                                      context,
                                      ResponsiveSpacing.xs,
                                    ),
                                  ),
                                  ResponsiveIcon(
                                    CupertinoIcons.checkmark,
                                    null,
                                    size: ResponsiveIconSize.xs,
                                    color: AppColors.white,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
