import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/models/ingredient_model.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/widgets/ingredient_form_dialog.dart';
import 'package:ai_cook_project/providers/search_provider.dart';
import 'package:provider/provider.dart';

class CupboardScreen extends StatefulWidget {
  const CupboardScreen({super.key});

  @override
  State<CupboardScreen> createState() => _CupboardScreenState();
}

class _CupboardScreenState extends State<CupboardScreen> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  // Hardcoded categories for now
  final List<String> _categories = [
    'All',
    'Vegetables',
    'Fruits',
    'Meat',
    'Dairy',
    'Grains',
    'Spices',
    'Others',
  ];

  // Hardcoded ingredients for now
  final List<Ingredient> _ingredients = [
    Ingredient(
      id: 1,
      name: 'Tomato',
      category: 'Vegetables',
      tags: ['red', 'fresh'],
      recipes: [],
    ),
    Ingredient(
      id: 2,
      name: 'Apple',
      category: 'Fruits',
      tags: ['fresh', 'sweet'],
      recipes: [],
    ),
    Ingredient(
      id: 3,
      name: 'Chicken Breast',
      category: 'Meat',
      tags: ['protein', 'lean'],
      recipes: [],
    ),
    // Add more ingredients as needed
  ];

  // User's ingredients with quantities
  final Map<int, UserIng> _userIngredients = {};

  List<Ingredient> get _filteredIngredients {
    final searchProvider = Provider.of<SearchProvider>(context);
    return _ingredients.where((ingredient) {
      final matchesCategory =
          _selectedCategory == 'All' ||
          ingredient.category == _selectedCategory;
      final matchesSearch = ingredient.name.toLowerCase().contains(
        searchProvider.searchController.text.toLowerCase(),
      );
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showIngredientDialog([Ingredient? ingredient]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => IngredientFormDialog(
            ingredient: ingredient,
            categories: _categories,
            onSave: (name, category, tags, quantity, unit) {
              // For now, we'll just update the UI state
              // In a real app, this would be handled by a state management solution
              setState(() {
                if (ingredient == null) {
                  // Add new ingredient
                  final newId = _ingredients.length + 1;
                  final newIngredient = Ingredient(
                    id: newId,
                    name: name,
                    category: category,
                    tags: tags,
                    recipes: [],
                  );
                  _ingredients.add(newIngredient);
                  _userIngredients[newId] = UserIng(
                    id: newId,
                    userId: 1, // This would come from auth
                    ingredientId: newId,
                    quantity: quantity,
                    unit: unit,
                  );
                } else {
                  // Update existing ingredient
                  final index = _ingredients.indexWhere(
                    (i) => i.id == ingredient.id,
                  );
                  if (index != -1) {
                    _ingredients[index] = Ingredient(
                      id: ingredient.id,
                      name: name,
                      category: category,
                      tags: tags,
                      recipes: ingredient.recipes,
                    );
                    _userIngredients[ingredient.id] = UserIng(
                      id: ingredient.id,
                      userId: 1, // This would come from auth
                      ingredientId: ingredient.id,
                      quantity: quantity,
                      unit: unit,
                    );
                  }
                }
              });
            },
          ),
    );
  }

  void _deleteIngredient(Ingredient ingredient) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Ingredient'),
            content: Text(
              'Are you sure you want to delete ${ingredient.name}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _ingredients.removeWhere((i) => i.id == ingredient.id);
                    _userIngredients.remove(ingredient.id);
                  });
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              // Categories
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                  ),
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = category == _selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() => _selectedCategory = category);
                        },
                        backgroundColor: AppColors.white.withOpacity(0.1),
                        selectedColor: AppColors.orange,
                        checkmarkColor: AppColors.white,
                        labelStyle: TextStyle(
                          color:
                              isSelected
                                  ? AppColors.white
                                  : AppColors.white.withOpacity(0.7),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Ingredients Grid
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width * 0.05,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _filteredIngredients.length,
                  itemBuilder: (context, index) {
                    final ingredient = _filteredIngredients[index];
                    final userIng = _userIngredients[ingredient.id];
                    return Card(
                      color: AppColors.white.withOpacity(0.1),
                      child: InkWell(
                        onTap: () => _showIngredientDialog(ingredient),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ingredient.name,
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  if (userIng != null)
                                    Text(
                                      '${userIng.quantity} ${userIng.unit ?? 'units'}',
                                      style: TextStyle(
                                        color: AppColors.orange,
                                        fontSize: 14,
                                      ),
                                    ),
                                  Text(
                                    ingredient.category ?? 'Uncategorized',
                                    style: TextStyle(
                                      color: AppColors.white.withOpacity(0.7),
                                      fontSize: 12,
                                    ),
                                  ),
                                  if (ingredient.tags != null &&
                                      ingredient.tags!.isNotEmpty)
                                    Wrap(
                                      spacing: 4,
                                      children:
                                          ingredient.tags!
                                              .map(
                                                (tag) => Chip(
                                                  label: Text(
                                                    tag,
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                  backgroundColor: AppColors
                                                      .orange
                                                      .withOpacity(0.3),
                                                  labelStyle: TextStyle(
                                                    color: AppColors.white,
                                                  ),
                                                  padding: EdgeInsets.zero,
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                ),
                                              )
                                              .toList(),
                                    ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon: const Icon(Icons.delete_outline),
                                color: Colors.red.withOpacity(0.7),
                                onPressed: () => _deleteIngredient(ingredient),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 48,
        ),
        child: FloatingActionButton(
          onPressed: () => _showIngredientDialog(),
          backgroundColor: AppColors.orange,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
