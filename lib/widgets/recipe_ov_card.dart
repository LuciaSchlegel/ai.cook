import 'package:ai_cook_project/dialogs/expanded_recipe_dialog.dart';
import 'package:ai_cook_project/models/recipe_ingredient_model.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/recipe_model.dart';
import 'nutrition_card.dart';

class RecipeOverviewCard extends StatefulWidget {
  final Recipe recipe;

  const RecipeOverviewCard({super.key, required this.recipe});

  @override
  State<RecipeOverviewCard> createState() => _RecipeOverviewCardState();
}

class _RecipeOverviewCardState extends State<RecipeOverviewCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  double _dragStart = 0;
  static const double _dragThreshold = 50.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (details.primaryDelta! < 0) {
      // Swipe up
      if (_dragStart == 0) {
        _dragStart = details.globalPosition.dy;
      }
      if (_dragStart - details.globalPosition.dy > _dragThreshold) {
        _showExpandedDialog();
      }
    } else if (details.primaryDelta! > 0) {
      // Swipe down
      if (_dragStart == 0) {
        _dragStart = details.globalPosition.dy;
      }
      if (details.globalPosition.dy - _dragStart > _dragThreshold) {
        Navigator.pop(context);
      }
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    _dragStart = 0;
  }

  void _showExpandedDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      transitionAnimationController: _animationController,
      builder: (context) => RecipeExpandedDialog(recipe: widget.recipe),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: size.height * 0.04,
      ),
      child: GestureDetector(
        onVerticalDragUpdate: _handleDragUpdate,
        onVerticalDragEnd: _handleDragEnd,
        child: Card(
          elevation: 4,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          clipBehavior: Clip.antiAlias,
          color: CupertinoColors.white,
          child: SizedBox(
            height: size.height * 0.85,
            width: size.width * 0.88,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _RecipeHeader(
                        recipe: widget.recipe,
                        onClose: () => Navigator.pop(context),
                      ),
                      const SizedBox(height: 20),
                      _RecipeTags(tags: widget.recipe.tags),
                      const SizedBox(height: 20),
                      _RecipeGlanceCard(recipe: widget.recipe, size: size),
                    ],
                  ),
                ),
                const _SwipeIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RecipeHeader extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onClose;

  const _RecipeHeader({required this.recipe, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _RecipeImage(imageUrl: recipe.imageUrl),
          Expanded(child: _RecipeTitle(name: recipe.name)),
        ],
      ),
    );
  }
}

class _RecipeImage extends StatelessWidget {
  final String? imageUrl;

  const _RecipeImage({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.network(
        imageUrl ?? '',
        width: 110,
        height: 110,
        fit: BoxFit.cover,
        cacheWidth: (110 * MediaQuery.of(context).devicePixelRatio).round(),
        errorBuilder:
            (_, __, ___) => const Icon(
              CupertinoIcons.photo,
              size: 100,
              color: AppColors.button,
            ),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CupertinoActivityIndicator());
        },
      ),
    );
  }
}

class _RecipeTitle extends StatelessWidget {
  final String name;

  const _RecipeTitle({required this.name});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final text = name;
        final words = text.split(' ');

        String line1 = '';
        String line2 = '';

        if (words.length == 1) {
          line1 = text;
        } else {
          int splitIndex = (words.length / 2).ceil();
          line1 = words.take(splitIndex).join(' ');
          line2 = words.skip(splitIndex).join(' ');
        }

        final availableWidth = constraints.maxWidth * 0.95;
        final textStyle = _calculateTextStyle(words);

