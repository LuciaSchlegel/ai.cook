import 'package:ai_cook_project/models/ai_response_model.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';

class AISubstitutionsSection extends StatelessWidget {
  final List<AISubstitution> substitutions;

  const AISubstitutionsSection({super.key, required this.substitutions});

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
            AppColors.mutedGreen.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.mutedGreen.withValues(alpha: 0.08),
            blurRadius: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: AppColors.mutedGreen.withValues(alpha: 0.12),
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
                  color: AppColors.mutedGreen,
                  borderRadius: BorderRadius.circular(
                    ResponsiveUtils.borderRadius(
                      context,
                      ResponsiveBorderRadius.md,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.mutedGreen.withValues(alpha: 0.2),
                      blurRadius: ResponsiveUtils.spacing(
                        context,
                        ResponsiveSpacing.xs,
                      ),
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  CupertinoIcons.arrow_2_circlepath,
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
                  'Smart Substitutions',
                  style: AppTextStyles.casta(
                    fontSize:
                        ResponsiveUtils.fontSize(
                          context,
                          ResponsiveFontSize.title,
                        ) *
                        1.1,
                    fontWeight: AppFontWeights.bold,
                    color: AppColors.button,
                    letterSpacing: 0.8,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
          ),

          // Substitutions or fallback
          if (substitutions.isNotEmpty)
            ...substitutions.map(
              (substitution) => _buildSubstitutionItem(substitution, context),
            )
          else
            _buildSubstitutionsFallback(context),
        ],
      ),
    );
  }

  Widget _buildSubstitutionItem(
    AISubstitution substitution,
    BuildContext context,
  ) {
    return Container(
      margin: EdgeInsets.only(
        bottom: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
      ),
      padding: EdgeInsets.all(
        ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.sm),
        ),
        border: Border.all(
          color: AppColors.mutedGreen.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            margin: EdgeInsets.only(
              top: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            ),
            decoration: BoxDecoration(
              color: AppColors.mutedGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.borderRadius(
                  context,
                  ResponsiveBorderRadius.sm,
                ),
              ),
            ),
            child: Icon(
              CupertinoIcons.arrow_right,
              size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.sm),
              color: AppColors.mutedGreen,
            ),
          ),
          SizedBox(
            width: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  substitution.original,
                  style: AppTextStyles.casta(
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.xl,
                    ),
                    fontWeight: AppFontWeights.bold,
                    letterSpacing: 1.8,
                    height: 1.2,
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
                  substitution.alternatives.join(', '),
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

  Widget _buildSubstitutionsFallback(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
      ),
      decoration: BoxDecoration(
        color: AppColors.mutedGreen.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.md),
        ),
        border: Border.all(
          color: AppColors.mutedGreen.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            CupertinoIcons.arrow_2_circlepath,
            size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.md),
            color: AppColors.mutedGreen.withValues(alpha: 0.6),
          ),
          SizedBox(
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          ),
          Text(
            'Substitution Master!',
            style: TextStyle(
              fontSize: ResponsiveUtils.fontSize(
                context,
                ResponsiveFontSize.lg,
              ),
              fontWeight: AppFontWeights.semiBold,
              fontFamily: 'Compagnon',
              color: AppColors.button,
              letterSpacing: 1.3,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          ),
          Text(
            'You have all the ingredients you need! I\'ll suggest smart substitutions when needed to help you adapt recipes to your taste or dietary preferences.',
            style: TextStyle(
              fontSize: ResponsiveUtils.fontSize(
                context,
                ResponsiveFontSize.lg,
              ),
              fontWeight: AppFontWeights.regular,
              fontFamily: 'Inter',
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
