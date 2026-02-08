import 'package:ai_cook_project/dialogs/ai_assistant/widgets/ai_loading_indicator.dart';
import 'package:ai_cook_project/models/recipe_model.dart';
import 'package:ai_cook_project/providers/recipes_provider.dart';
import 'package:ai_cook_project/services/diet_adapter_service.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DietAdapterView extends StatefulWidget {
  const DietAdapterView({super.key});

  @override
  State<DietAdapterView> createState() => _DietAdapterViewState();
}

class _DietAdapterViewState extends State<DietAdapterView> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  Recipe? _selectedRecipe;
  final Set<String> _selectedDiets = {};
  String _searchQuery = '';

  static const List<String> _dietaryOptions = [
    'Vegan',
    'Vegetarian',
    'Gluten-Free',
    'Dairy-Free',
    'Keto',
    'Low-Sodium',
    'Nut-Free',
    'Paleo',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _selectRecipe(Recipe recipe) {
    setState(() {
      _selectedRecipe = recipe;
      _searchQuery = '';
      _searchController.clear();
    });
    _searchFocusNode.unfocus();
  }

  void _clearRecipe() {
    setState(() {
      _selectedRecipe = null;
    });
  }

  void _toggleDiet(String diet) {
    setState(() {
      if (_selectedDiets.contains(diet)) {
        _selectedDiets.remove(diet);
      } else {
        _selectedDiets.add(diet);
      }
    });
  }

  void _onSubmit(DietAdapterService service) {
    if (_selectedRecipe != null && _selectedDiets.isNotEmpty) {
      _searchFocusNode.unfocus();

      final ingredientNames =
          _selectedRecipe!.ingredients.map((ri) => ri.ingredient.name).toList();

      service.adaptRecipe(
        recipeName: _selectedRecipe!.name,
        ingredients: ingredientNames,
        dietaryNeeds: _selectedDiets.toList(),
      );
    }
  }

  bool get _canSubmit => _selectedRecipe != null && _selectedDiets.isNotEmpty;

  List<Recipe> _getFilteredRecipes(List<Recipe> recipes) {
    if (_searchQuery.isEmpty) return recipes;
    final query = _searchQuery.toLowerCase();
    return recipes.where((r) => r.name.toLowerCase().contains(query)).toList();
  }

  Widget _buildSectionLabel(BuildContext context, String label) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
      ),
      child: Text(
        label,
        style: AppTextStyles.inter(
          fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.xs),
          fontWeight: AppFontWeights.semiBold,
          color: AppColors.button.withValues(alpha: 0.5),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DietAdapterService(),
      child: Consumer2<DietAdapterService, RecipesProvider>(
        builder: (context, service, recipesProvider, _) {
          final recipes = recipesProvider.recipes;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              _buildHeader(context),
              SizedBox(
                height: ResponsiveUtils.spacing(context, ResponsiveSpacing.lg),
              ),

              // Recipe selection
              _buildSectionLabel(context, 'Recipe'),
              _buildRecipeSelector(context, recipes),
              SizedBox(
                height: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
              ),

              // Dietary needs section (only show after recipe selected)
              if (_selectedRecipe != null) ...[
                _buildSectionLabel(context, 'Dietary needs'),
                _buildDietaryChips(context),
                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.lg,
                  ),
                ),

                // Submit background
                _buildSubmitbackground(context, service),
                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.lg,
                  ),
                ),
              ],

              // Results
              if (service.isLoading)
                _buildLoading(context)
              else if (service.error != null)
                _buildError(context, service.error!)
              else if (service.hasResult)
                _buildResults(context, service.result!),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(
            ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.background,
                AppColors.background.withValues(alpha: 0.85),
              ],
            ),
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.background.withValues(alpha: 0.15),
                blurRadius: ResponsiveUtils.spacing(
                  context,
                  ResponsiveSpacing.md,
                ),
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            CupertinoIcons.leaf_arrow_circlepath,
            color: Colors.white,
            size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.xl),
          ),
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
        ),
        ShaderMask(
          shaderCallback:
              (bounds) => LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.background,
                  AppColors.background.withValues(alpha: 0.7),
                  AppColors.background,
                ],
                stops: const [0.0, 0.5, 1.0],
              ).createShader(bounds),
          child: Text(
            'Diet Adapter',
            style: AppTextStyles.casta(
              fontSize:
                  ResponsiveUtils.fontSize(context, ResponsiveFontSize.title) *
                  1.2,
              fontWeight: AppFontWeights.bold,
              color: AppColors.white,
              letterSpacing: 0.8,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
        ),
        Text(
          'Transform any recipe to fit your dietary needs',
          style: AppTextStyles.inter(
            fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.sm),
            fontWeight: AppFontWeights.regular,
            color: AppColors.button.withValues(alpha: 0.6),
            letterSpacing: 0.2,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRecipeSelector(BuildContext context, List<Recipe> recipes) {
    if (_selectedRecipe != null) {
      return _buildSelectedRecipeCard(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search field
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
            ),
            border: Border.all(
              color: AppColors.background.withValues(alpha: 0.12),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.background.withValues(alpha: 0.04),
                blurRadius: ResponsiveUtils.spacing(
                  context,
                  ResponsiveSpacing.sm,
                ),
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            style: AppTextStyles.inter(
              fontSize: ResponsiveUtils.fontSize(
                context,
                ResponsiveFontSize.md,
              ),
              fontWeight: AppFontWeights.regular,
              color: AppColors.button,
            ),
            decoration: InputDecoration(
              hintText: 'Search your recipes...',
              hintStyle: AppTextStyles.inter(
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  ResponsiveFontSize.sm,
                ),
                fontWeight: AppFontWeights.regular,
                color: AppColors.background.withValues(alpha: 0.4),
              ),
              prefixIcon: Icon(
                CupertinoIcons.search,
                color: AppColors.background.withValues(alpha: 0.4),
                size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.sm),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.spacing(
                  context,
                  ResponsiveSpacing.md,
                ),
                vertical: ResponsiveUtils.spacing(
                  context,
                  ResponsiveSpacing.md,
                ),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
        ),

        // Recipe list
        if (recipes.isEmpty)
          _buildEmptyRecipes(context)
        else
          _buildRecipeList(context, _getFilteredRecipes(recipes)),
      ],
    );
  }

  Widget _buildEmptyRecipes(BuildContext context) {
    return Container(
      padding: ResponsiveUtils.padding(context, ResponsiveSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
        ),
        border: Border.all(
          color: AppColors.background.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            CupertinoIcons.doc_text,
            size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.xl),
            color: AppColors.background.withValues(alpha: 0.3),
          ),
          SizedBox(
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          ),
          Text(
            'No recipes yet',
            style: AppTextStyles.inter(
              fontSize: ResponsiveUtils.fontSize(
                context,
                ResponsiveFontSize.md,
              ),
              fontWeight: AppFontWeights.medium,
              color: AppColors.background.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
          ),
          Text(
            'Add recipes to your collection to adapt them',
            style: AppTextStyles.inter(
              fontSize: ResponsiveUtils.fontSize(
                context,
                ResponsiveFontSize.sm,
              ),
              fontWeight: AppFontWeights.regular,
              color: AppColors.background.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeList(BuildContext context, List<Recipe> recipes) {
    if (recipes.isEmpty && _searchQuery.isNotEmpty) {
      return Container(
        padding: ResponsiveUtils.padding(context, ResponsiveSpacing.md),
        child: Text(
          'No recipes match "$_searchQuery"',
          style: AppTextStyles.inter(
            fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.sm),
            fontWeight: AppFontWeights.regular,
            color: AppColors.background.withValues(alpha: 0.5),
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: ResponsiveUtils.spacing(context, ResponsiveSpacing.xxl) * 4,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: recipes.length > 5 ? 5 : recipes.length,
        separatorBuilder:
            (context, index) => SizedBox(
              height: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
            ),
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return _buildRecipeItem(context, recipe);
        },
      ),
    );
  }

  Widget _buildRecipeItem(BuildContext context, Recipe recipe) {
    return GestureDetector(
      onTap: () => _selectRecipe(recipe),
      child: Container(
        padding: ResponsiveUtils.padding(context, ResponsiveSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.md),
          ),
          border: Border.all(
            color: AppColors.background.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: ResponsiveUtils.iconSize(context, ResponsiveIconSize.xl),
              height: ResponsiveUtils.iconSize(context, ResponsiveIconSize.xl),
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.borderRadius(
                    context,
                    ResponsiveBorderRadius.sm,
                  ),
                ),
              ),
              child:
                  recipe.image != null && recipe.image!.isNotEmpty
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.borderRadius(
                            context,
                            ResponsiveBorderRadius.sm,
                          ),
                        ),
                        child: Image.network(
                          recipe.image!,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Icon(
                                CupertinoIcons.doc_text,
                                color: AppColors.background.withValues(
                                  alpha: 0.3,
                                ),
                                size: ResponsiveUtils.iconSize(
                                  context,
                                  ResponsiveIconSize.md,
                                ),
                              ),
                        ),
                      )
                      : Icon(
                        CupertinoIcons.doc_text,
                        color: AppColors.background.withValues(alpha: 0.3),
                        size: ResponsiveUtils.iconSize(
                          context,
                          ResponsiveIconSize.md,
                        ),
                      ),
            ),
            SizedBox(
              width: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: AppTextStyles.inter(
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        ResponsiveFontSize.md,
                      ),
                      fontWeight: AppFontWeights.medium,
                      color: AppColors.background,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${recipe.ingredients.length} ingredients',
                    style: AppTextStyles.inter(
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        ResponsiveFontSize.xs,
                      ),
                      fontWeight: AppFontWeights.regular,
                      color: AppColors.background.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              CupertinoIcons.chevron_right,
              color: AppColors.background.withValues(alpha: 0.3),
              size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.sm),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedRecipeCard(BuildContext context) {
    final recipe = _selectedRecipe!;
    return Container(
      padding: ResponsiveUtils.padding(context, ResponsiveSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
        ),
        border: Border.all(
          color: AppColors.background.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                CupertinoIcons.checkmark_circle_fill,
                color: AppColors.background,
                size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.md),
              ),
              SizedBox(
                width: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
              ),
              Expanded(
                child: Text(
                  recipe.name,
                  style: AppTextStyles.casta(
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.lg,
                    ),
                    fontWeight: AppFontWeights.bold,
                    color: AppColors.background,
                  ),
                ),
              ),
              GestureDetector(
                onTap: _clearRecipe,
                child: Container(
                  padding: EdgeInsets.all(
                    ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.borderRadius(
                        context,
                        ResponsiveBorderRadius.sm,
                      ),
                    ),
                  ),
                  child: Icon(
                    CupertinoIcons.xmark,
                    color: AppColors.background.withValues(alpha: 0.6),
                    size: ResponsiveUtils.iconSize(
                      context,
                      ResponsiveIconSize.sm,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          ),
          Wrap(
            spacing: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
            runSpacing: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
            children:
                recipe.ingredients.take(6).map((ri) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.spacing(
                        context,
                        ResponsiveSpacing.sm,
                      ),
                      vertical:
                          ResponsiveUtils.spacing(
                            context,
                            ResponsiveSpacing.xs,
                          ) /
                          2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.borderRadius(
                          context,
                          ResponsiveBorderRadius.sm,
                        ),
                      ),
                    ),
                    child: Text(
                      ri.ingredient.name,
                      style: AppTextStyles.inter(
                        fontSize: ResponsiveUtils.fontSize(
                          context,
                          ResponsiveFontSize.xs,
                        ),
                        fontWeight: AppFontWeights.medium,
                        color: AppColors.background.withValues(alpha: 0.7),
                      ),
                    ),
                  );
                }).toList(),
          ),
          if (recipe.ingredients.length > 6)
            Padding(
              padding: EdgeInsets.only(
                top: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
              ),
              child: Text(
                '+${recipe.ingredients.length - 6} more',
                style: AppTextStyles.inter(
                  fontSize: ResponsiveUtils.fontSize(
                    context,
                    ResponsiveFontSize.xs,
                  ),
                  fontWeight: AppFontWeights.regular,
                  color: AppColors.background.withValues(alpha: 0.5),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDietaryChips(BuildContext context) {
    return Wrap(
      spacing: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
      runSpacing: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
      children:
          _dietaryOptions.map((diet) => _buildDietChip(context, diet)).toList(),
    );
  }

  Widget _buildDietChip(BuildContext context, String diet) {
    final isSelected = _selectedDiets.contains(diet);
    return GestureDetector(
      onTap: () => _toggleDiet(diet),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
          vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
        ),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.background
                  : AppColors.background.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
          ),
          border: Border.all(
            color:
                isSelected
                    ? AppColors.background
                    : AppColors.background.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              Icon(
                CupertinoIcons.checkmark,
                size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.xs),
                color: AppColors.white,
              ),
              SizedBox(
                width: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
              ),
            ],
            Text(
              diet,
              style: AppTextStyles.inter(
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  ResponsiveFontSize.sm,
                ),
                fontWeight: AppFontWeights.medium,
                color:
                    isSelected
                        ? AppColors.white
                        : AppColors.background.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitbackground(
    BuildContext context,
    DietAdapterService service,
  ) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color:
            _canSubmit
                ? AppColors.background
                : AppColors.background.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
        ),
        child: InkWell(
          onTap:
              _canSubmit && !service.isLoading
                  ? () => _onSubmit(service)
                  : null,
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.sparkles,
                  color: AppColors.white,
                  size: ResponsiveUtils.iconSize(
                    context,
                    ResponsiveIconSize.md,
                  ),
                ),
                SizedBox(
                  width: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
                ),
                Text(
                  'Adapt Recipe',
                  style: AppTextStyles.inter(
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.md,
                    ),
                    fontWeight: AppFontWeights.semiBold,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return const AILoadingIndicator(
      message: 'Adapting recipe',
      accentColor: AppColors.background,
    );
  }

  Widget _buildError(BuildContext context, String error) {
    return Container(
      padding: ResponsiveUtils.padding(context, ResponsiveSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
        ),
        border: Border.all(
          color: AppColors.background.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            CupertinoIcons.exclamationmark_circle,
            color: AppColors.background.withValues(alpha: 0.6),
            size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.md),
          ),
          SizedBox(
            width: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          ),
          Expanded(
            child: Text(
              error,
              style: AppTextStyles.inter(
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  ResponsiveFontSize.sm,
                ),
                fontWeight: AppFontWeights.medium,
                color: AppColors.background.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(BuildContext context, DietAdaptationResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(context, 'Adaptations for ${result.originalRecipe}'),
        SizedBox(
          height: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
        ),
        Text(
          result.dietaryNeeds.join(' · '),
          style: AppTextStyles.inter(
            fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.xs),
            fontWeight: AppFontWeights.medium,
            color: AppColors.background.withValues(alpha: 0.5),
          ),
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
        ),

        // Modifications list
        ...result.modifications.map(
          (mod) => _buildModificationCard(context, mod),
        ),

        // Tips section
        if (result.tips.isNotEmpty) ...[
          SizedBox(
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          ),
          Container(
            padding: ResponsiveUtils.padding(context, ResponsiveSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.lightYellow.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.borderRadius(
                  context,
                  ResponsiveBorderRadius.md,
                ),
              ),
              border: Border.all(
                color: AppColors.orange.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  CupertinoIcons.lightbulb_fill,
                  color: AppColors.orange,
                  size: ResponsiveUtils.iconSize(
                    context,
                    ResponsiveIconSize.sm,
                  ),
                ),
                SizedBox(
                  width: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
                ),
                Expanded(
                  child: Text(
                    result.tips,
                    style: AppTextStyles.inter(
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        ResponsiveFontSize.sm,
                      ),
                      fontWeight: AppFontWeights.regular,
                      color: AppColors.background.withValues(alpha: 0.8),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildModificationCard(
    BuildContext context,
    IngredientModification mod,
  ) {
    return Container(
      margin: EdgeInsets.only(
        bottom: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
      ),
      padding: ResponsiveUtils.padding(context, ResponsiveSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.lg),
        ),
        border: Border.all(
          color: AppColors.background.withValues(alpha: 0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.background.withValues(alpha: 0.03),
            blurRadius: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.spacing(
                      context,
                      ResponsiveSpacing.sm,
                    ),
                    vertical: ResponsiveUtils.spacing(
                      context,
                      ResponsiveSpacing.xs,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.borderRadius(
                        context,
                        ResponsiveBorderRadius.sm,
                      ),
                    ),
                  ),
                  child: Text(
                    mod.original,
                    style: AppTextStyles.inter(
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        ResponsiveFontSize.sm,
                      ),
                      fontWeight: AppFontWeights.medium,
                      color: AppColors.background.withValues(alpha: 0.7),
                      decoration: TextDecoration.lineThrough,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.sm,
                  ),
                ),
                child: Icon(
                  CupertinoIcons.arrow_right,
                  color: AppColors.background.withValues(alpha: 0.4),
                  size: ResponsiveUtils.iconSize(
                    context,
                    ResponsiveIconSize.sm,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.spacing(
                      context,
                      ResponsiveSpacing.sm,
                    ),
                    vertical: ResponsiveUtils.spacing(
                      context,
                      ResponsiveSpacing.xs,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.borderRadius(
                        context,
                        ResponsiveBorderRadius.sm,
                      ),
                    ),
                  ),
                  child: Text(
                    mod.replacement,
                    style: AppTextStyles.inter(
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        ResponsiveFontSize.sm,
                      ),
                      fontWeight: AppFontWeights.semiBold,
                      color: AppColors.background.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          if (mod.notes.isNotEmpty) ...[
            SizedBox(
              height: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            ),
            Text(
              mod.notes,
              style: AppTextStyles.inter(
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  ResponsiveFontSize.sm,
                ),
                fontWeight: AppFontWeights.regular,
                color: AppColors.background.withValues(alpha: 0.7),
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