        return Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.03,
            right: MediaQuery.of(context).size.width * 0.02,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: availableWidth,
                child: Text(
                  line1,
                  style: textStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (line2.isNotEmpty) ...[
                const SizedBox(height: 4),
                SizedBox(
                  width: availableWidth,
                  child: Text(
                    line2,
                    style: textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  TextStyle _calculateTextStyle(List<String> words) {
    const int longWordThreshold = 12;
    const double baseFontSize = 40.0;
    const double scaleFactor = 0.9;

    bool hasLongWord = words.any((word) => word.length > longWordThreshold);
    return TextStyle(
      fontSize: hasLongWord ? baseFontSize * scaleFactor : baseFontSize,
      height: 1.1,
      letterSpacing: 1.5,
      fontWeight: FontWeight.w600,
      fontFamily: 'Casta',
      color: const Color(0xFF2F2F2F),
    );
  }
}

class _RecipeTags extends StatelessWidget {
  final List<String> tags;

  const _RecipeTags({required this.tags});

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
          fontSize: 11,
          color: AppColors.white,
          fontFamily: 'Inter',
          letterSpacing: 0.2,
        ),
      ),
      backgroundColor: AppColors.mutedGreen,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}

class _RecipeGlanceCard extends StatelessWidget {
  final Recipe recipe;
  final Size size;

  const _RecipeGlanceCard({required this.recipe, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 1,
      height: size.height * 0.52,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.mutedGreen, width: 1),
        color: Colors.black.withOpacity(0.12),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'at a glance',
            style: TextStyle(
              fontSize: 34,
              color: AppColors.button,
              fontFamily: 'Casta',
            ),
          ),
          _GlanceDivider(width: size.width * 0.7),
          const SizedBox(height: 15),
          _GlanceInfoRow(recipe: recipe),
          const SizedBox(height: 15),
          _GlanceDetailsRow(recipe: recipe, size: size),
        ],
      ),
    );
  }
}

class _GlanceDivider extends StatelessWidget {
  final double width;

  const _GlanceDivider({required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF151414).withOpacity(0.5),
            const Color(0xFF151414).withOpacity(0.5),
          ],
        ),
      ),
    );
  }
}

class _GlanceInfoRow extends StatelessWidget {
  final Recipe recipe;

  const _GlanceInfoRow({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildGlanceItem(
            Icons.timer_outlined,
            'Est. ${recipe.cookingTime ?? "N/A"}',
          ),
          _buildGlanceItem(
            Icons.restaurant_menu_rounded,
            'Level: ${recipe.difficulty ?? "N/A"}',
          ),
          _buildGlanceItem(
            Icons.people_outline_rounded,
            'Serves: ${recipe.servings ?? "N/A"}',
          ),
        ],
      ),
    );
  }

  Widget _buildGlanceItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.button),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.button,
            fontWeight: FontWeight.w400,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }
}

class _GlanceDetailsRow extends StatelessWidget {
  final Recipe recipe;
  final Size size;

  const _GlanceDetailsRow({required this.recipe, required this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _IngredientsCard(recipe: recipe, size: size),
        NutritionCard(size: size),
      ],
    );
  }
}

class _IngredientsCard extends StatelessWidget {
  final Recipe recipe;
  final Size size;

  const _IngredientsCard({required this.recipe, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.52,
      height: size.height * 0.35,
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.white.withOpacity(0.7), width: 1),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Ingredients',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.button,
              fontFamily: 'Times New Roman',
            ),
          ),
          const SizedBox(height: 10),
          if (recipe.ingredients.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  recipe.ingredients
                      .map((ing) => _IngredientRow(ingredient: ing))
                      .toList(),
            )
          else
            const Text(
              '• No ingredients listed',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: AppColors.button,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  final RecipeIngredient ingredient;

  const _IngredientRow({required this.ingredient});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: size.width * 0.21,
          child: Text(
            '• ${ingredient.ingredient.name}',
            style: const TextStyle(
              color: AppColors.button,
              fontSize: 12,
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.w200,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(
          width: size.width * 0.2,
          child: Text(
            '${ingredient.quantity} ${ingredient.unit?.name ?? ""}',
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: AppColors.button,
              fontSize: 12,
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.end,
          ),
        ),
        const SizedBox(width: 10),
        Icon(
          ingredient.ingredient.id == ingredient.ingredient.id
              ? CupertinoIcons.checkmark_circle_fill
              : CupertinoIcons.checkmark_circle,
          size: 12,
          color:
              ingredient.ingredient.id == ingredient.ingredient.id
                  ? AppColors.mutedGreen
                  : AppColors.button,
        ),
      ],
    );
  }
}

class _SwipeIndicator extends StatelessWidget {
  const _SwipeIndicator();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 16,
      child: Column(
        children: [
          Icon(
            CupertinoIcons.chevron_up,
            size: 20,
            color: AppColors.mutedGreen.withOpacity(0.6),
          ),
          const SizedBox(height: 4),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.mutedGreen.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
