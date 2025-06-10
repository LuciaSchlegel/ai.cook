import 'package:ai_cook_project/models/category_model.dart';
import 'package:ai_cook_project/models/custom_ing_model.dart';
import 'package:ai_cook_project/models/tag_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/models/ingredient_model.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/models/unit.dart';
import 'package:ai_cook_project/providers/search_provider.dart';
import 'package:ai_cook_project/widgets/dropdown_selector.dart';
import 'package:provider/provider.dart';
import 'package:ai_cook_project/dialogs/ingredient_dialogs.dart';

class CupboardScreen extends StatefulWidget {
  const CupboardScreen({super.key});

  @override
  State<CupboardScreen> createState() => _CupboardScreenState();
}

class _CupboardScreenState extends State<CupboardScreen> {
  String _selectedCategory = 'All';
  String _selectedProperty = 'All';
  final TextEditingController _searchController = TextEditingController();

  // Main categories for dropdown
  final List<String> _mainCategories = [
    'All',
    'Fruits & Vegetables',
    'Meat',
    'Dairies',
    'Grains',
    'Spices',
    'Others',
  ];

  // Properties for filter chips
  final List<String> _properties = [
    'All',
    'Vegan',
    'Non-dairy',
    'Gluten-free',
    'High-protein',
    'Low-carb',
    'Low-fat',
  ];

  // Hardcoded ingredients for now
  final List<UserIng> _ingredients = [
    UserIng(
      id: 1,
      uid: '1',
      ingredient: Ingredient(
        id: 1,
        name: 'Tomatoes',
        category: Category(id: 1, name: 'Fruits & Vegetables'),
        tags: [Tag(id: 1, name: 'Vegan'), Tag(id: 2, name: 'Low-carb')],
      ),
      quantity: 1,
      unit: Unit.kg,
    ),
    UserIng(
      id: 2,
      uid: '1',
      ingredient: Ingredient(
        id: 2,
        name: 'Chicken',
        category: Category(id: 2, name: 'Meat'),
        tags: [Tag(id: 3, name: 'Low-fat'), Tag(id: 4, name: 'High-protein')],
      ),
      quantity: 1,
      unit: Unit.kg,
    ),
    UserIng(
      id: 3,
      uid: '1',
      customIngredient: CustomIngredient(
        id: 3,
        name: 'Onions',
        category: Category(id: 1, name: 'Fruits & Vegetables'),
        tags: [Tag(id: 5, name: 'Healthy')],
      ),
      quantity: 500,
      unit: Unit.g,
    ),
    UserIng(
      id: 4,
      uid: '1',
      ingredient: Ingredient(
        id: 4,
        name: 'Milk',
        category: Category(id: 3, name: 'Dairies'),
        tags: [Tag(id: 6, name: 'Healthy')],
      ),
      quantity: 500,
      unit: Unit.ml,
    ),
    UserIng(
      id: 5,
      uid: '1',
      ingredient: Ingredient(
        id: 5,
        name: 'Eggs',
        category: Category(id: 3, name: 'Dairies'),
        tags: [Tag(id: 7, name: 'High-protein')],
      ),
      quantity: 12,
      unit: Unit.u,
    ),
    UserIng(
      id: 6,
      uid: '1',
      ingredient: Ingredient(
        id: 6,
        name: 'Whole-grain Rice',
        category: Category(id: 4, name: 'Grains'),
        tags: [Tag(id: 8, name: 'Gluten-free'), Tag(id: 9, name: 'Low-carb')],
      ),
      quantity: 1,
      unit: Unit.u,
    ),
    UserIng(
      id: 7,
      uid: '1',
      ingredient: Ingredient(
        id: 7,
        name: 'Ginger',
        category: Category(id: 5, name: 'Spices'),
        tags: [Tag(id: 10, name: 'Healthy')],
      ),
      quantity: 100,
      unit: Unit.g,
    ),
  ];

  // User's ingredients with quantities
  final Map<int, UserIng> _userIngredients = {};

