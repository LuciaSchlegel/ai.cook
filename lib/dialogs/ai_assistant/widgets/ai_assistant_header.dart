import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/cupertino.dart';

class AiAssistantHeader extends StatefulWidget {
  const AiAssistantHeader({super.key});

  @override
  State<AiAssistantHeader> createState() => _AiAssistantHeaderState();
}

class _AiAssistantHeaderState extends State<AiAssistantHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _breatheController;
  late Animation<double> _breatheAnimation;

  @override
  void initState() {
    super.initState();
    // Subtle breathing animation for the icon glow
    _breatheController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _breatheAnimation = Tween<double>(begin: 0.2, end: 0.35).animate(
      CurvedAnimation(parent: _breatheController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breatheController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // AI Icon with subtle animated glow
        AnimatedBuilder(
          animation: _breatheAnimation,
          builder: (context, child) {
            return Container(
              padding: EdgeInsets.all(
                ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
              ),
              decoration: BoxDecoration(
                gradient: AppColors.gradientBackground,
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.borderRadius(
                    context,
                    ResponsiveBorderRadius.lg,
                  ),
                ),
                boxShadow: [
                  // Primary shadow
                  BoxShadow(
                    color: AppColors.mutedGreen.withValues(
                      alpha: _breatheAnimation.value,
                    ),
                    blurRadius: ResponsiveUtils.spacing(
                      context,
                      ResponsiveSpacing.lg,
                    ),
                    offset: const Offset(0, 4),
                  ),
                  // Soft ambient glow
                  BoxShadow(
                    color: AppColors.mutedGreen.withValues(
                      alpha: _breatheAnimation.value * 0.5,
                    ),
                    blurRadius: ResponsiveUtils.spacing(
                      context,
                      ResponsiveSpacing.xl,
                    ),
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: child,
            );
          },
          child: Icon(
            CupertinoIcons.sparkles,
            color: CupertinoColors.white,
            size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.xl),
          ),
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(context, ResponsiveSpacing.lg),
        ),
        // Title with subtle gradient
        ShaderMask(
          shaderCallback:
              (bounds) => LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.button,
                  AppColors.button.withValues(alpha: 0.85),
                ],
              ).createShader(bounds),
          child: Text(
            'AI Kitchen Assistant',
            style: AppTextStyles.casta(
              fontSize:
                  ResponsiveUtils.fontSize(context, ResponsiveFontSize.title) *
                  1.3,
              fontWeight: AppFontWeights.bold,
              color: CupertinoColors.white,
              letterSpacing: 0.5,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
        ),
        // Subtitle
        Text(
          'Smart features powered by Anthropic\'s® Claude AI',
          style: AppTextStyles.inter(
            fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.sm),
            fontWeight: AppFontWeights.regular,
            color: AppColors.button.withValues(alpha: 0.5),
            letterSpacing: 0.2,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
