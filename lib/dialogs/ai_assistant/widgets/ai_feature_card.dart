import 'package:ai_cook_project/dialogs/ai_assistant/ai_assistant_dialog.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/cupertino.dart';

class AIFeatureCard extends StatefulWidget {
  final AIFeature feature;
  final VoidCallback onTap;

  const AIFeatureCard({
    super.key,
    required this.feature,
    required this.onTap,
  });

  @override
  State<AIFeatureCard> createState() => _AIFeatureCardState();
}

class _AIFeatureCardState extends State<AIFeatureCard> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    widget.onTap();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final config = _getFeatureConfig(widget.feature);

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: Container(
          decoration: BoxDecoration(
            color: CupertinoColors.white,
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.xl),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.button.withValues(
                  alpha: _isPressed ? 0.08 : 0.05,
                ),
                blurRadius: _isPressed ? 20 : 12,
                offset: Offset(0, _isPressed ? 6 : 3),
              ),
            ],
          ),
          child: Padding(
            padding: ResponsiveUtils.padding(context, ResponsiveSpacing.md),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon container
                _buildIconContainer(context, config),
                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.md,
                  ),
                ),
                // Title
                Text(
                  config.title,
                  style: AppTextStyles.casta(
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.md,
                    ),
                    fontWeight: AppFontWeights.bold,
                    color: AppColors.button,
                    letterSpacing: 0.3,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.xs,
                  ),
                ),
                // Subtitle
                Text(
                  config.subtitle,
                  style: AppTextStyles.inter(
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.xs,
                    ),
                    fontWeight: AppFontWeights.regular,
                    color: AppColors.button.withValues(alpha: 0.5),
                    letterSpacing: 0.1,
                    height: 1.35,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer(BuildContext context, _FeatureConfig config) {
    final containerSize =
        ResponsiveUtils.iconSize(context, ResponsiveIconSize.xxl) * 1.35;

    return Container(
      width: containerSize,
      height: containerSize,
      decoration: BoxDecoration(
        color: AppColors.systemBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
        ),
      ),
      child: Icon(
        config.icon,
        size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.lg),
        color: AppColors.systemBlue,
      ),
    );
  }

  _FeatureConfig _getFeatureConfig(AIFeature feature) {
    switch (feature) {
      case AIFeature.substitutions:
        return const _FeatureConfig(
          icon: CupertinoIcons.arrow_2_circlepath,
          title: 'Substitutions',
          subtitle: 'Find alternatives for any ingredient',
        );
      case AIFeature.unitConversion:
        return const _FeatureConfig(
          icon: CupertinoIcons.gauge,
          title: 'Unit Converter',
          subtitle: 'Cups to grams, oz to ml...',
        );
      case AIFeature.dietAdaptation:
        return const _FeatureConfig(
          icon: CupertinoIcons.leaf_arrow_circlepath,
          title: 'Diet Adapter',
          subtitle: 'Make recipes vegan, gluten-free...',
        );
      case AIFeature.recommendations:
        return const _FeatureConfig(
          icon: CupertinoIcons.sparkles,
          title: 'Recommendations',
          subtitle: 'Recipes based on your pantry',
        );
    }
  }
}

class _FeatureConfig {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureConfig({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
