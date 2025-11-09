// controllers/recipes-llm.controller.ts
import { Request, Response } from "express";
import { RecipeService } from "../services/recipe.service";
import { UserIngredientsService } from "../services/user_ingredients.service";
import { AIRecommendationRequestDto } from "../dtos/ai_recommendation.dto";
import { RecipeTagDto } from "../dtos/recipe_tag.dto";
import { RecipeIngredientDto } from "../dtos/recipe_ing.dto";
import { RecipeDto } from "../dtos/recipe.dto";
import { UserIngredientOptimizedDto } from "../dtos/user_ing_optimized.dto";
import { plainToInstance } from 'class-transformer';

export class RecipesLLMController {
  private recipeService = new RecipeService();
  private userIngredientsService = new UserIngredientsService();

  // Pre-compiled regex patterns for time parsing (matches iOS implementation)
  private static readonly TIME_REGEX_PATTERNS = [
    { regex: /(\d+)h(?:our)?(?:s)?(\d+)?m/i, hourIndex: 1, minuteIndex: 2 },
    { regex: /(\d+)m(?:in)?(?:s)?/i, hourIndex: -1, minuteIndex: 1 },
    { regex: /(\d+)h(?:our)?(?:s)?/i, hourIndex: 1, minuteIndex: -1 }
  ] as const;

