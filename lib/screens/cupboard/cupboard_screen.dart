import 'package:ai_cook_project/dialogs/add_global_ing_dialog.dart';
import 'package:ai_cook_project/providers/resource_provider.dart';
import 'package:ai_cook_project/providers/ingredients_provider.dart';
import 'package:ai_cook_project/screens/cupboard/logic/ingredient_dialog.dart';
import 'package:ai_cook_project/screens/cupboard/logic/ingredients_filter.dart';
import 'package:ai_cook_project/screens/cupboard/services/onboarding.dart';
import 'package:ai_cook_project/screens/cupboard/widgets/empty_ing_list.dart';
import 'package:ai_cook_project/screens/cupboard/widgets/ing_list.dart';
import 'package:ai_cook_project/widgets/floating_add_button.dart';
import 'package:ai_cook_project/widgets/grey_card_chips.dart';
import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/providers/search_provider.dart';
import 'package:ai_cook_project/widgets/dropdown_selector.dart';
import 'package:ai_cook_project/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';

class CupboardScreen extends StatefulWidget {
  const CupboardScreen({super.key});

  @override
  State<CupboardScreen> createState() => _CupboardScreenState();
}

class _CupboardScreenState extends State<CupboardScreen> {
  String _selectedCategory = 'All';
  String _selectedProperty = 'All';
  bool _hasShownOnboarding = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final wasShown = await handleOnboarding(
        context: context,
        hasShownOnboarding: _hasShownOnboarding,
      );
      if (mounted) {
        setState(() {
          _hasShownOnboarding = wasShown;
        });
      }
    });
  }

  void _showIngredientDialog([UserIng? userIng]) async {
    await showIngredientDialog(
      context: context,
      userIng: userIng,
      onChanged: () {
        if (mounted) setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final horizontalPadding = screenWidth * 0.05;
    final resourceProvider = Provider.of<ResourceProvider>(context);
    void _openAddIngredientDialog() {
      addGlobalIngredientsDialog(context);
    }

    final categories = [
      'All',
      ...resourceProvider.categories.map((c) => c.name),
    ];
    final tags = ['All', ...resourceProvider.tags.map((t) => t.name)];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            SizedBox(height: 16),
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
            GreyCardChips(
              items: tags,
              selectedItem: _selectedProperty,
              onSelected: (value) {
                setState(() {
                  _selectedProperty = value;
                });
              },
              horizontalPadding: horizontalPadding,
              verticalSpacing: screenHeight * 0.02,
            ), // Ingredients List
            Expanded(
              child: Consumer<IngredientsProvider>(
                builder: (context, ingredientsProvider, _) {
                  if (!ingredientsProvider.isInitialized) {
                    return const LoadingIndicator(
                      size: 24.0,
                      message: 'Loading ingredients...',
                    );
                  }

                  final filteredIngredients = filterUserIngredients(
                    allIngredients: ingredientsProvider.userIngredients,
                    selectedCategory: _selectedCategory,
                    selectedProperty: _selectedProperty,
                    searchText:
                        Provider.of<SearchProvider>(
                          context,
                        ).searchController.text,
                  );

                  return filteredIngredients.isEmpty
                      ? const EmptyIngredientListMessage()
                      : IngredientListView(
                        ingredients: filteredIngredients,
                        horizontalPadding: horizontalPadding,
                        onTap: _showIngredientDialog,
                      );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingAddButton(
        onPressed: _openAddIngredientDialog,
      ),
    );
  }
}
