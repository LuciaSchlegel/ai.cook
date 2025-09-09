import 'package:ai_cook_project/dialogs/ai_recommendations/constants/dialog_constants.dart';
import 'package:ai_cook_project/models/ai_response_model.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:flutter/cupertino.dart';

class AISubstitutionsSection extends StatelessWidget {
  final List<AISubstitution> substitutions;

  const AISubstitutionsSection({super.key, required this.substitutions});

  @override
  Widget build(BuildContext context) {
    // Show section even if empty, with fallback content

    return Container(
      margin: const EdgeInsets.only(bottom: DialogConstants.spacingMD),
      padding: const EdgeInsets.all(DialogConstants.spacingMD),
      decoration: DialogConstants.sectionDecoration.copyWith(
        gradient: DialogConstants.primaryGradient,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: DialogConstants.iconContainerDecoration(
                  AppColors.mutedGreen,
                ),
                child: Icon(
                  CupertinoIcons.arrow_2_circlepath,
                  size: 18,
                  color: AppColors.mutedGreen,
                ),
              ),
              const SizedBox(width: DialogConstants.spacingSM),
              Expanded(
                child: Text(
                  'Smart Substitutions',
                  style: DialogConstants.sectionTitleStyle,
                ),
              ),
            ],
          ),
          const SizedBox(height: DialogConstants.spacingMD),

          // Substitutions or fallback
          if (substitutions.isNotEmpty)
            ...substitutions.map(
              (substitution) => _buildSubstitutionItem(substitution),
            )
          else
            _buildSubstitutionsFallback(),
        ],
      ),
    );
  }

  Widget _buildSubstitutionItem(AISubstitution substitution) {
    return Container(
      margin: const EdgeInsets.only(bottom: DialogConstants.spacingSM),
      padding: const EdgeInsets.all(DialogConstants.spacingSM),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(DialogConstants.radiusSM),
        border: Border.all(
          color: AppColors.mutedGreen.withValues(
            alpha: DialogConstants.alphaMedium,
          ),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: AppColors.mutedGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              CupertinoIcons.arrow_right,
              size: 12,
              color: AppColors.mutedGreen,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  substitution.original,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.button,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  substitution.alternatives.join(', '),
                  style: TextStyle(
                    fontSize: 14,
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

  Widget _buildSubstitutionsFallback() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.mutedGreen.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.mutedGreen.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            CupertinoIcons.arrow_2_circlepath,
            size: 40,
            color: AppColors.mutedGreen.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 12),
          Text(
            'Substitution Master!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.button,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'You have all the ingredients you need! I\'ll suggest smart substitutions when needed to help you adapt recipes to your taste or dietary preferences.',
            style: TextStyle(
              fontSize: 14,
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