  getRecipesForAI = async (req: Request, res: Response): Promise<void> => {
    try {
      const { uid } = req.params;

      if (!uid) {
        res.status(401).json({ error: 'Unauthorized' });
        return;
      }

      const requestDto: AIRecommendationRequestDto = req.body;

      console.log(`\n${'='.repeat(70)}`);
      console.log(`📱 Foundation Models Recipe Fetch (iOS-Optimized)`);
      console.log(`${'='.repeat(70)}`);
      console.log(`   User: ${uid}`);
      console.log(`   Scoring: iOS-aligned algorithm (0-170+ points)`);
      console.log(`   Output: Top 40 recipes for iOS final filtering`);
      console.log(`\n📊 Client Preferences:`);
      console.log(`   Tags: ${requestDto.preferredTags?.join(', ') || 'none'}`);
      console.log(`   Max time: ${requestDto.maxCookingTimeMinutes || 'unlimited'} min`);
      console.log(`   Difficulty: ${requestDto.preferredDifficulty || 'any'}`);
      console.log(`   Dietary: ${JSON.stringify(requestDto.dietaryRestrictions || {})}`);
      console.log(`${'='.repeat(70)}\n`);

      // Fetch all recipes
      const allRecipes = await this.recipeService.getRecipes() as RecipeDto[];
      console.log(`📊 Found ${allRecipes.length} total recipes`);

      // Get user ingredients and transform to DTO
      const userIngredientsEntities = await this.userIngredientsService.getUserIngredients(uid);
      const userIngredients = plainToInstance(
        UserIngredientOptimizedDto,
        userIngredientsEntities,
        {
          excludeExtraneousValues: true,
          enableImplicitConversion: true,
        }
      );
      
      console.log(`🥬 User has ${userIngredients?.length || 0} ingredients`);

      // Validate we have ingredients
      if (!userIngredients || userIngredients.length === 0) {
        res.status(400).json({
          error: 'NO_INGREDIENTS',
          message: 'Please add ingredients to your cupboard before generating recommendations',
        });
        return;
      }

      // Apply dietary restriction filters
      let filteredRecipes = this._applyDietaryFilters(
        allRecipes,
        requestDto.dietaryRestrictions
      );
      console.log(`✅ After dietary filters: ${filteredRecipes.length} recipes`);

      // Apply tag filtering (hard filter - if tags specified, recipe MUST have them)
      if (requestDto.preferredTags && requestDto.preferredTags.length > 0) {
        const beforeTagFilter = filteredRecipes.length;
        filteredRecipes = this._applyTagFilter(filteredRecipes, requestDto.preferredTags);
        console.log(`✅ After tag filter (${requestDto.preferredTags.join(', ')}): ${filteredRecipes.length} recipes (was ${beforeTagFilter})`);
      }

      // Apply time and difficulty hard filters (if specified)
      if (requestDto.maxCookingTimeMinutes || requestDto.preferredDifficulty) {
        const beforeConstraintFilter = filteredRecipes.length;
        filteredRecipes = this._applyConstraintFilters(
          filteredRecipes,
          requestDto.maxCookingTimeMinutes,
          requestDto.preferredDifficulty
        );
        console.log(`✅ After time/difficulty filter: ${filteredRecipes.length} recipes (was ${beforeConstraintFilter})`);
      }

      // Apply intelligent pre-filtering to reduce context size
      filteredRecipes = this._applyIntelligentFiltering(
        filteredRecipes,
        userIngredients,
        requestDto
      );
      console.log(`✅ After intelligent filtering: ${filteredRecipes.length} recipes (optimized for AI)`);

      // Transform to lightweight format for Foundation Models
      const recipesForAI = filteredRecipes.map((recipe: RecipeDto) => ({
        id: recipe.id,
        name: recipe.name,
        description: recipe.description || '',
        cookingTime: recipe.cookingTime || 'Not specified',
        difficulty: recipe.difficulty || 'Medium',
        servings: this._parseServings(recipe.servings),
        tags: recipe.tags?.map((t: RecipeTagDto) => t.name) || [],
        ingredients: recipe.ingredients
          .filter((ri: RecipeIngredientDto) => ri.ingredient)
          .map((ri: RecipeIngredientDto) => ({
            name: ri.ingredient!.name,
            quantity: this._parseQuantity(ri.quantity),
            unit: ri.unit?.abbreviation || 'unit',
          })),
      }));

      // Build user context
      const userContext = {
        availableIngredients: userIngredients
          .map((ui: UserIngredientOptimizedDto) => 
            ui.ingredient?.name || ui.customIngredient?.name || ''
          )
          .filter((name: string) => name && name.length > 0),
        preferences: {
          tags: requestDto.preferredTags || [],
          maxCookingTimeMinutes: requestDto.maxCookingTimeMinutes,
          preferredDifficulty: requestDto.preferredDifficulty,
          notes: requestDto.userPreferences,
          numberOfRecipes: requestDto.numberOfRecipes || 3,
        },
        dietaryRestrictions: requestDto.dietaryRestrictions || {
          isVegan: false,
          isVegetarian: false,
          isGlutenFree: false,
          isLactoseFree: false,
        },
      };

      // Log summary
      this._logResponseSummary(recipesForAI, userContext);

      // Return data
      res.status(200).json({
        recipes: recipesForAI,
        userContext,
        metadata: {
          totalRecipes: recipesForAI.length,
          totalUserIngredients: userContext.availableIngredients.length,
          timestamp: new Date().toISOString(),
          scoringVersion: 'ios-aligned-v3', // Indicates hard-filtering algorithm
          maxRecipesSent: 40, // iOS will filter to ~15
          backendOptimizations: [
            'Hard filters: dietary, tags, time, difficulty',
            'iOS-aligned scoring for ranking within filtered set',
            'Pre-compiled regex for time parsing',
            'Flexible ingredient unit matching'
          ]
        },
      });

    } catch (error) {
      console.error('❌ Error in getRecipesForAI:', error);
      res.status(500).json({
        error: 'Failed to fetch recipes for AI recommendations',
        message: error instanceof Error ? error.message : 'Unknown error',
      });
    }
  };

