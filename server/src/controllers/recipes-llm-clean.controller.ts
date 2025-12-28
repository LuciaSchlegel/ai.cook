// controllers/recipes-llm-clean.controller.ts
// CLEAN APPROACH: Backend pre-computes ALL matching data
// AI only generates language (reasoning, tips, substitutions)

import { Request, Response } from "express";
import { RecipeService } from "../services/recipe.service";
import { UserIngredientsService } from "../services/user_ingredients.service";
import { AIRecommendationRequestDto } from "../dtos/ai_recommendation.dto";
import { RecipeTagDto } from "../dtos/recipe_tag.dto";
import { RecipeDto } from "../dtos/recipe.dto";
import { UserIngredientOptimizedDto } from "../dtos/user_ing_optimized.dto";
import { plainToInstance } from 'class-transformer';

interface ScoredRecipe {
  recipe: RecipeDto;
  matchingIngredients: string[];
  missingIngredients: string[];
  missingCount: number;
  matchScore: number;
  ingredientMatchPercent: number;
}

export class RecipesLLMCleanController {
  private recipeService = new RecipeService();
  private userIngredientsService = new UserIngredientsService();

  // Pre-compiled regex patterns for time parsing
  private static readonly TIME_REGEX_PATTERNS = [
    { regex: /(\d+)h(?:our)?(?:s)?(\d+)?m/i, hourIndex: 1, minuteIndex: 2 },
    { regex: /(\d+)m(?:in)?(?:s)?/i, hourIndex: -1, minuteIndex: 1 },
    { regex: /(\d+)h(?:our)?(?:s)?/i, hourIndex: 1, minuteIndex: -1 }
  ] as const;

