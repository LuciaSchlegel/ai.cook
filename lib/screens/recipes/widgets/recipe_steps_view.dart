import 'package:flutter/material.dart';
import '../../../models/recipe_model.dart';
import '../../../theme.dart';

class RecipeStepsView extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onClose;

  const RecipeStepsView({
    super.key,
    required this.recipe,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                recipe.image != null
                    ? Image.network(
                      recipe.image!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                    : Container(
                      height: 200,
                      color: AppColors.mutedGreen.withOpacity(0.2),
                    ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: AppColors.button),
                    onPressed: onClose,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                recipe.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Casta',
                  color: AppColors.button,
                ),
              ),
            ),
            const Divider(color: AppColors.mutedGreen, thickness: 1),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'steps...',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.mutedGreen,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      recipe.steps
                          .asMap()
                          .entries
                          .map(
                            (entry) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text(
                                '${entry.key + 1}. ${entry.value}',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 15,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