  /**
   * Intelligent filtering using iOS-aligned scoring algorithm
   * This prevents context window overflow in Foundation Models
   *
   * SCORING BREAKDOWN (matches iOS RecipesGenerator.swift):
   * - Ingredient match: 0-100 points (most important)
   * - Difficulty match: 0-20 points
   * - Time preference: 0-25 points (15 base + 10 bonus if well under limit)
   * - Tag matches: 10 points per matching tag
   * - Dietary compliance: 0-25 points per restriction
   * - Time penalty: -0.5 points per minute over limit
   *
   * Total possible: 170+ points (can exceed based on tags)
   */
  private _applyIntelligentFiltering(
    recipes: RecipeDto[],
    userIngredients: UserIngredientOptimizedDto[],
    requestDto: AIRecommendationRequestDto
  ): RecipeDto[] {

    // Create user ingredient and tag lookups
    const userIngredientNames = new Set(
      userIngredients.map(ui =>
        (ui.ingredient?.name || ui.customIngredient?.name || '').toLowerCase()
      )
    );

    const userTagSet = new Set(
      (requestDto.preferredTags || []).map(tag => tag.toLowerCase())
    );

    // Score each recipe using iOS-aligned algorithm
    const scoredRecipes = recipes.map(recipe => {
      let score = 0;

      // 1. Ingredient match score (MOST IMPORTANT - 0-100 points, matches iOS)
      const recipeIngredientCount = recipe.ingredients.filter(ri => ri.ingredient).length;
      const matchedIngredients = recipe.ingredients.filter(ri =>
        ri.ingredient && userIngredientNames.has(ri.ingredient.name.toLowerCase())
      ).length;

      if (recipeIngredientCount > 0) {
        const ingredientMatchRatio = matchedIngredients / recipeIngredientCount;
        score += ingredientMatchRatio * 100; // 0-100 points (matches iOS)
      }

      // 2. Cooking time preference (0-25 points for recipes within limit)
      // Note: Recipes are hard-filtered to be within maxCookingTimeMinutes
      // This scoring rewards faster recipes within that limit
      if (requestDto.maxCookingTimeMinutes) {
        const recipeMinutes = this._extractCookingTime(recipe.cookingTime || '');
        if (recipeMinutes > 0 && recipeMinutes <= requestDto.maxCookingTimeMinutes) {
          // Base bonus for being within limit
          score += 15;

          // Extra bonus for being well under the limit (faster is better)
          if (recipeMinutes <= requestDto.maxCookingTimeMinutes / 2) {
            score += 10;
          }
        }
      }

      // 3. Difficulty bonus (deprecated - now hard-filtered)
      // Kept for backward compatibility but doesn't differentiate when hard-filtering is active
      if (requestDto.preferredDifficulty) {
        if (recipe.difficulty?.toLowerCase() === requestDto.preferredDifficulty.toLowerCase()) {
          score += 20;
        }
      }

      // 4. Tag preference bonus (10 points per matching tag, matches iOS)
      const recipeTags = recipe.tags?.map(t => t.name.toLowerCase()) || [];
      const recipeTagSet = new Set(recipeTags);
      const matchingTags = Array.from(userTagSet).filter(tag =>
        recipeTagSet.has(tag)
      ).length;
      score += matchingTags * 10;

      // 5. Dietary restrictions compliance (0-25 points per restriction, matches iOS)
      if (requestDto.dietaryRestrictions) {
        const restrictions = requestDto.dietaryRestrictions;

        if (restrictions.isVegan) {
          const veganTags = ['vegan', 'plant-based'];
          const hasVeganTag = veganTags.some(tag => recipeTagSet.has(tag));
          if (hasVeganTag) {
            score += 25;
          } else if (recipeTagSet.has('vegetarian')) {
            score -= 10; // Vegetarian but not vegan (penalty, matches iOS)
          }
        } else if (restrictions.isVegetarian) {
          const vegTags = ['vegan', 'vegetarian', 'plant-based'];
          const hasVegTag = vegTags.some(tag => recipeTagSet.has(tag));
          if (hasVegTag) {
            score += 20;
          }
        }

        if (restrictions.isGlutenFree) {
          const glutenFreeTags = ['gluten-free', 'gluten free'];
          if (glutenFreeTags.some(tag => recipeTagSet.has(tag))) {
            score += 20;
          }
        }

        if (restrictions.isLactoseFree) {
          const lactoFreeTags = ['lactose-free', 'dairy-free', 'vegan'];
          if (lactoFreeTags.some(tag => recipeTagSet.has(tag))) {
            score += 20;
          }
        }
      }

      const missingIngredients = recipeIngredientCount - matchedIngredients;

      return {
        recipe,
        score,
        matchedIngredients,
        totalIngredients: recipeIngredientCount,
        missingIngredients,
      };
    });

    // Sort by score (highest first)
    scoredRecipes.sort((a, b) => b.score - a.score);

    // Enhanced logging with detailed score breakdown
    console.log('\n🎯 Top Recipe Candidates (iOS-aligned scoring):');
    scoredRecipes.slice(0, 10).forEach((item, idx) => {
      console.log(`   ${idx + 1}. ${item.recipe.name}`);
      console.log(`      Score: ${item.score.toFixed(1)} points`);
      console.log(`      Ingredients: ${item.matchedIngredients}/${item.totalIngredients} (${item.missingIngredients} missing)`);

      // Show which tags matched
      const recipeTags = item.recipe.tags?.map(t => t.name) || [];
      if (recipeTags.length > 0) {
        const matchedTags = recipeTags.filter(tag =>
          userTagSet.has(tag.toLowerCase())
        );
        if (matchedTags.length > 0) {
          console.log(`      Tags: ${matchedTags.join(', ')} ✓`);
        }
      }
    });
    console.log('');

    // Return top 30-40 recipes for iOS to do final filtering
    // This gives iOS more options while still being efficient
    const maxRecipes = 40;
    const topRecipes = scoredRecipes.slice(0, maxRecipes).map(item => item.recipe);

    console.log(`✅ Selected top ${topRecipes.length} recipes for iOS Foundation Models`);
    console.log(`   (iOS will perform final filtering to select best ~15 for AI)`);
    return topRecipes;
  }

