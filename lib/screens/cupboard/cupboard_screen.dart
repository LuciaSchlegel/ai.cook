import 'package:ai_cook_project/dialogs/ingredients/global_ing/add/add_global_ing_dialog.dart';
import 'package:ai_cook_project/providers/resource_provider.dart';
import 'package:ai_cook_project/providers/ingredients_provider.dart';
import 'package:ai_cook_project/screens/cupboard/logic/ingredient_dialog.dart';
import 'package:ai_cook_project/screens/cupboard/logic/ingredients_filter.dart';
import 'package:ai_cook_project/screens/cupboard/services/onboarding.dart';
import 'package:ai_cook_project/screens/cupboard/widgets/empty_ing_list.dart';
import 'package:ai_cook_project/screens/cupboard/widgets/ing_list.dart';
import 'package:ai_cook_project/widgets/selectors/chips_dropd_card.dart';
import 'package:ai_cook_project/widgets/buttons/floating_add_button.dart';
import 'package:ai_cook_project/widgets/utils/screen_header.dart';
import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:ai_cook_project/providers/search_provider.dart';
import 'package:ai_cook_project/widgets/status/loading_indicator.dart';
import 'package:provider/provider.dart';

class CupboardScreen extends StatefulWidget {
  final bool isActive;
  final VoidCallback? onProfileTap;
  final VoidCallback? onFeedTap;
  final VoidCallback? onLogoutTap;

  const CupboardScreen({
    super.key,
    required this.isActive,
    this.onProfileTap,
    this.onFeedTap,
    this.onLogoutTap,
  });

  @override
  State<CupboardScreen> createState() => _CupboardScreenState();
}

class _CupboardScreenState extends State<CupboardScreen> {
  String _selectedCategory = 'All';
  List<String> _selectedProperties = [];
  bool _hasShownOnboarding = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_hasShownOnboarding) {
        final wasShown = await handleOnboarding(
          context: context,
          hasShownOnboarding: _hasShownOnboarding,
        );
        if (mounted) {
          setState(() {
            _hasShownOnboarding = wasShown;
          });
        }
      }
    });
  }

  void _showIngredientDialog([UserIng? userIng]) async {
    await showIngredientDialog(
      context: context,
      userIng: userIng,
      onChanged: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final resourceProvider = Provider.of<ResourceProvider>(context);
    final ingredientsProvider = Provider.of<IngredientsProvider>(context);
    void openAddIngredientDialog() {
      showDialog(context: context, builder: (_) => const AddGlobalIngDialog());
    }

    final categories = [
      'All',
      ...resourceProvider.categories.map((c) => c.name),
    ];
    final dietaryFlags = resourceProvider.getDietaryFlagsFromIngredients(
      ingredientsProvider.userIngredients,
    );

    ('🏠 CUPBOARD: Got ${dietaryFlags.length} dietary flags: $dietaryFlags',);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              onProfileTap: widget.onProfileTap ?? () {},
              onFeedTap: widget.onFeedTap ?? () {},
              onLogoutTap: widget.onLogoutTap ?? () {},
              currentIndex: 0,
            ),
            SizedBox(height: screenHeight * 0.03),
            ChipsDropdownCard(
              dropdownValue: _selectedCategory,
              dropdownItems: categories,
              onDropdownChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCategory = value);
                }
              },
              chipsItems: dietaryFlags,
              chipsSelectedItems: _selectedProperties,
              onChipsSelected: (selectedTags) {
                setState(() {
                  _selectedProperties = selectedTags;
                });
              },
            ),
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
                    selectedProperties: _selectedProperties,
                    searchText:
                        Provider.of<SearchProvider>(
                          context,
                        ).searchController.text,
                  );

                  return filteredIngredients.isEmpty
                      ? const EmptyIngredientListMessage()
                      : IngredientListView(
                        ingredients: filteredIngredients,
                        onTap: _showIngredientDialog,
                      );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingAddButton(
        onPressed: openAddIngredientDialog,
      ),
    );
  }
}