  List<UserIng> get _filteredIngredients {
    final searchProvider = Provider.of<SearchProvider>(context);
    return _ingredients.where((ingredient) {
      final matchesCategory =
          _selectedCategory == 'All' ||
          ingredient.ingredient?.category?.name == _selectedCategory;
      final matchesProperty =
          _selectedProperty == 'All' ||
          (ingredient.ingredient?.tags?.any(
                (tag) =>
                    tag.name.toLowerCase() == _selectedProperty.toLowerCase(),
              ) ??
              false);
      final matchesSearch =
          ingredient.ingredient?.name.toLowerCase().contains(
            searchProvider.searchController.text.toLowerCase(),
          ) ??
          false;
      return matchesCategory && matchesProperty && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showIngredientDialog([UserIng? userIng]) {
    IngredientDialogs.showIngredientDialog(
      context: context,
      categories: _mainCategories,
      ingredients: _ingredients,
      userIngredients: _userIngredients,
      userIng: userIng,
      onDelete:
          userIng?.ingredient != null
              ? () {
                final ingredient = userIng!.ingredient!;
                IngredientDialogs.showDeleteDialog(
                  context: context,
                  ingredient: ingredient,
                  onDelete: () {
                    setState(() {
                      _ingredients.removeWhere((i) => i.id == ingredient.id);
                      _userIngredients.remove(ingredient.id);
                    });
                  },
                );
              }
              : null,
      onSave: (UserIng updatedUserIng) {
        setState(() {
          if (userIng == null) {
            _ingredients.add(updatedUserIng);
            _userIngredients[updatedUserIng.id] = updatedUserIng;
          } else {
            final index = _ingredients.indexWhere((i) => i.id == userIng.id);
            if (index != -1) {
              _ingredients[index] = updatedUserIng;
              _userIngredients[userIng.id] = updatedUserIng;
            }
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final horizontalPadding = screenWidth * 0.05;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Category Dropdown
            Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                0, // reduced top padding
                horizontalPadding,
                screenHeight * 0.02,
              ),
              child: DropdownSelector(
                value: _selectedCategory,
                items: _mainCategories,
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCategory = value);
                  }
                },
              ),
            ),
            // Property Chips
            Container(
              height: 50,
              margin: EdgeInsets.only(bottom: screenHeight * 0.02),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _properties.length,
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                itemBuilder: (context, index) {
                  final property = _properties[index];
                  final isSelected = property == _selectedProperty;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      label: Text(property),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() => _selectedProperty = property);
                      },
                      backgroundColor: CupertinoColors.systemGrey6,
                      selectedColor: AppColors.mutedGreen,
                      checkmarkColor: AppColors.white,
                      labelStyle: TextStyle(
                        color:
                            isSelected
                                ? AppColors.white
                                : AppColors.black.withOpacity(0.8),
                      ),
                      side: BorderSide(
                        color:
                            isSelected
                                ? AppColors.mutedGreen
                                : CupertinoColors.systemGrey6.resolveFrom(
                                  context,
                                ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Ingredients List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                itemCount: _filteredIngredients.length,
                itemBuilder: (context, index) {
                  final ingredient = _filteredIngredients[index];
                  final userIng = _userIngredients[ingredient.id];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: AppColors.mutedGreen,
                          width: 0.5,
                        ),
                      ),
                      color: CupertinoColors.systemGrey6,
                      child: InkWell(
                        onTap: () => _showIngredientDialog(ingredient),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  ingredient.ingredient?.name ??
                                      ingredient.customIngredient?.name ??
                                      '',
                                  style: const TextStyle(
                                    color: AppColors.button,
                                    fontFamily: 'Times New Roman',
                                    fontSize: 16,
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              if (userIng != null) ...[
                                const SizedBox(width: 8),
                                Text(
                                  '${userIng.quantity} ${userIng.unit}',
                                  style: TextStyle(
                                    color: AppColors.button,
                                    fontFamily: 'Times New Roman',
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        child: FloatingActionButton(
          onPressed: () => _showIngredientDialog(),
          backgroundColor: AppColors.button.withOpacity(0.6),
          elevation: 2,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: AppColors.white),
        ),
      ),
    );
  }
}