  /**
   * Extract minutes from time string using iOS-compatible regex patterns
   * Handles formats: "30min", "1h30m", "1 hour 30 minutes", etc.
   */
  private _extractCookingTime(cookingTime: string): number {
    if (!cookingTime) return 0;

    const cleanedTime = cookingTime.toLowerCase().replace(/\s+/g, '');

    // Try each pattern in order (same as iOS)
    for (const pattern of RecipesLLMController.TIME_REGEX_PATTERNS) {
      const match = pattern.regex.exec(cleanedTime);
      if (match) {
        let totalMinutes = 0;

        // Extract hours if pattern has hour index
        if (pattern.hourIndex !== -1 && match[pattern.hourIndex]) {
          const hours = parseInt(match[pattern.hourIndex]);
          totalMinutes += hours * 60;
        }

        // Extract minutes if pattern has minute index
        if (pattern.minuteIndex !== -1 && match[pattern.minuteIndex]) {
          const minutes = parseInt(match[pattern.minuteIndex]);
          totalMinutes += minutes;
        }

        if (totalMinutes > 0) {
          return totalMinutes;
        }
      }
    }

    return 0;
  }

  private _parseQuantity(quantity: any): number {
    if (typeof quantity === 'number') return quantity;
    if (typeof quantity === 'string') {
      const parsed = parseFloat(quantity);
      return isNaN(parsed) ? 0 : parsed;
    }
    return 0;
  }

  private _parseServings(servings: any): number {
    if (typeof servings === 'number') return servings;
    if (typeof servings === 'string') {
      const match = servings.match(/(\d+)/);
      if (match) return parseInt(match[1]);
    }
    return 2;
  }

