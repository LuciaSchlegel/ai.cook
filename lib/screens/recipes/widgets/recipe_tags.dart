import 'package:ai_cook_project/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecipeTags extends StatelessWidget {
  final List<String> tags;

  const RecipeTags({required this.tags, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 35,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tags.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: _RecipeTag(tag: tags[index]),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _RecipeTag extends StatelessWidget {
  final String tag;

  const _RecipeTag({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Chip(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      side: BorderSide(
        color: AppColors.mutedGreen.withOpacity(0.3),
        width: 0.5,
      ),
      label: Text(
        tag,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: AppColors.white,
          fontFamily: 'Inter',
          letterSpacing: 0.2,
        ),
      ),
      backgroundColor: AppColors.mutedGreen,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}
