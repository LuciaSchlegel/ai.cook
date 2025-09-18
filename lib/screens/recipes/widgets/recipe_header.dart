import 'package:ai_cook_project/dialogs/ai_recommendations/widgets/utils/image_clip_ovcard.dart';
import 'package:ai_cook_project/models/recipe_model.dart';
import 'package:ai_cook_project/screens/recipes/widgets/recipe_title.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:flutter/cupertino.dart';

class RecipeHeader extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onClose;

  const RecipeHeader({required this.recipe, required this.onClose, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RecipeTitle(name: recipe.name),
          ResponsiveSpacingWidget.vertical(ResponsiveSpacing.lg),
          ImageClipOvCard(imageUrl: recipe.image ?? ''),
        ],
      ),
    );
  }
}
