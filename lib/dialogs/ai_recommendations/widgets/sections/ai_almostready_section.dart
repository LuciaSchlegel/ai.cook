import 'package:ai_cook_project/models/ai_response_model.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/cupertino.dart';

class AIAlmostReadySection extends StatelessWidget {
  final List<AIAlmostReadyRecipe> content;

  const AIAlmostReadySection({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    if (content.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(
        bottom: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
      ),
      padding: ResponsiveUtils.padding(context, ResponsiveSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.white, AppColors.orange.withValues(alpha: 0.03)],
        ),
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.orange.withValues(alpha: 0.08),
            blurRadius: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: AppColors.orange.withValues(alpha: 0.2),
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
                    colors: [AppColors.orange, AppColors.lightYellow],
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
                  CupertinoIcons.cart,
                  size: ResponsiveUtils.iconSize(
                    context,
                    ResponsiveIconSize.md,
                  ),
                  color: AppColors.white,
                ),
              ),
              SizedBox(
                width: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
              ),
              Expanded(
                child: Text(
                  'Almost Ready Recipes',
                  style: CompagnonTextStyles.bold(
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.lg,
                    ),
                    color: AppColors.button,
                  ).copyWith(letterSpacing: 0.3),
                ),
              ),
            ],
          ),
          SizedBox(
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          ),

          // Content
          Column(
            children:
                content.map((recipe) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: ResponsiveUtils.spacing(
                        context,
                        ResponsiveSpacing.xs,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe.title,
                          style: CompagnonTextStyles.bold(
                            fontSize: ResponsiveUtils.fontSize(
                              context,
                              ResponsiveFontSize.md,
                            ),
                            color: AppColors.button,
                          ),
                        ),
                        SizedBox(
                          height: ResponsiveUtils.spacing(
                            context,
                            ResponsiveSpacing.xs,
                          ),
                        ),
                        Text(
                          recipe.description,
                          style: CompagnonTextStyles.regular(
                            fontSize: ResponsiveUtils.fontSize(
                              context,
                              ResponsiveFontSize.sm,
                            ),
                            color: AppColors.button.withValues(alpha: 0.8),
                            height: 1.3,
                          ),
                        ),
                        SizedBox(
                          height: ResponsiveUtils.spacing(
                            context,
                            ResponsiveSpacing.xs,
                          ),
                        ),
                        Text(
                          'Missing: ${recipe.missingIngredients.join(', ')}',
                          style: CompagnonTextStyles.medium(
                            fontSize: ResponsiveUtils.fontSize(
                              context,
                              ResponsiveFontSize.sm,
                            ),
                            color: AppColors.orange,
                          ),
                        ),
                        SizedBox(
                          height: ResponsiveUtils.spacing(
                            context,
                            ResponsiveSpacing.xs,
                          ),
                        ),
                        Text(
                          '${recipe.timeMinutes} | ${recipe.difficulty}',
                          style: CompagnonTextStyles.regular(
                            fontSize: ResponsiveUtils.fontSize(
                              context,
                              ResponsiveFontSize.sm,
                            ),
                            color: AppColors.button.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
