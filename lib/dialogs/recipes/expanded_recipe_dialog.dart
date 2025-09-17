// Expanded Dialog
import 'package:ai_cook_project/models/recipe_model.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class RecipeExpandedDialog extends StatelessWidget {
  final Recipe recipe;

  const RecipeExpandedDialog({super.key, required this.recipe});

  // Note: Responsive helper methods now handled by ResponsiveUtils.getModalConfig()

  @override
  Widget build(BuildContext context) {
    // Use the new responsive modal configuration
    final modalConfig = ResponsiveUtils.getModalConfig(context);

    return DraggableScrollableSheet(
      initialChildSize: modalConfig.initialSize,
      minChildSize: modalConfig.minSize,
      maxChildSize: modalConfig.maxSize,
      snap: true,
      snapSizes: modalConfig.snapSizes,
      builder: (context, scrollController) {
        return SafeArea(
          // Handle top safe area (notch/Dynamic Island) but let bottom be handled by scroll content
          top: true,
          bottom: false,
          child: Container(
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(
                  ResponsiveUtils.borderRadius(
                    context,
                    ResponsiveBorderRadius.xl,
                  ),
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.button.withValues(alpha: 0.1),
                  blurRadius: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.sm,
                  ),
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(
                  ResponsiveUtils.borderRadius(
                    context,
                    ResponsiveBorderRadius.xl,
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.sm,
                  ),
                ),
                child: Column(
                  children: [
                    // Add small top padding for better visual spacing
                    SizedBox(
                      height: ResponsiveUtils.spacing(
                        context,
                        ResponsiveSpacing.xs,
                      ),
                    ),
                    const _DragHandle(),
                    _ExpandedHeader(recipe: recipe),
                    Container(
                      margin: EdgeInsets.only(
                        left: ResponsiveUtils.spacing(
                          context,
                          ResponsiveSpacing.lg,
                        ),
                        right: ResponsiveUtils.spacing(
                          context,
                          ResponsiveSpacing.lg,
                        ),
                      ),
                      padding:
                          ResponsiveUtils.padding(
                            context,
                            ResponsiveSpacing.xxs,
                          ) *
                          0.4,
                      decoration: BoxDecoration(
                        color: AppColors.button.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.borderRadius(
                            context,
                            ResponsiveBorderRadius.lg,
                          ),
                        ),
                      ),
                    ),
                    const ResponsiveSpacingWidget.vertical(
                      ResponsiveSpacing.sm,
                    ),
                    _ActionButtons(),
                    // Add subtle divider before steps
                    Container(
                      margin: ResponsiveUtils.horizontalPadding(
                        context,
                        ResponsiveSpacing.lg,
                      ),
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            AppColors.mutedGreen.withValues(alpha: 0.2),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    ResponsiveSpacingWidget.vertical(ResponsiveSpacing.sm),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        child: ResponsiveContainer(
                          padding: ResponsiveSpacing.md,
                          child: Column(
                            children: [
                              _InstructionsSection(recipe: recipe),
                              // Add safe area padding at bottom using responsive system
                              SizedBox(
                                height: ResponsiveUtils.getScrollBottomPadding(
                                  context,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
      ),
      child: Container(
        width: ResponsiveUtils.spacing(context, ResponsiveSpacing.xxl),
        height: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey3,
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.sm),
          ),
        ),
      ),
    );
  }
}

class _ExpandedHeader extends StatelessWidget {
  final Recipe recipe;

  const _ExpandedHeader({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveUtils.padding(context, ResponsiveSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ResponsiveText(
              recipe.name,
              fontSize: ResponsiveUtils.fontSize(
                context,
                ResponsiveFontSize.title2,
              ),
              fontWeight: AppFontWeights.semiBold,
              color: AppColors.button,
              fontFamily: 'Melodrama',
              letterSpacing: 1.8,
              height: 1.4,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
        vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _ActionButton(
            icon: CupertinoIcons.calendar_badge_plus,
            label: 'Schedule',
            onTap: () {},
          ),
          ResponsiveSpacingWidget.horizontal(ResponsiveSpacing.lg),
          _ActionButton(
            icon: CupertinoIcons.timer,
            label: 'Start',
            onTap: () {},
          ),
          ResponsiveSpacingWidget.horizontal(ResponsiveSpacing.lg),
          _ActionButton(
            icon: CupertinoIcons.share,
            label: 'Share',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: ResponsiveUtils.spacing(context, ResponsiveSpacing.xl),
          height: ResponsiveUtils.spacing(context, ResponsiveSpacing.xl),
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey6.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
            ),
          ),
          child: IconButton(
            onPressed: onTap,
            padding: EdgeInsets.zero,
            icon: ResponsiveIcon(
              icon,
              null,
              size: ResponsiveIconSize.lg,
              color: AppColors.button,
            ),
          ),
        ),
        ResponsiveSpacingWidget.vertical(ResponsiveSpacing.xs),
        ResponsiveText(
          label,
          fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.xs),
          fontWeight: AppFontWeights.medium,
          color: CupertinoColors.label,
          fontFamily: 'Inter',
          height: 1.2,
          letterSpacing: 0.2,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _InstructionsSection extends StatelessWidget {
  final Recipe recipe;
  const _InstructionsSection({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Enhanced section header
        Row(
          children: [
            Container(
              width: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
              height: ResponsiveUtils.fontSize(
                context,
                ResponsiveFontSize.title,
              ),
              decoration: BoxDecoration(
                gradient: AppColors.gradientOrange,
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.borderRadius(
                    context,
                    ResponsiveBorderRadius.sm,
                  ),
                ),
              ),
            ),
            ResponsiveSpacingWidget.horizontal(ResponsiveSpacing.sm),
            Expanded(
              child: ResponsiveText(
                'Cooking Steps',
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  ResponsiveFontSize.title,
                ),
                fontWeight: AppFontWeights.semiBold,
                color: AppColors.button,
                fontFamily: 'Melodrama',
                letterSpacing: 1.2,
              ),
            ),
            // Step count badge
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.spacing(
                  context,
                  ResponsiveSpacing.sm,
                ),
                vertical: ResponsiveUtils.spacing(
                  context,
                  ResponsiveSpacing.xs,
                ),
              ),
              decoration: BoxDecoration(
                color: AppColors.mutedGreen.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.borderRadius(
                    context,
                    ResponsiveBorderRadius.lg,
                  ),
                ),
              ),
              child: ResponsiveText(
                '${recipe.steps.length} steps',
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  ResponsiveFontSize.sm,
                ),
                fontWeight: AppFontWeights.medium,
                color: AppColors.mutedGreen,
                fontFamily: 'Inter',
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
        ResponsiveSpacingWidget.vertical(ResponsiveSpacing.lg),
        _RecipeStepsView(recipe: recipe),
      ],
    );
  }
}

class _RecipeStepsView extends StatelessWidget {
  final Recipe recipe;

  const _RecipeStepsView({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(
        recipe.steps.length,
        (index) => _StepCard(
          stepNumber: index + 1,
          stepText: recipe.steps[index],
          isLastStep: index == recipe.steps.length - 1,
          isFirstStep: index == 0,
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final int stepNumber;
  final String stepText;
  final bool isLastStep;
  final bool isFirstStep;

  const _StepCard({
    required this.stepNumber,
    required this.stepText,
    required this.isLastStep,
    this.isFirstStep = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Centered step number divider (shown for every step)
        _CenteredStepDivider(stepNumber: stepNumber),
        ResponsiveSpacingWidget.vertical(ResponsiveSpacing.md),

        // Step content card
        Container(
          margin: ResponsiveUtils.padding(
            context,
            ResponsiveSpacing.xs,
          ).copyWith(top: 0),
          padding: ResponsiveUtils.padding(context, ResponsiveSpacing.lg),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.xl),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.button.withValues(alpha: 0.06),
                blurRadius: ResponsiveUtils.spacing(
                  context,
                  ResponsiveSpacing.sm,
                ),
                offset: const Offset(0, 2),
                spreadRadius: 0,
              ),
            ],
            border: Border.all(
              color: AppColors.mutedGreen.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: ResponsiveText(
            stepText,
            fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.md),
            height: 1.6,
            fontFamily: 'Inter',
            letterSpacing: 0.3,
            color: AppColors.button,
            fontWeight: AppFontWeights.regular,
          ),
        ),

        // Spacing after step
        if (!isLastStep) ...[
          ResponsiveSpacingWidget.vertical(ResponsiveSpacing.lg),
        ] else ...[
          // Extra spacing after last step
          ResponsiveSpacingWidget.vertical(ResponsiveSpacing.lg),
        ],
      ],
    );
  }
}

class _CenteredStepDivider extends StatelessWidget {
  final int stepNumber;

  const _CenteredStepDivider({required this.stepNumber});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left line
        Expanded(
          child: Container(
            height: 1.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.transparent,
                  AppColors.mutedGreen.withValues(alpha: 0.3),
                  AppColors.mutedGreen.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),
        ),

        // Step number circle
        Container(
          margin: ResponsiveUtils.horizontalPadding(
            context,
            ResponsiveSpacing.md,
          ),
          width: ResponsiveUtils.iconSize(context, ResponsiveIconSize.xl),
          height: ResponsiveUtils.iconSize(context, ResponsiveIconSize.xl),
          decoration: BoxDecoration(
            gradient: AppColors.gradientOrange,
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.borderRadius(
                context,
                ResponsiveBorderRadius.xxxl,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.orange.withValues(alpha: 0.3),
                blurRadius: ResponsiveUtils.spacing(
                  context,
                  ResponsiveSpacing.sm,
                ),
                offset: const Offset(0, 2),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Center(
            child: ResponsiveText(
              '$stepNumber',
              fontSize: ResponsiveUtils.fontSize(
                context,
                ResponsiveFontSize.sm,
              ),
              fontWeight: AppFontWeights.bold,
              color: Colors.white,
              fontFamily: 'Melodrama',
              letterSpacing: 0.5,
            ),
          ),
        ),

        // Right line
        Expanded(
          child: Container(
            height: 1.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.mutedGreen.withValues(alpha: 0.6),
                  AppColors.mutedGreen.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
