import 'package:ai_cook_project/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/recipe_model.dart';
import 'nutrition_card.dart';

class RecipeOverviewCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onExpand;

  const RecipeOverviewCard({
    super.key,
    required this.recipe,
    required this.onExpand,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: size.height * 0.04,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            clipBehavior: Clip.antiAlias,
            color: CupertinoColors.white,
            child: SizedBox(
              height: size.height * 0.85,
              width: size.width * 0.88,
              child: Stack(
                children: [
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                recipe.imageUrl ?? '',
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                                // Error Builder
                                errorBuilder:
                                    (context, error, stackTrace) => const Icon(
                                      CupertinoIcons.photo,
                                      size: 100,
                                      color: AppColors.button,
                                    ),
                                // Loading Builder
                                loadingBuilder: (
                                  context,
                                  child,
                                  loadingProgress,
                                ) {
                                  if (loadingProgress == null) return child;
                                  return const Center(
                                    child: CupertinoActivityIndicator(),
                                  );
                                },
                              ),
                            ),
                            Text(
                              recipe.name,
                              style: const TextStyle(
                                fontSize: 24,
                                letterSpacing: -0.5,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Times New Roman',
                                color: AppColors.button,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: size.width * 1,
                          height: size.height * 0.5,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.mutedGreen,
                              width: 1,
                            ),
                            color: Colors.black.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                textAlign: TextAlign.center,
                                'at a glance',
                                style: TextStyle(
                                  fontSize: 34,
                                  color: AppColors.button,
                                  fontFamily: 'Casta',
                                ),
                              ),
                              Container(
                                width: size.width * 0.7,
                                height: 1,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(
                                        255,
                                        21,
                                        20,
                                        20,
                                      ).withOpacity(0.5),
                                      Color.fromARGB(
                                        255,
                                        21,
                                        20,
                                        20,
                                      ).withOpacity(0.5),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              // Recipe Info Row
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 8,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                              ),
                              const SizedBox(height: 15),
                              // ingredients card
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: size.width * 0.52,
                                    height: size.height * 0.32,
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.systemGrey6,
                                      borderRadius: BorderRadius.circular(13),
                                      border: Border.all(
                                        color: AppColors.white.withOpacity(0.7),
                                        width: 1,
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 10,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children:
                                                recipe.ingredients
                                                    .map(
                                                      (ing) => Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          // Primera columna - Nombre del ingrediente
                                                          SizedBox(
                                                            width:
                                                                size.width *
                                                                0.21,
                                                            child: Text(
                                                              '• ${ing.ingredient.name}',
                                                              style: const TextStyle(
                                                                color:
                                                                    AppColors
                                                                        .button,
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    'Times New Roman',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w200,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          // Segunda columna - Cantidad y unidad
                                                          SizedBox(
                                                            width:
                                                                size.width *
                                                                0.2,
                                                            child: Text(
                                                              '${ing.quantity} ${ing.unit?.name ?? ""}',
                                                              style: const TextStyle(
                                                                color:
                                                                    AppColors
                                                                        .button,
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    'Times New Roman',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w200,
                                                              ),
                                                              textAlign:
                                                                  TextAlign.end,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          // Tercera columna - Icono
                                                          Icon(
                                                            ing.ingredient.id ==
                                                                    ing
                                                                        .ingredient
                                                                        .id
                                                                ? CupertinoIcons
                                                                    .checkmark_circle_fill
                                                                : CupertinoIcons
                                                                    .checkmark_circle,
                                                            size: 12,
                                                            color:
                                                                ing.ingredient.id ==
                                                                        ing
                                                                            .ingredient
                                                                            .id
                                                                    ? AppColors
                                                                        .mutedGreen
                                                                    : AppColors
                                                                        .button,
                                                          ),
                                                        ],
                                                      ),
                                                    )
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
                                  ),
                                  NutritionCard(size: size),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
