// Expanded Dialog
import 'package:ai_cook_project/models/recipe_model.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class RecipeExpandedDialog extends StatelessWidget {
  final Recipe recipe;

  const RecipeExpandedDialog({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: CupertinoColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              const _DragHandle(),
              _ExpandedHeader(recipe: recipe),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 1),
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                decoration: BoxDecoration(
                  color: AppColors.button.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              _ActionButtons(),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: _InstructionsSection(recipe: recipe),
                  ),
                ),
              ),
            ],
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
      padding: const EdgeInsets.symmetric(vertical: 12),
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            recipe.name,
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: AppColors.button,
              fontFamily: 'Casta',
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _ActionButton(
            icon: CupertinoIcons.calendar_badge_plus,
            label: 'Schedule',
            onTap: () {},
          ),
          const SizedBox(width: 16),
          _ActionButton(
            icon: CupertinoIcons.timer,
            label: 'Start',
            onTap: () {},
          ),
          const SizedBox(width: 16),
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
            borderRadius: BorderRadius.circular(20),
          ),
          child: IconButton(
            onPressed: onTap,
            padding: EdgeInsets.zero,
            icon: Icon(icon, size: 24, color: AppColors.button),
          ),
        ),
        const SizedBox(height: 8),
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
        SizedBox(height: 16),
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
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.mutedGreen,
                  borderRadius: BorderRadius.circular(12),
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
              const SizedBox(width: 12),
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
