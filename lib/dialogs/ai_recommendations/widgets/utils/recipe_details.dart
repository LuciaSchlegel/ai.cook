import 'package:ai_cook_project/models/ai_response_model.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:flutter/material.dart';

class RecipeDetails extends StatelessWidget {
  final CombinedRecipeViewModel viewModel;

  const RecipeDetails({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final recipe = viewModel.recipe;
    final description = viewModel.description ?? recipe.description;
    final missingIngredients = viewModel.missingIngredients;
    final missingCount = viewModel.missingCount;
    return Padding(
      padding: ResponsiveUtils.padding(context, ResponsiveSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic recipe info
          Row(
            children: [
              Icon(
                Icons.timer,
                size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.sm),
                color: Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                recipe.cookingTime ?? 'N/A',
                style: TextStyle(
                  fontSize: ResponsiveUtils.fontSize(
                    context,
                    ResponsiveFontSize.sm,
                  ),
                  fontWeight: AppFontWeights.medium,
                  fontFamily: 'Inter',
                  letterSpacing: 0.2,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.bar_chart,
                size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.sm),
                color: Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                recipe.difficulty ?? 'N/A',
                style: TextStyle(
                  fontSize: ResponsiveUtils.fontSize(
                    context,
                    ResponsiveFontSize.sm,
                  ),
                  fontWeight: AppFontWeights.medium,
                  fontFamily: 'Inter',
                  letterSpacing: 0.2,
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.sm),

          // Description
          Text(
            description,
            style: TextStyle(
              fontSize: ResponsiveUtils.fontSize(
                context,
                ResponsiveFontSize.sm,
              ),
              color: AppColors.button,
              fontWeight: AppFontWeights.medium,
              fontFamily: 'Inter',
              letterSpacing: 0.2,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          // Missing ingredients section
          if (missingCount > 0) ...[
            const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.md),
            Container(
              padding: ResponsiveUtils.padding(context, ResponsiveSpacing.md),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.borderRadius(
                    context,
                    ResponsiveBorderRadius.md,
                  ),
                ),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🛒 Missing ingredients:',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        ResponsiveFontSize.xs,
                      ),
                      fontWeight: AppFontWeights.bold,
                      fontFamily: 'Inter',
                      letterSpacing: 0.2,
                      height: 1,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.xs),
                  ...missingIngredients!.map((missing) {
                    return Padding(
                      padding: ResponsiveUtils.padding(
                        context,
                        ResponsiveSpacing.xs,
                      ),
                      child: Text(
                        '• ${missing.name} (${missing.quantity ?? ''} ${missing.unit ?? 'units'})',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.fontSize(
                            context,
                            ResponsiveFontSize.xs,
                          ),
                          fontWeight: AppFontWeights.medium,
                          fontFamily: 'Inter',
                          letterSpacing: 0.2,
                          height: 1,
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
          if (recipe.tags.isNotEmpty) ...[
            const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.sm),
            Wrap(
              spacing: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
              runSpacing: ResponsiveUtils.spacing(
                context,
                ResponsiveSpacing.xs,
              ),
              children:
                  (recipe.tags).take(3).map((tag) {
                    return Container(
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
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.borderRadius(
                            context,
                            ResponsiveBorderRadius.lg,
                          ),
                        ),
                      ),
                      child: Text(
                        tag.name,
                        style: TextStyle(
                          fontSize: ResponsiveUtils.fontSize(
                            context,
                            ResponsiveFontSize.xs,
                          ),
                          color: Colors.blue,
                          fontWeight: AppFontWeights.medium,
                          fontFamily: 'Inter',
                          letterSpacing: 0.2,
                          height: 1,
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
