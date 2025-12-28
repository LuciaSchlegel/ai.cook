import 'package:ai_cook_project/models/ai_response_model.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/material.dart';

class DetailsContainer extends StatelessWidget {
  final CombinedRecipeViewModel viewModel;

  const DetailsContainer({super.key, required this.viewModel});

  Color _getScoreColor(int score) {
    if (score >= 90) return const Color(0xFF10B981); // Emerald green
    if (score >= 80) return const Color(0xFF059669); // Green
    if (score >= 70) return const Color(0xFFF59E0B); // Amber
    return const Color(0xFFEF4444); // Red
  }

  String _getScoreLabel(int score) {
    if (score >= 90) return 'PERFECT';
    if (score >= 80) return 'EXCELLENT';
    if (score >= 70) return 'GOOD';
    return 'DECENT';
  }

  @override
  Widget build(BuildContext context) {
    final scoreColor = _getScoreColor(viewModel.matchScore);
    final scoreLabel = _getScoreLabel(viewModel.matchScore);

    return Container(
      padding: ResponsiveUtils.padding(context, ResponsiveSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            viewModel.missingCount == 0
                ? AppColors.mutedGreen.withValues(alpha: 0.08)
                : viewModel.missingCount <= 2
                ? AppColors.orange.withValues(alpha: 0.08)
                : AppColors.button.withValues(alpha: 0.05),
            viewModel.missingCount == 0
                ? AppColors.lightYellow.withValues(alpha: 0.05)
                : viewModel.missingCount <= 2
                ? AppColors.lightYellow.withValues(alpha: 0.05)
                : Colors.grey.withValues(alpha: 0.03),
          ],
        ),
        borderRadius:
            viewModel.recipe.image != null &&
                    viewModel.recipe.image.toString().isNotEmpty
                ? null // No top border radius if image is present
                : const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Title and Match Score Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recipe name
                    Text(
                      viewModel.recipe.name,
                      style: AppTextStyles.casta(
                        fontSize:
                            ResponsiveUtils.fontSize(
                              context,
                              ResponsiveFontSize.title,
                            ) *
                            1.15,
                        fontWeight: AppFontWeights.bold,
                        letterSpacing: 0.4,
                        height: 1.2,
                        color: AppColors.button,
                      ),
                    ),
                  ],
                ),
              ),
              // Match score badge
              if (viewModel.matchScore > 0) ...[
                const SizedBox(width: 12),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
                    vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
                  ),
                  decoration: BoxDecoration(
                    color: scoreColor,
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: scoreColor.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${viewModel.matchScore}',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.fontSize(
                            context,
                            ResponsiveFontSize.lg,
                          ),
                          fontWeight: AppFontWeights.bold,
                          fontFamily: 'Inter',
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        scoreLabel,
                        style: TextStyle(
                          fontSize: ResponsiveUtils.fontSize(
                            context,
                            ResponsiveFontSize.xs,
                          ),
                          fontWeight: AppFontWeights.bold,
                          fontFamily: 'Inter',
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),

          const ResponsiveSpacingWidget.vertical(ResponsiveSpacing.sm),

          // Status row with icon
          Row(
            children: [
              Icon(
                viewModel.missingCount == 0
                    ? Icons.check_circle_rounded
                    : viewModel.missingCount == 1
                    ? Icons.shopping_basket_outlined
                    : Icons.add_shopping_cart_rounded,
                color:
                    viewModel.missingCount == 0
                        ? AppColors.mutedGreen
                        : viewModel.missingCount <= 2
                        ? AppColors.orange
                        : AppColors.button.withValues(alpha: 0.6),
                size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.sm),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  viewModel.missingCount == 0
                      ? '✨ You have everything!'
                      : viewModel.missingCount == 1
                      ? '🛒 Just 1 ingredient needed'
                      : '🛒 ${viewModel.missingCount} ingredients needed',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.sm,
                    ),
                    fontWeight: AppFontWeights.semiBold,
                    fontFamily: 'Inter',
                    letterSpacing: 0.2,
                    height: 1.4,
                    color:
                        viewModel.missingCount == 0
                            ? AppColors.mutedGreen
                            : viewModel.missingCount <= 2
                            ? AppColors.orange
                            : AppColors.button.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