  private _applyDietaryFilters(
    recipes: RecipeDto[],
    dietaryRestrictions?: {
      isVegan?: boolean;
      isVegetarian?: boolean;
      isGlutenFree?: boolean;
      isLactoseFree?: boolean;
    }
  ): RecipeDto[] {
    if (!dietaryRestrictions) {
      console.log('  ℹ️ No dietary restrictions to apply');
      return recipes;
    }

    const activeRestrictions = Object.entries(dietaryRestrictions)
      .filter(([_, value]) => value === true)
      .map(([key]) => key);

    if (activeRestrictions.length === 0) {
      console.log('  ℹ️ No active dietary restrictions');
      return recipes;
    }

    console.log(`  🥗 Applying dietary restrictions: ${activeRestrictions.join(', ')}`);

    const filtered = recipes.filter((recipe: RecipeDto) => {
      if (dietaryRestrictions.isVegan && 
          !recipe.ingredients.every(ri => ri.ingredient?.isVegan === true)) {
        return false;
      }

      if (dietaryRestrictions.isVegetarian && 
          !recipe.ingredients.every(ri => ri.ingredient?.isVegetarian === true)) {
        return false;
      }

      if (dietaryRestrictions.isGlutenFree && 
          !recipe.ingredients.every(ri => ri.ingredient?.isGlutenFree === true)) {
        return false;
      }

      if (dietaryRestrictions.isLactoseFree && 
          !recipe.ingredients.every(ri => ri.ingredient?.isLactoseFree === true)) {
        return false;
      }

      return true;
    });

    console.log(`  ✅ ${filtered.length} recipes passed dietary filters`);
    return filtered;
  }

  /**
   * Hard filter recipes by tags - recipe MUST have ANY of the specified tags (OR logic)
   * This ensures flexibility when users select multiple cuisines
   */
  private _applyTagFilter(recipes: RecipeDto[], preferredTags: string[]): RecipeDto[] {
    if (!preferredTags || preferredTags.length === 0) {
      return recipes;
    }

    // Normalize tags for comparison (lowercase, trim)
    const normalizedPreferredTags = preferredTags.map(tag => tag.toLowerCase().trim());

    const tagLogic = preferredTags.length === 1 ? 'exact match' : 'any match (OR)';
    console.log(`  🏷️ Filtering recipes by tags [${tagLogic}]: ${preferredTags.join(', ')}`);

    const filtered = recipes.filter((recipe: RecipeDto) => {
      const recipeTags = (recipe.tags || []).map(t => t.name.toLowerCase().trim());

      // Recipe must have ANY of the preferred tags (OR logic)
      const hasAnyTag = normalizedPreferredTags.some(preferredTag =>
        recipeTags.includes(preferredTag)
      );

      if (!hasAnyTag && recipeTags.length > 0) {
        console.log(`    ❌ "${recipe.name}" - has tags [${recipeTags.join(', ')}] but needs one of [${normalizedPreferredTags.join(', ')}]`);
      }

      return hasAnyTag;
    });

    console.log(`  ✅ ${filtered.length} recipes matched at least one tag`);

    if (filtered.length === 0) {
      console.log(`  ⚠️ WARNING: No recipes found with tags [${preferredTags.join(', ')}]`);
      console.log(`  💡 Available tags in database:`);

      // Show sample of available tags
      const allTags = new Set<string>();
      recipes.forEach(r => {
        r.tags?.forEach(t => allTags.add(t.name));
      });
      console.log(`    ${Array.from(allTags).slice(0, 20).join(', ')}${allTags.size > 20 ? '...' : ''}`);
    }

    return filtered;
  }