  /**
   * NEW CLEAN ENDPOINT: Pre-compute all matching data
   * Backend does ALL data processing, AI just generates language
   */
  getStructuredRecipesForAI = async (req: Request, res: Response): Promise<void> => {
    try {
      const { uid } = req.params;

      if (!uid) {
        res.status(401).json({ error: 'Unauthorized' });
        return;
      }

      const requestDto: AIRecommendationRequestDto = req.body;

      console.log('\n' + '='.repeat(70));
      console.log('📱 CLEAN Foundation Models Fetch (Pre-Computed Data)');
      console.log('='.repeat(70));
      console.log('   Approach: Backend computes ALL matching data');
      console.log('   AI Role: Generate reasoning, tips, substitutions ONLY');
      console.log('\n📊 Client Preferences:');
      console.log(`   Tags: ${requestDto.preferredTags?.join(', ') || 'none'}`);
      console.log(`   Max time: ${requestDto.maxCookingTimeMinutes || 'unlimited'} min`);
      console.log(`   Difficulty: ${requestDto.preferredDifficulty || 'any'}`);
      console.log('='.repeat(70) + '\n');

      // Fetch all recipes and user ingredients
      const allRecipes = await this.recipeService.getRecipes() as RecipeDto[];
      const userIngredientsEntities = await this.userIngredientsService.getUserIngredients(uid);
      const userIngredients = plainToInstance(
        UserIngredientOptimizedDto,
        userIngredientsEntities,
        { excludeExtraneousValues: true, enableImplicitConversion: true }
      );

      console.log(`📊 Found ${allRecipes.length} total recipes`);
      console.log(`🥬 User has ${userIngredients?.length || 0} ingredients`);

      if (!userIngredients || userIngredients.length === 0) {
        res.status(400).json({
          error: 'NO_INGREDIENTS',
          message: 'Please add ingredients to your cupboard first',
        });
        return;
      }

      // Create user ingredient lookup
      const userIngredientNames = new Set(
        userIngredients.map(ui =>
          (ui.ingredient?.name || ui.customIngredient?.name || '').toLowerCase()
        )
      );

      // Apply hard filters
      let filteredRecipes = this._applyDietaryFilters(allRecipes, requestDto.dietaryRestrictions);
      console.log(`✅ After dietary filters: ${filteredRecipes.length} recipes`);

      if (requestDto.preferredTags && requestDto.preferredTags.length > 0) {
        filteredRecipes = this._applyTagFilter(filteredRecipes, requestDto.preferredTags);
        console.log(`✅ After tag filter: ${filteredRecipes.length} recipes`);
      }

      if (requestDto.maxCookingTimeMinutes || requestDto.preferredDifficulty) {
        filteredRecipes = this._applyConstraintFilters(
          filteredRecipes,
          requestDto.maxCookingTimeMinutes,
          requestDto.preferredDifficulty
        );
        console.log(`✅ After time/difficulty filter: ${filteredRecipes.length} recipes`);
      }

      // Compute ingredient matches for each recipe
      const scoredRecipes: ScoredRecipe[] = filteredRecipes.map(recipe => {
        const recipeIngredients = recipe.ingredients.filter(ri => ri.ingredient);
        const matching: string[] = [];
        const missing: string[] = [];

        recipeIngredients.forEach(ri => {
          const ingredientName = ri.ingredient!.name.toLowerCase();
          if (userIngredientNames.has(ingredientName)) {
            matching.push(ri.ingredient!.name);
          } else {
            missing.push(ri.ingredient!.name);
          }
        });

        const totalIngredients = recipeIngredients.length;
        const matchPercent = totalIngredients > 0
          ? Math.round((matching.length / totalIngredients) * 100)
          : 0;

        // Calculate match score (0-100)
        let score = matchPercent; // Base score from ingredient match

        // Bonus for 100% match
        if (missing.length === 0) {
          score = 100;
        }
        // Bonus for just 1 missing
        else if (missing.length === 1) {
          score = Math.min(95, score + 10);
        }
        // Penalty for many missing
        else if (missing.length > 3) {
          score = Math.max(0, score - (missing.length * 5));
        }

        return {
          recipe,
          matchingIngredients: matching,
          missingIngredients: missing,
          missingCount: missing.length,
          matchScore: Math.round(score),
          ingredientMatchPercent: matchPercent,
        };
      });

      // Categorize recipes (BACKEND does this, not AI!)
      const readyToCook = scoredRecipes
        .filter(sr => sr.missingCount <= 1)
        .sort((a, b) => b.matchScore - a.matchScore)
        .slice(0, 5); // Top 5

      const almostReady = scoredRecipes
        .filter(sr => sr.missingCount >= 2 && sr.missingCount <= 3)
        .sort((a, b) => b.matchScore - a.matchScore)
        .slice(0, 5); // Top 5

      console.log('\n🎯 Categorization Results:');
      console.log(`   Ready to Cook (0-1 missing): ${readyToCook.length}`);
      console.log(`   Almost Ready (2-3 missing): ${almostReady.length}`);

      // Format for AI (minimal data, pre-computed)
      const formatRecipe = (sr: ScoredRecipe) => ({
        id: sr.recipe.id,
        name: sr.recipe.name,
        cookingTime: sr.recipe.cookingTime || 'Not specified',
        difficulty: sr.recipe.difficulty || 'Medium',
        tags: sr.recipe.tags?.map((t: RecipeTagDto) => t.name) || [],
        matchingIngredients: sr.matchingIngredients,
        missingIngredients: sr.missingIngredients,
        matchScore: sr.matchScore,
        ingredientMatchPercent: sr.ingredientMatchPercent,
      });

      // Return structured data
      res.status(200).json({
        readyToCook: readyToCook.map(formatRecipe),
        almostReady: almostReady.map(formatRecipe),
        userContext: {
          availableIngredients: userIngredients
            .map(ui => ui.ingredient?.name || ui.customIngredient?.name)
            .filter(Boolean),
          preferences: {
            tags: requestDto.preferredTags || [],
            maxCookingTimeMinutes: requestDto.maxCookingTimeMinutes,
            preferredDifficulty: requestDto.preferredDifficulty,
          },
        },
        metadata: {
          totalFiltered: filteredRecipes.length,
          readyCount: readyToCook.length,
          almostReadyCount: almostReady.length,
          approach: 'pre-computed',
          timestamp: new Date().toISOString(),
        },
      });

      console.log(`\n✅ Sent ${readyToCook.length} ready + ${almostReady.length} almost ready`);
      console.log('   AI will only generate: reasoning, tips, substitutions');
      console.log('='.repeat(70) + '\n');

    } catch (error) {
      console.error('❌ Error in getStructuredRecipesForAI:', error);
      res.status(500).json({
        error: 'Failed to fetch structured recipes',
        message: error instanceof Error ? error.message : 'Unknown error',
      });
    }
  };

  // ===== HELPER METHODS =====

