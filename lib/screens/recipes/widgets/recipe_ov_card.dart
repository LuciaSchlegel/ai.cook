import 'package:ai_cook_project/dialogs/recipes/expanded_recipe_dialog.dart';
import 'package:ai_cook_project/providers/ingredients_provider.dart';
import 'package:ai_cook_project/screens/recipes/widgets/recipe_glance_card.dart';
import 'package:ai_cook_project/screens/recipes/widgets/recipe_header.dart';
import 'package:ai_cook_project/screens/recipes/widgets/recipe_tags.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/modal_utils.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';
import 'package:ai_cook_project/widgets/utils/swipe.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/recipe_model.dart';

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
    // Responsive drag threshold based on device type
    final deviceType = ResponsiveUtils.getDeviceType(context);
    final dragThreshold = switch (deviceType) {
      DeviceType.iPhone => 50.0,
      DeviceType.iPadMini => 60.0,
      DeviceType.iPadPro => 70.0,
    };

    if (details.primaryDelta! < 0) {
      if (_dragStart == 0) {
        _dragStart = details.globalPosition.dy;
      }
      if (_dragStart - details.globalPosition.dy > dragThreshold) {
        _showExpandedDialog();
      }
    } else if (details.primaryDelta! > 0) {
      if (_dragStart == 0) {
        _dragStart = details.globalPosition.dy;
      }
      if (details.globalPosition.dy - _dragStart > dragThreshold) {
        Navigator.pop(context);
      }
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    _dragStart = 0;
  }

  void _showExpandedDialog() {
    ModalUtils.showKeyboardAwareModalBottomSheet(
      context: context,
      transitionAnimationController: _animationController,
      child: RecipeExpandedDialog(recipe: widget.recipe),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        final size = MediaQuery.of(context).size;

        // Responsive card dimensions
        final cardHeight = switch (deviceType) {
          DeviceType.iPhone => size.height * 0.88,
          DeviceType.iPadMini => size.height * 0.80,
          DeviceType.iPadPro => size.height * 0.90,
        };

        final cardWidth = switch (deviceType) {
          DeviceType.iPhone => size.width * 0.88,
          DeviceType.iPadMini => size.width * 0.82,
          DeviceType.iPadPro => size.width * 0.80,
        };

        // Responsive elevation
        final elevation = switch (deviceType) {
          DeviceType.iPhone => 6.0,
          DeviceType.iPadMini => 8.0,
          DeviceType.iPadPro => 10.0,
        };

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
            vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.xl),
          ),
          child: GestureDetector(
            onVerticalDragUpdate: _handleDragUpdate,
            onVerticalDragEnd: _handleDragEnd,
            child: Card(
              elevation: elevation,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    ResponsiveUtils.borderRadius(
                      context,
                      ResponsiveBorderRadius.xxxl,
                    ),
                  ),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              color: AppColors.white,
              child: SizedBox(
                height: cardHeight,
                width: cardWidth,
                child: Stack(
                  children: [
                    Padding(
                      padding: ResponsiveUtils.padding(
                        context,
                        ResponsiveSpacing.lg,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ResponsiveSpacingWidget.vertical(
                            ResponsiveSpacing.sm,
                          ),
                          RecipeHeader(
                            recipe: widget.recipe,
                            onClose: () => Navigator.pop(context),
                          ),
                          ResponsiveSpacingWidget.vertical(
                            ResponsiveSpacing.sm,
                          ),
                          RecipeTags(
                            tags:
                                widget.recipe.tags
                                    .map((tag) => tag.name)
                                    .toList(),
                          ),
                          ResponsiveSpacingWidget.vertical(
                            ResponsiveSpacing.sm,
                          ),
                          Expanded(
                            child: Consumer<IngredientsProvider>(
                              builder: (context, ingredientsProvider, child) {
                                return RecipeGlanceCard(
                                  recipe: widget.recipe,
                                  size: size,
                                  userIngredients:
                                      ingredientsProvider.userIngredients,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SwipeIndicator(),
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
