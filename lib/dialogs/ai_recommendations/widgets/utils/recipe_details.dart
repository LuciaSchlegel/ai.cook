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
                    // Build display text based on available data
                    final displayText = missing.quantity != null
                        ? '• ${missing.name} (${missing.quantity} ${missing.unit ?? 'units'})'
                        : '• ${missing.name}';

                    return Padding(
                      padding: ResponsiveUtils.padding(
                        context,
                        ResponsiveSpacing.xs,
                      ),
                      child: Text(
                        displayText,
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

          // AI Cooking Tips section (expandable)
          if (viewModel.cookingTips.isNotEmpty) ...[
            const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.md),
            _CookingTipsExpansionTile(cookingTips: viewModel.cookingTips),
          ],

          // Recipe-specific substitutions section
          if (viewModel.recipeSubstitutions.isNotEmpty) ...[
            const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.md),
            Container(
              padding: ResponsiveUtils.padding(context, ResponsiveSpacing.md),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.borderRadius(
                    context,
                    ResponsiveBorderRadius.md,
                  ),
                ),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🔄 Suggested substitutions:',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        ResponsiveFontSize.xs,
                      ),
                      fontWeight: AppFontWeights.bold,
                      fontFamily: 'Inter',
                      letterSpacing: 0.2,
                      height: 1,
                      color: Colors.orange.shade800,
                    ),
                  ),
                  const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.xs),
                  ...viewModel.recipeSubstitutions.map((sub) {
                    return Padding(
                      padding: ResponsiveUtils.padding(
                        context,
                        ResponsiveSpacing.xs,
                      ),
                      child: Text(
                        '• ${sub.original} → ${sub.alternatives.join(", ")}',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.fontSize(
                            context,
                            ResponsiveFontSize.xs,
                          ),
                          fontWeight: AppFontWeights.medium,
                          fontFamily: 'Inter',
                          letterSpacing: 0.2,
                          height: 1,
                          color: Colors.orange.shade700,
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

// Expandable widget for AI cooking tips
class _CookingTipsExpansionTile extends StatefulWidget {
  final List<String> cookingTips;

  const _CookingTipsExpansionTile({required this.cookingTips});

  @override
  State<_CookingTipsExpansionTile> createState() =>
      _CookingTipsExpansionTileState();
}

class _CookingTipsExpansionTileState extends State<_CookingTipsExpansionTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.md),
        ),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: ResponsiveUtils.padding(context, ResponsiveSpacing.md),
          childrenPadding: EdgeInsets.only(
            left: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
            right: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
            bottom: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
          ),
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          title: Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.sm),
                color: Colors.blue.shade800,
              ),
              SizedBox(
                width: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
              ),
              Text(
                'AI Cooking Tips (${widget.cookingTips.length})',
                style: TextStyle(
                  fontSize: ResponsiveUtils.fontSize(
                    context,
                    ResponsiveFontSize.xs,
                  ),
                  fontWeight: AppFontWeights.bold,
                  fontFamily: 'Inter',
                  letterSpacing: 0.2,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
          trailing: Icon(
            _isExpanded ? Icons.expand_less : Icons.expand_more,
            color: Colors.blue.shade800,
          ),
          children: widget.cookingTips.asMap().entries.map((entry) {
            return Padding(
              padding: ResponsiveUtils.padding(
                context,
                ResponsiveSpacing.xs,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${entry.key + 1}. ',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        ResponsiveFontSize.xs,
                      ),
                      fontWeight: AppFontWeights.semiBold,
                      fontFamily: 'Inter',
                      letterSpacing: 0.2,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        fontSize: ResponsiveUtils.fontSize(
                          context,
                          ResponsiveFontSize.xs,
                        ),
                        fontWeight: AppFontWeights.medium,
                        fontFamily: 'Inter',
                        letterSpacing: 0.2,
                        height: 1.4,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
