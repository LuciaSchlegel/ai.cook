// Expanded Dialog
import 'package:ai_cook_project/dialogs/ai_recommendations/constants/dialog_constants.dart';
import 'package:ai_cook_project/models/recipe_model.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class RecipeExpandedDialog extends StatelessWidget {
  final Recipe recipe;

  const RecipeExpandedDialog({super.key, required this.recipe});

  // Responsive helper methods
  double _getInitialSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < DialogConstants.mobileBreakpoint) {
      return 0.9; // Larger on mobile for better content visibility
    } else if (screenWidth < DialogConstants.tabletBreakpoint) {
      return 0.85;
    } else {
      return 0.8; // Smaller on desktop
    }
  }

  double _getMinSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < DialogConstants.mobileBreakpoint) {
      return 0.6; // Higher minimum on mobile for better usability
    } else {
      return 0.5;
    }
  }

  double _getMaxSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < DialogConstants.mobileBreakpoint) {
      return 0.95;
    } else {
      return 0.9; // Leave more space on larger screens
    }
  }

  List<double> _getSnapSizes(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < DialogConstants.mobileBreakpoint) {
      return [0.6, 0.8, 0.95]; // Mobile-optimized snap points
    } else {
      return [0.5, 0.75, 0.9]; // Desktop-optimized snap points
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: _getInitialSize(context),
      minChildSize: _getMinSize(context),
      maxChildSize: _getMaxSize(context),
      snap: true,
      snapSizes: _getSnapSizes(context),
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
                      child: Padding(
                        padding: DialogConstants.adaptivePadding(context),
                        child: Column(
                          children: [
                            _InstructionsSection(recipe: recipe),
                            // Add safe area padding at bottom
                            SizedBox(
                              height: DialogConstants.safeScrollBottomPadding(
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
      padding: EdgeInsets.symmetric(
        horizontal: DialogConstants.adaptiveSpacing(
          context,
          DialogConstants.spacingMD,
        ),
        vertical: DialogConstants.adaptiveSpacing(
          context,
          DialogConstants.spacingMD,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              recipe.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 42,
                height: 1.2,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
                color: AppColors.button,
                fontFamily: 'Casta',
              ),
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
        horizontal: DialogConstants.adaptiveSpacing(
          context,
          DialogConstants.spacingMD,
        ),
        vertical: DialogConstants.spacingSM,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _ActionButton(
            icon: CupertinoIcons.calendar_badge_plus,
            label: 'Schedule',
            onTap: () {},
          ),
          const SizedBox(width: DialogConstants.spacingSM),
          _ActionButton(
            icon: CupertinoIcons.timer,
            label: 'Start',
            onTap: () {},
          ),
          const SizedBox(width: DialogConstants.spacingSM),
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
            icon: Icon(icon, size: 24, color: AppColors.button),
          ),
        ),
        const SizedBox(height: DialogConstants.spacingXS),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 10,
            height: 1.2,
            color: CupertinoColors.label,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
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
        Text(
          'Steps',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: AppColors.button,
            fontFamily: 'Times New Roman',
          ),
        ),
        SizedBox(height: DialogConstants.spacingSM),
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
          padding: const EdgeInsets.only(bottom: DialogConstants.spacingSM),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.mutedGreen,
                  borderRadius: BorderRadius.circular(DialogConstants.radiusSM),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: DialogConstants.spacingSM),
              Expanded(
                child: Text(
                  recipe.steps[index],
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: CupertinoColors.label,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
