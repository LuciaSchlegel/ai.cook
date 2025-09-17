import 'package:ai_cook_project/models/ai_response_model.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          colors: [AppColors.white, AppColors.orange.withValues(alpha: 0.02)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.orange.withValues(alpha: 0.06),
            blurRadius: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: AppColors.orange.withValues(alpha: 0.15),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Container(
                width: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
                height: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.orange.withValues(alpha: 0.2),
                      AppColors.lightYellow.withValues(alpha: 0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(
                    ResponsiveUtils.borderRadius(
                      context,
                      ResponsiveBorderRadius.sm,
                    ),
                  ),
                ),
                child: Icon(
                  CupertinoIcons.cart,
                  size: ResponsiveUtils.iconSize(
                    context,
                    ResponsiveIconSize.md,
                  ),
                  color: AppColors.orange,
                ),
              ),
              SizedBox(
                width: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
              ),
              Expanded(
                child: Text(
                  'Almost Ready Recipes',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.md,
                    ),
                    fontWeight: FontWeight.w700,
                    color: AppColors.button,
                    letterSpacing: 0.3,
                  ),
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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ResponsiveUtils.fontSize(
                              context,
                              ResponsiveFontSize.md,
                            ),
                          ),
                        ),
                        Text(
                          recipe.description,
                          style: TextStyle(
                            fontSize: ResponsiveUtils.fontSize(
                              context,
                              ResponsiveFontSize.sm,
                            ),
                          ),
                        ),
                        Text(
                          'Missing: ${recipe.missingIngredients.join(', ')}',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.fontSize(
                              context,
                              ResponsiveFontSize.sm,
                            ),
                          ),
                        ),
                        Text(
                          '${recipe.timeMinutes} | ${recipe.difficulty}',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.fontSize(
                              context,
                              ResponsiveFontSize.sm,
                            ),
                            color: Colors.grey,
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
