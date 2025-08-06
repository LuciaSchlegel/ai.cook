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
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.white, AppColors.mutedGreen.withOpacity(0.04)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.mutedGreen.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: AppColors.mutedGreen.withOpacity(0.2),
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
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.mutedGreen.withOpacity(0.2),
                      AppColors.lightYellow.withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  CupertinoIcons.arrow_2_circlepath,
                  size: 18,
                  color: AppColors.mutedGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Smart Substitutions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.button,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.mutedGreen.withOpacity(0.15),
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
              color: AppColors.mutedGreen.withOpacity(0.1),
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
                  substitution.ingredient,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.button,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  substitution.substitutes,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: AppColors.button.withOpacity(0.8),
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
        color: AppColors.mutedGreen.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.mutedGreen.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            CupertinoIcons.arrow_2_circlepath,
            size: 40,
            color: AppColors.mutedGreen.withOpacity(0.6),
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
              color: AppColors.button.withOpacity(0.7),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
