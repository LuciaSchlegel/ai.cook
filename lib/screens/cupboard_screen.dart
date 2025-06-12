import 'package:ai_cook_project/dialogs/global_ing_dialog.dart';
import 'package:ai_cook_project/providers/resource_provider.dart';
import 'package:ai_cook_project/providers/ingredients_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/providers/search_provider.dart';
import 'package:ai_cook_project/widgets/dropdown_selector.dart';
import 'package:provider/provider.dart';
import 'package:ai_cook_project/dialogs/ingredient_dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CupboardScreen extends StatefulWidget {
  const CupboardScreen({super.key});

  @override
  State<CupboardScreen> createState() => _CupboardScreenState();
}

class _CupboardScreenState extends State<CupboardScreen> {
  String _selectedCategory = 'All';
  String _selectedProperty = 'All';
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  bool _hasShownOnboarding = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadResources();

      final ingredientsProvider = Provider.of<IngredientsProvider>(
        context,
        listen: false,
      );

      if (!_hasShownOnboarding && ingredientsProvider.userIngredients.isEmpty) {
        _hasShownOnboarding = true;
        await showGlobalIngredientsDialog(context);
      }
    });
  }

  Future<void> _loadResources() async {
    if (mounted) setState(() => _isLoading = true);
    try {
      final resourceProvider = Provider.of<ResourceProvider>(
        context,
        listen: false,
      );
      final ingredientsProvider = Provider.of<IngredientsProvider>(
        context,
        listen: false,
      );

      await Future.wait([
        resourceProvider.getCategories(),
        resourceProvider.getTags(),
        resourceProvider.getUnits(),
        ingredientsProvider.fetchUserIngredients(),
        ingredientsProvider.fetchIngredients(),
      ]);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<UserIng> _getFilteredIngredients(BuildContext context) {
    final ingredientsProvider = Provider.of<IngredientsProvider>(context);
    final searchProvider = Provider.of<SearchProvider>(context);
    final searchText = searchProvider.searchController.text.toLowerCase();

    return ingredientsProvider.userIngredients.where((userIng) {
      final ingredient = userIng.ingredient;
      if (ingredient == null) return false;

      final matchesCategory =
          _selectedCategory == 'All' ||
          ingredient.category?.name == _selectedCategory;

      final matchesProperty =
          _selectedProperty == 'All' ||
          (ingredient.tags?.any(
                (tag) =>
                    tag.name.toLowerCase() == _selectedProperty.toLowerCase(),
              ) ??
              false);

      final matchesSearch = ingredient.name.toLowerCase().contains(searchText);

      return matchesCategory && matchesProperty && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showIngredientDialog([UserIng? userIng]) {
    final resourceProvider = Provider.of<ResourceProvider>(
      context,
      listen: false,
    );
    final ingredientsProvider = Provider.of<IngredientsProvider>(
      context,
      listen: false,
    );

    IngredientDialogs.showIngredientDialog(
      context: context,
      categories: resourceProvider.categories,
      ingredients:
          ingredientsProvider.ingredients
              .map(
                (ing) => UserIng(
                  id: ing.id,
                  ingredient: ing,
                  quantity: 0,
                  unit: null,
                  uid: FirebaseAuth.instance.currentUser?.uid ?? '',
                ),
              )
              .toList(),
      userIngredients: {
        for (var ing in ingredientsProvider.userIngredients) ing.id: ing,
      },
      userIng: userIng,
      onDelete:
          userIng != null
              ? () {
                IngredientDialogs.showDeleteDialog(
                  context: context,
                  ingredient: userIng.ingredient!,
                  onDelete: () async {
                    await ingredientsProvider.removeUserIngredient(userIng);
                  },
                );
              }
              : null,
      onSave: (UserIng updatedUserIng) async {
        if (userIng == null) {
          await ingredientsProvider.addUserIngredient(updatedUserIng);
        } else {
          await ingredientsProvider.updateUserIngredient(updatedUserIng);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final horizontalPadding = screenWidth * 0.05;
    final resourceProvider = Provider.of<ResourceProvider>(context);

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final categories = [
      'All',
      ...resourceProvider.categories.map((c) => c.name),
    ];
    final tags = ['All', ...resourceProvider.tags.map((t) => t.name)];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Category Dropdown
            Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                0,
                horizontalPadding,
                screenHeight * 0.02,
              ),
              child: DropdownSelector(
                value: _selectedCategory,
                items: categories,
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
                itemCount: tags.length,
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                itemBuilder: (context, index) {
                  final property = tags[index];
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
              child: Consumer<IngredientsProvider>(
                builder: (context, ingredientsProvider, _) {
                  final filteredIngredients = _getFilteredIngredients(context);

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    itemCount: filteredIngredients.length,
                    itemBuilder: (context, index) {
                      final userIng = filteredIngredients[index];
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
                            onTap: () => _showIngredientDialog(userIng),
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
                                      userIng.ingredient?.name ??
                                          userIng.customIngredient?.name ??
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
                                  const SizedBox(width: 8),
                                  Text(
                                    '${userIng.quantity} ${userIng.unit}',
                                    style: const TextStyle(
                                      color: AppColors.button,
                                      fontFamily: 'Times New Roman',
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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
