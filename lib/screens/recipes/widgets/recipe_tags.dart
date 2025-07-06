import 'package:ai_cook_project/theme.dart';
import 'package:flutter/material.dart';

class RecipeTags extends StatelessWidget {
  final List<String> tags;

  const RecipeTags({required this.tags, super.key});

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: tags.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(
                right: index < tags.length - 1 ? 12.0 : 0.0,
              ),
              child: _RecipeTag(tag: tags[index]),
            );
          },
        ),
      ),
    );
  }
}

class _RecipeTag extends StatelessWidget {
  final String tag;

  const _RecipeTag({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.mutedGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.mutedGreen.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        tag,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: AppColors.mutedGreen,
          fontFamily: 'Inter',
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
