import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';

class SwipeIndicator extends StatefulWidget {
  const SwipeIndicator({super.key});

  @override
  State<SwipeIndicator> createState() => _SwipeIndicatorState();
}

class _SwipeIndicatorState extends State<SwipeIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Comienza desde abajo
      end: Offset.zero, // Termina en su posición final
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Inicia la animación después de un pequeño delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: ResponsiveUtils.spacing(context, ResponsiveSpacing.lg),
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.spacing(
                  context,
                  ResponsiveSpacing.md,
                ),
                vertical: ResponsiveUtils.spacing(
                  context,
                  ResponsiveSpacing.sm,
                ),
              ),
              decoration: BoxDecoration(
                color: AppColors.button.withValues(alpha: 0.98),
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.borderRadius(
                    context,
                    ResponsiveBorderRadius.xxl,
                  ),
                ),
                border: Border.all(
                  color: AppColors.mutedGreen.withValues(alpha: 0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.1),
                    blurRadius: ResponsiveUtils.spacing(
                      context,
                      ResponsiveSpacing.xs,
                    ),
                    offset: Offset(
                      0,
                      ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
                    ),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    CupertinoIcons.chevron_up,
                    size: ResponsiveUtils.iconSize(
                      context,
                      ResponsiveIconSize.sm,
                    ),
                    color: AppColors.white,
                  ),
                  const ResponsiveSpacingWidget.horizontal(
                    ResponsiveSpacing.xs,
                  ),
                  Text(
                    'Swipe up for details',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        ResponsiveFontSize.sm,
                      ),
                      fontWeight: AppFontWeights.medium,
                      color: AppColors.white,
                      fontFamily: 'Inter',
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
