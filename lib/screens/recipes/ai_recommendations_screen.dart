import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_cook_project/providers/ai_recommendations_provider.dart';
import 'package:ai_cook_project/providers/ingredients_provider.dart';
import 'package:ai_cook_project/utils/text_utils.dart';
import 'package:ai_cook_project/widgets/ai_recommendations/ai_recommendations_widget.dart';
import 'package:ai_cook_project/widgets/utils/screen_header.dart';
import 'package:ai_cook_project/theme.dart';

class AIRecommendationsScreen extends StatefulWidget {
  const AIRecommendationsScreen({super.key});

  @override
  State<AIRecommendationsScreen> createState() =>
      _AIRecommendationsScreenState();
}

class _AIRecommendationsScreenState extends State<AIRecommendationsScreen> {
  String? _userPreferences;
  String _selectedDifficulty = 'Cualquiera';
  int? _maxCookingTime;
  final List<String> _selectedTags = [];

  final List<String> _difficultyOptions = [
    'Cualquiera',
    'Fácil',
    'Medio',
    'Difícil',
  ];

  final List<String> _availableTags = [
    'Vegetariano',
    'Vegano',
    'Sin gluten',
    'Sin lactosa',
    'Alto en proteínas',
    'Bajo en carbohidratos',
    'Rápido',
    'Saludable',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              onProfileTap: () {},
              onFeedTap: () {},
              onLogoutTap: () {},
              currentIndex: 0,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🤖 Recomendaciones con IA',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Casta',
                        color: AppColors.button,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Obtén recomendaciones personalizadas basadas en tus ingredientes y preferencias.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),

                    // Sección de preferencias
                    _buildPreferencesSection(),
                    const SizedBox(height: 24),

                    // Botón para generar recomendaciones
                    _buildGenerateButton(),
                    const SizedBox(height: 24),

                    // Widget de recomendaciones
                    const AIRecommendationsWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferencesSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '⚙️ Preferencias',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Casta',
              ),
            ),
            const SizedBox(height: 16),

            // Dificultad
            const Text(
              'Dificultad:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedDifficulty,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items:
                  _difficultyOptions.map((difficulty) {
                    return DropdownMenuItem(
                      value: difficulty,
                      child: Text(difficulty),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDifficulty = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Tiempo máximo
            const Text(
              'Tiempo máximo (minutos):',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ej: 30 (dejar vacío para sin límite)',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _maxCookingTime = value.isEmpty ? null : int.tryParse(value);
                });
              },
            ),
            const SizedBox(height: 16),

            // Etiquetas preferidas
            const Text(
              'Etiquetas preferidas:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children:
                  _availableTags.map((tag) {
                    final isSelected = _selectedTags.contains(tag);
                    return FilterChip(
                      label: Text(TextUtils.capitalizeFirstLetter(tag)),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedTags.add(tag);
                          } else {
                            _selectedTags.remove(tag);
                          }
                        });
                      },
                    );
                  }).toList(),
            ),
            const SizedBox(height: 16),

            // Preferencias adicionales
            const Text(
              'Preferencias adicionales:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText:
                    'Ej: Me gustan las recetas picantes, prefiero cocinar para 2 personas...',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              maxLines: 3,
              onChanged: (value) {
                setState(() {
                  _userPreferences = value.isEmpty ? null : value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _generateRecommendations,
        icon: const Icon(Icons.auto_awesome),
        label: const Text(
          'Generar Recomendaciones con IA',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.button,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _generateRecommendations() {
    final ingredientsProvider = Provider.of<IngredientsProvider>(
      context,
      listen: false,
    );

    final aiProvider = Provider.of<AIRecommendationsProvider>(
      context,
      listen: false,
    );

    // Convertir dificultad
    String? difficulty;
    if (_selectedDifficulty != 'Cualquiera') {
      difficulty = _selectedDifficulty;
    }

    // Generar recomendaciones
    aiProvider.generateRecommendations(
      userIngredients: ingredientsProvider.userIngredients,
      preferredTags: _selectedTags,
      maxCookingTimeMinutes: _maxCookingTime,
      preferredDifficulty: difficulty,
      userPreferences: _userPreferences,
      numberOfRecipes: 10,
    );
  }
}
