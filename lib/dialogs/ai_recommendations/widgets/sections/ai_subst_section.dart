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
      padding: EdgeInsets.all(
        ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.white, AppColors.orange.withValues(alpha: 0.02)],
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
                decoration: BoxDecoration(color: AppColors.mutedGreen),
                child: Icon(
                  CupertinoIcons.arrow_2_circlepath,
                  size: ResponsiveUtils.iconSize(
                    context,
                    ResponsiveIconSize.md,
                  ),
                  color: AppColors.mutedGreen,
                ),
              ),
              SizedBox(
                width: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
              ),
              Expanded(
                child: Text(
                  'Smart Substitutions',
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
            width: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  substitution.original,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.sm,
                    ),
                    fontWeight: FontWeight.w600,
                    color: AppColors.button,
                  ),
                ),
                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.sm,
                  ),
                ),
                Text(
                  substitution.alternatives.join(', '),
                  style: TextStyle(
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.sm,
                    ),
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
                ResponsiveFontSize.sm,
              ),
              fontWeight: FontWeight.w600,
              color: AppColors.button,
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
                ResponsiveFontSize.sm,
              ),
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
