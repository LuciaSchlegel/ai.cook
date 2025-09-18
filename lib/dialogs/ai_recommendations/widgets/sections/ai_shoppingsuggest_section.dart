import 'package:ai_cook_project/models/ai_response_model.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/cupertino.dart';

class AIShoppingSuggestionsSection extends StatelessWidget {
  final List<AIShoppingSuggestion> suggestions;

  const AIShoppingSuggestionsSection({super.key, required this.suggestions});

  @override
  Widget build(BuildContext context) {
    // Show section even if empty, with fallback content

    return Container(
      margin: EdgeInsets.only(
        bottom: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
      ),
      padding: ResponsiveUtils.padding(context, ResponsiveSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.white,
            AppColors.lightYellow.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightYellow.withValues(alpha: 0.08),
            blurRadius: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: AppColors.lightYellow.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Container(
                width: ResponsiveUtils.iconSize(context, ResponsiveIconSize.lg),
                height: ResponsiveUtils.iconSize(
                  context,
                  ResponsiveIconSize.lg,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.lightYellow.withValues(alpha: 0.8),
                      AppColors.orange.withValues(alpha: 0.6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(
                    ResponsiveUtils.borderRadius(
                      context,
                      ResponsiveBorderRadius.md,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.orange.withValues(alpha: 0.2),
                      blurRadius: ResponsiveUtils.spacing(
                        context,
                        ResponsiveSpacing.xs,
                      ),
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  CupertinoIcons.lightbulb,
                  size: ResponsiveUtils.iconSize(
                    context,
                    ResponsiveIconSize.md,
                  ),
                  color: AppColors.white,
                ),
              ),
              SizedBox(
                width: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
              ),
              Expanded(
                child: Text(
                  'Smart Shopping Tips',
                  style: AppTextStyles.melodrama(
                    fontSize:
                        ResponsiveUtils.fontSize(
                          context,
                          ResponsiveFontSize.xl,
                        ) *
                        1.2,
                    fontWeight: AppFontWeights.semiBold,
                    color: AppColors.button,
                    letterSpacing: 1.3,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
          ),

          // Suggestions or fallback
          if (suggestions.isNotEmpty)
            ...suggestions.map(
              (suggestion) => _buildSuggestionItem(context, suggestion),
            )
          else
            _buildShoppingSuggestionsFallback(context),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(
    BuildContext context,
    AIShoppingSuggestion suggestion,
  ) {
    return Container(
      margin: EdgeInsets.only(
        bottom: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
      ),
      padding: ResponsiveUtils.padding(context, ResponsiveSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.md),
        ),
        border: Border.all(
          color: AppColors.lightYellow.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightYellow.withValues(alpha: 0.05),
            blurRadius: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
            margin: EdgeInsets.only(
              top: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
            ),
            decoration: BoxDecoration(
              color: AppColors.orange,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(
            width: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  suggestion.name,
                  style: AppTextStyles.melodrama(
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.lg,
                    ),
                    fontWeight: AppFontWeights.semiBold,
                    color: AppColors.button,
                    letterSpacing: 1.8,
                    height: 1.4,
                  ),
                ),
                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.xs,
                  ),
                ),
                Text(
                  suggestion.reason,
                  style: AppTextStyles.inter(
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.sm,
                    ),
                    fontWeight: AppFontWeights.regular,
                    letterSpacing: 0.2,
                    height: 1.4,
                    color: AppColors.button.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShoppingSuggestionsFallback(BuildContext context) {
    return Container(
      padding: ResponsiveUtils.padding(context, ResponsiveSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.lightYellow.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.md),
        ),
        border: Border.all(
          color: AppColors.lightYellow.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            CupertinoIcons.shopping_cart,
            size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.xl),
            color: AppColors.orange.withValues(alpha: 0.6),
          ),
          SizedBox(
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          ),
          Text(
            'Smart Shopping Ready!',
            style: AppTextStyles.melodrama(
              fontSize: ResponsiveUtils.fontSize(
                context,
                ResponsiveFontSize.lg,
              ),
              fontWeight: AppFontWeights.semiBold,
              color: AppColors.button,
              letterSpacing: 1.3,
              height: 1.4,
            ),
          ),
          SizedBox(
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
          ),
          Text(
            'Your ingredient collection looks great! I\'ll provide personalized shopping suggestions based on your cooking preferences and available recipes.',
            style: AppTextStyles.compagnon(
              fontSize: ResponsiveUtils.fontSize(
                context,
                ResponsiveFontSize.sm,
              ),
              fontWeight: AppFontWeights.regular,
              letterSpacing: 0.2,
              color: AppColors.button.withValues(alpha: 0.7),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
