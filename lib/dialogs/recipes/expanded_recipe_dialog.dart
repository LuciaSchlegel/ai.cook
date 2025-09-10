// Expanded Dialog
import 'package:ai_cook_project/dialogs/ai_recommendations/constants/dialog_constants.dart';
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
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(DialogConstants.radiusXL),
              ),
              boxShadow: DialogConstants.dialogShadow,
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(DialogConstants.radiusXL),
              ),
              child: Column(
                children: [
                  // Add small top padding for better visual spacing
                  const SizedBox(height: DialogConstants.spacingXS),
                  const _DragHandle(),
                  _ExpandedHeader(recipe: recipe),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    margin: EdgeInsets.only(
                      left: DialogConstants.spacingMD,
                      right: DialogConstants.spacingMD,
                      bottom: DialogConstants.spacingSM,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.button.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(
                        DialogConstants.radiusLG,
                      ),
                    ),
                  ),
                  _ActionButtons(),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
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
      padding: const EdgeInsets.symmetric(vertical: DialogConstants.spacingSM),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey3,
          borderRadius: BorderRadius.circular(2),
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
              fontSize: ResponsiveFontSize.display,
              fontWeight: FontWeight.w600,
              color: AppColors.button,
              fontFamily: 'Casta',
              letterSpacing: 1,
              height: 1.2,
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
          ResponsiveSpacingWidget.horizontal(ResponsiveSpacing.sm),
          _ActionButton(
            icon: CupertinoIcons.timer,
            label: 'Start',
            onTap: () {},
          ),
          ResponsiveSpacingWidget.horizontal(ResponsiveSpacing.sm),
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
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey6.withOpacity(0.5),
            borderRadius: BorderRadius.circular(DialogConstants.radiusLG),
          ),
          child: IconButton(
            onPressed: onTap,
            padding: EdgeInsets.zero,
            icon: ResponsiveIcon(
              icon,
              size: ResponsiveIconSize.md,
              color: AppColors.button,
            ),
          ),
        ),
        ResponsiveSpacingWidget.vertical(ResponsiveSpacing.xs),
        ResponsiveText(
          label,
          fontSize: ResponsiveFontSize.xs,
          fontWeight: FontWeight.w500,
          color: CupertinoColors.label,
          fontFamily: 'Inter',
          height: 1.2,
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
        ResponsiveText(
          'Steps',
          fontSize: ResponsiveFontSize.xl,
          fontWeight: FontWeight.w500,
          color: AppColors.button,
          fontFamily: 'Times New Roman',
        ),
        ResponsiveSpacingWidget.vertical(ResponsiveSpacing.sm),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        recipe.steps.length,
        (index) => Padding(
          padding: EdgeInsets.only(
            bottom: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: ResponsiveUtils.iconSize(context, ResponsiveIconSize.md),
                height: ResponsiveUtils.iconSize(
                  context,
                  ResponsiveIconSize.md,
                ),
                decoration: BoxDecoration(
                  color: AppColors.mutedGreen,
                  borderRadius: BorderRadius.circular(
                    ResponsiveUtils.borderRadius(
                      context,
                      ResponsiveBorderRadius.sm,
                    ),
                  ),
                ),
                child: Center(
                  child: ResponsiveText(
                    '${index + 1}',
                    fontSize: ResponsiveFontSize.xs,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              ResponsiveSpacingWidget.horizontal(ResponsiveSpacing.sm),
              Expanded(
                child: ResponsiveText(
                  recipe.steps[index],
                  fontSize: ResponsiveFontSize.md,
                  height: 1.5,
                  color: CupertinoColors.label,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