  /**
   * Hard filter recipes by time and difficulty constraints
   * Users expect recipes to MATCH their constraints, not just get lower scores
   */
  private _applyConstraintFilters(
    recipes: RecipeDto[],
    maxCookingTimeMinutes?: number,
    preferredDifficulty?: string
  ): RecipeDto[] {
    let filtered = recipes;

    // Filter by cooking time (hard constraint)
    if (maxCookingTimeMinutes !== undefined && maxCookingTimeMinutes > 0) {
      const beforeTimeFilter = filtered.length;
      console.log(`  ⏱️ Filtering by max cooking time: ${maxCookingTimeMinutes} minutes`);

      filtered = filtered.filter((recipe: RecipeDto) => {
        const recipeMinutes = this._extractCookingTime(recipe.cookingTime || '');
        const withinLimit = recipeMinutes > 0 && recipeMinutes <= maxCookingTimeMinutes;

        if (!withinLimit && recipeMinutes > 0) {
          console.log(`    ❌ "${recipe.name}" - ${recipeMinutes}min exceeds limit of ${maxCookingTimeMinutes}min`);
        }

        return withinLimit;
      });

      console.log(`  ✅ ${filtered.length} recipes within time limit (was ${beforeTimeFilter})`);
    }

    // Filter by difficulty (hierarchical constraint)
    // Easy → Easy only
    // Medium → Easy + Medium
    // Hard → Easy + Medium + Hard
    if (preferredDifficulty && preferredDifficulty.trim() !== '') {
      const beforeDifficultyFilter = filtered.length;
      const normalizedPreferred = preferredDifficulty.toLowerCase().trim();

      // Define difficulty hierarchy
      const difficultyHierarchy: Record<string, string[]> = {
        'easy': ['easy'],
        'medium': ['easy', 'medium'],
        'hard': ['easy', 'medium', 'hard']
      };

      const allowedDifficulties = difficultyHierarchy[normalizedPreferred] || [normalizedPreferred];
      console.log(`  📊 Filtering by difficulty (hierarchical): ${preferredDifficulty} allows [${allowedDifficulties.join(', ')}]`);

      filtered = filtered.filter((recipe: RecipeDto) => {
        const recipeDifficulty = (recipe.difficulty || '').toLowerCase().trim();
        const matches = allowedDifficulties.includes(recipeDifficulty);

        if (!matches && recipeDifficulty) {
          console.log(`    ❌ "${recipe.name}" - difficulty "${recipe.difficulty}" not in allowed [${allowedDifficulties.join(', ')}]`);
        }

        return matches;
      });

      console.log(`  ✅ ${filtered.length} recipes match difficulty hierarchy (was ${beforeDifficultyFilter})`);
    }

    // Warning if no recipes left
    if (filtered.length === 0) {
      console.log(`  ⚠️ WARNING: No recipes found matching constraints`);
      if (maxCookingTimeMinutes) {
        console.log(`    Time limit: ${maxCookingTimeMinutes} minutes`);
      }
      if (preferredDifficulty) {
        console.log(`    Difficulty: ${preferredDifficulty}`);
      }
      console.log(`  💡 Consider relaxing constraints or adding more recipes to database`);
    }

    return filtered;
  }

  private _logResponseSummary(recipesForAI: any[], userContext: any): void {
    console.log('\n📦 Response Summary (Optimized for iOS Foundation Models):');
    console.log(`   ✅ Recipes sent: ${recipesForAI.length} (iOS-aligned scoring, top 40)`);
    console.log(`   🥬 User ingredients: ${userContext.availableIngredients.length}`);
    console.log(`   🏷️  Preferred tags: ${userContext.preferences.tags.join(', ') || 'none'}`);
    console.log(`   ⏱️  Max cooking time: ${userContext.preferences.maxCookingTimeMinutes || 'unlimited'} min`);
    console.log(`   📊 Difficulty: ${userContext.preferences.preferredDifficulty || 'any'}`);

    const activeDietary = Object.entries(userContext.dietaryRestrictions)
      .filter(([_, v]) => v)
      .map(([k]) => k);
    console.log(`   🥗 Dietary restrictions: ${activeDietary.join(', ') || 'none'}`);

    console.log(`\n   Top 3 recipes being sent:`);
    recipesForAI.slice(0, 3).forEach((r, idx) => {
      console.log(`      ${idx + 1}. ${r.name} (${r.cookingTime}, ${r.difficulty})`);
    });

    console.log(`\n   💡 Backend → iOS flow:`);
    console.log(`      1. Backend: Filtered ${recipesForAI.length} recipes using iOS-aligned scoring`);
    console.log(`      2. iOS: Will re-score and select best ~15 for Foundation Models`);
    console.log(`      3. iOS: Will validate AI outputs for reliability`);
    console.log('');
  }
}