import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_cook_project/providers/ai_recommendations_provider.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/widgets/status/loading_indicator.dart';

class AIRecommendationsWidget extends StatelessWidget {
  final VoidCallback? onRecipeTap;

  const AIRecommendationsWidget({super.key, this.onRecipeTap});

  @override
  Widget build(BuildContext context) {
    return Consumer<AIRecommendationsProvider>(
      builder: (context, aiProvider, child) {
        if (aiProvider.isLoading) {
          return _buildLoadingCard();
        }

        if (aiProvider.error != null) {
          return _buildErrorCard(context, aiProvider.error!);
        }

        if (aiProvider.currentRecommendation == null) {
          return _buildEmptyCard(context);
        }

        return _buildRecommendationsCard(
          context,
          aiProvider.currentRecommendation!,
        );
      },
    );
  }

  Widget _buildLoadingCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.psychology, color: AppColors.button, size: 24),
                const SizedBox(width: 12),
                const Text(
                  '🤖 IA Generando Recomendaciones...',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Casta',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const LoadingIndicator(),
            const SizedBox(height: 8),
            const Text(
              'Analizando tus ingredientes y preferencias...',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, String error) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 24),
                const SizedBox(width: 12),
                const Text(
                  '❌ Error en IA',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Casta',
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(error, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // Aquí podrías agregar lógica para reintentar
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.psychology, color: AppColors.button, size: 24),
                const SizedBox(width: 12),
                const Text(
                  '🤖 Recomendaciones con IA',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Casta',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Obtén recomendaciones personalizadas basadas en tus ingredientes y preferencias.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                // Aquí podrías agregar lógica para generar recomendaciones
              },
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Generar Recomendaciones'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.button,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsCard(
    BuildContext context,
    AIRecommendation recommendation,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology, color: AppColors.button, size: 24),
                const SizedBox(width: 12),
                const Text(
                  '🤖 Recomendaciones IA',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Casta',
                  ),
                ),
                const Spacer(),
                if (recommendation.processingTime != null)
                  Text(
                    '${recommendation.processingTime}ms',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.button.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recommendation.recommendations,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Analizadas ${recommendation.totalRecipesConsidered} recetas, enviadas ${recommendation.filteredRecipes.length} a la IA',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            if (recommendation.filteredRecipes.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                '📖 Recetas Consideradas:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Casta',
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recommendation.filteredRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recommendation.filteredRecipes[index];
                    return Container(
                      width: 120,
                      margin: const EdgeInsets.only(right: 8),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recipe['name'] ?? 'Sin nombre',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                recipe['cookingTime'] ?? 'Sin tiempo',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