  private _applyDietaryFilters(
    recipes: RecipeDto[],
    dietaryRestrictions?: {
      isVegan?: boolean;
      isVegetarian?: boolean;
      isGlutenFree?: boolean;
      isLactoseFree?: boolean;
    }
  ): RecipeDto[] {
    if (!dietaryRestrictions) return recipes;

    const { isVegan, isVegetarian, isGlutenFree, isLactoseFree } = dietaryRestrictions;
    const activeRestrictions = [isVegan, isVegetarian, isGlutenFree, isLactoseFree].some(Boolean);

    if (!activeRestrictions) {
      console.log('  ℹ️ No active dietary restrictions');
      return recipes;
    }

    console.log('  🥗 Applying dietary filters:');
    if (isVegan) console.log('     - Vegan');
    if (isVegetarian && !isVegan) console.log('     - Vegetarian');
    if (isGlutenFree) console.log('     - Gluten-free');
    if (isLactoseFree) console.log('     - Lactose-free');

    return recipes.filter(recipe => {
      const tags = recipe.tags?.map(t => t.name.toLowerCase()) || [];

      if (isVegan) {
        return tags.includes('vegan');
      }
      if (isVegetarian) {
        return tags.includes('vegan') || tags.includes('vegetarian');
      }
      if (isGlutenFree && !tags.includes('gluten-free')) {
        return false;
      }
      if (isLactoseFree && !tags.includes('lactose-free')) {
        return false;
      }

      return true;
    });
  }

  private _applyTagFilter(recipes: RecipeDto[], preferredTags: string[]): RecipeDto[] {
    const normalizedPreferredTags = preferredTags.map(tag => tag.toLowerCase().trim());
    const tagLogic = preferredTags.length === 1 ? 'exact match' : 'any match (OR)';

    console.log(`  🏷️ Filtering recipes by tags [${tagLogic}]: ${preferredTags.join(', ')}`);

    const filtered = recipes.filter((recipe: RecipeDto) => {
      const recipeTags = (recipe.tags || []).map(t => t.name.toLowerCase().trim());
      const hasAnyTag = normalizedPreferredTags.some(preferredTag =>
        recipeTags.includes(preferredTag)
      );

      if (!hasAnyTag) {
        console.log(`    ❌ "${recipe.name}" - has tags [${recipeTags.join(', ')}] but needs one of [${normalizedPreferredTags.join(', ')}]`);
      }

      return hasAnyTag;
    });

    console.log(`  ✅ ${filtered.length} recipes matched at least one tag`);
    return filtered;
  }

  private _applyConstraintFilters(
    recipes: RecipeDto[],
    maxCookingTimeMinutes?: number,
    preferredDifficulty?: string
  ): RecipeDto[] {
    let filtered = recipes;

    // Filter by cooking time
    if (maxCookingTimeMinutes !== undefined && maxCookingTimeMinutes > 0) {
      console.log(`  ⏱️ Filtering by max cooking time: ${maxCookingTimeMinutes} minutes`);

      filtered = filtered.filter((recipe: RecipeDto) => {
        const recipeMinutes = this._extractCookingTime(recipe.cookingTime || '');
        const withinLimit = recipeMinutes > 0 && recipeMinutes <= maxCookingTimeMinutes;

        if (!withinLimit && recipeMinutes > 0) {
          console.log(`    ❌ "${recipe.name}" - ${recipeMinutes}min exceeds limit of ${maxCookingTimeMinutes}min`);
        }

        return withinLimit;
      });
    }

    // Filter by difficulty (hierarchical)
    if (preferredDifficulty && preferredDifficulty.trim() !== '') {
      const normalizedPreferred = preferredDifficulty.toLowerCase().trim();

      const difficultyHierarchy: Record<string, string[]> = {
        'easy': ['easy'],
        'medium': ['easy', 'medium'],
        'hard': ['easy', 'medium', 'hard']
      };

      const allowedDifficulties = difficultyHierarchy[normalizedPreferred] || [normalizedPreferred];
      console.log(`  📊 Filtering by difficulty (hierarchical): ${preferredDifficulty} allows [${allowedDifficulties.join(', ')}]`);

      filtered = filtered.filter((recipe: RecipeDto) => {
        const recipeDifficulty = (recipe.difficulty || '').toLowerCase().trim();
        return allowedDifficulties.includes(recipeDifficulty);
      });
    }

    return filtered;
  }

  private _extractCookingTime(cookingTime: string): number {
    const cleanedTime = cookingTime.toLowerCase().replace(/\s/g, '');

    for (const pattern of RecipesLLMCleanController.TIME_REGEX_PATTERNS) {
      const match = pattern.regex.exec(cleanedTime);
      if (match) {
        let totalMinutes = 0;

        if (pattern.hourIndex !== -1 && match[pattern.hourIndex]) {
          totalMinutes += parseInt(match[pattern.hourIndex]) * 60;
        }

        if (pattern.minuteIndex !== -1 && match[pattern.minuteIndex]) {
          totalMinutes += parseInt(match[pattern.minuteIndex]);
        }

        if (totalMinutes > 0) {
          return totalMinutes;
        }
      }
    }

    return 0;
  }
}
