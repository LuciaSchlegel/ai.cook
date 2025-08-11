import { RecipeDto } from "../dtos/recipe.dto";
import { UserIngredientOptimizedDto } from "../dtos/user_ing_optimized.dto";

export type FilterMode = "strict" | "ai_flexible";

export type FilterOptions = {
  allRecipes: RecipeDto[];
  userIngredients: UserIngredientOptimizedDto[];
  filter?: "All Recipes" | "With Available Ingredients" | "Recommended Recipes";
  preferredTags?: string[];
  maxCookingTimeMinutes?: number;
  preferredDifficulty?: string;
  dietaryRestrictions?: {
    isVegan?: boolean;
    isVegetarian?: boolean;
    isGlutenFree?: boolean;
    isLactoseFree?: boolean;
  };
  mode?: FilterMode; // "strict" for regular filtering, "ai_flexible" for AI recommendations
};

export type RecipeWithMissingIngredients = {
  recipe: RecipeDto;
  missingIngredients: Array<{
    ingredient: any;
    quantity: number;
    unit: any;
  }>;
  missingCount: number;
  availableCount: number;
  totalCount: number;
  matchPercentage: number;
};

export const RecipeFilterService = {
  // Performance flag - set to false in production to reduce logging
  DEBUG_MODE: process.env.NODE_ENV !== 'production',

  filterRecipes({
    allRecipes,
    userIngredients,
    filter = "All Recipes",
    preferredTags = [],
    maxCookingTimeMinutes,
    preferredDifficulty,
    dietaryRestrictions,
    mode = "strict",
  }: FilterOptions): RecipeDto[] {
    let filtered = [...allRecipes];
    
    if (this.DEBUG_MODE) {
      console.log(`🔍 Starting filter: ${filter}`);
      console.log(`📊 Initial recipes: ${filtered.length}`);
      console.log(`🏷️ Preferred tags: ${preferredTags.join(', ')}`);
    }

    // Apply main filter based on type and mode
    if (filter === "With Available Ingredients") {
      if (mode === "ai_flexible") {
        // For AI, allow recipes with up to 2 missing ingredients
        filtered = filtered.filter(recipe => this._hasAlmostAllIngredients(recipe, userIngredients, 2));
        if (this.DEBUG_MODE) console.log(`✅ After AI Flexible Available filter: ${filtered.length} recipes`);
      } else {
        filtered = filtered.filter(recipe => this._hasAllIngredientsWithQuantity(recipe, userIngredients));
        if (this.DEBUG_MODE) console.log(`✅ After Strict Available filter: ${filtered.length} recipes`);
      }
    } else if (filter === "Recommended Recipes") {
      if (mode === "ai_flexible") {
        // For AI recommendations, be more flexible - allow recipes with good ingredient match
        filtered = filtered.filter(recipe => this._hasFlexibleRecommendedIngredients(recipe, userIngredients));
        if (this.DEBUG_MODE) console.log(`✅ After AI Flexible Recommended filter: ${filtered.length} recipes`);
      } else {
        filtered = filtered.filter(recipe => this._hasRecommendedIngredients(recipe, userIngredients));
        if (this.DEBUG_MODE) console.log(`✅ After Strict Recommended filter: ${filtered.length} recipes`);
      }
    } else if (filter === "All Recipes") {
      if (this.DEBUG_MODE) console.log(`🎯 Filter is "All Recipes" - keeping all recipes for tag filtering`);
    }

    // Apply tag filters regardless of main filter type
    if (preferredTags.length > 0) {
      const beforeTags = filtered.length;
      if (this.DEBUG_MODE) console.log(`🔍 Starting tag filtering with ${preferredTags.length} preferred tags: [${preferredTags.join(', ')}]`);
      
      // Normalize preferred tags for comparison (trim whitespace and lowercase)
      const normalizedPreferredTags = preferredTags.map(tag => tag.trim().toLowerCase());
      if (this.DEBUG_MODE) console.log(`🔧 Normalized preferred tags: [${normalizedPreferredTags.join(', ')}]`);
      
      filtered = filtered.filter(recipe => {
        const recipeTags = recipe.tags?.map(tag => tag.name) || [];
        const normalizedRecipeTags = recipeTags.map(tag => tag.trim().toLowerCase());
        
        console.log(`🍳 Recipe "${recipe.name}" (ID: ${recipe.id}):`);
        console.log(`  📋 Original recipe tags: [${recipeTags.join(', ')}] (${recipeTags.length} tags)`);
        console.log(`  🔧 Normalized recipe tags: [${normalizedRecipeTags.join(', ')}]`);
        console.log(`  🎯 Looking for normalized: [${normalizedPreferredTags.join(', ')}]`);
        
        if (recipeTags.length === 0) {
          console.log(`  ❌ Recipe has no tags`);
          return false;
        }
        
        const hasMatchingTag = normalizedPreferredTags.every(preferredTag => {
          const matches = normalizedRecipeTags.includes(preferredTag);
          console.log(`    🔍 Checking for "${preferredTag}" -> ${matches ? '✅' : '❌'}`);
          return matches;
        });
        
        console.log(`  🎯 Final result for "${recipe.name}": ${hasMatchingTag ? '✅ INCLUDED' : '❌ EXCLUDED'}`);
        return hasMatchingTag;
      });
      console.log(`🏷️ After tags filter: ${beforeTags} -> ${filtered.length} recipes`);
      
      if (filtered.length === 0) {
        console.log(`⚠️ WARNING: No recipes found with normalized tags [${normalizedPreferredTags.join(', ')}]`);
        console.log(`📊 Available normalized tags in all recipes:`);
        allRecipes.forEach(recipe => {
          const recipeTags = recipe.tags?.map(tag => tag.name) || [];
          const normalizedRecipeTags = recipeTags.map(tag => tag.trim().toLowerCase());
          if (recipeTags.length > 0) {
            console.log(`  - "${recipe.name}": original [${recipeTags.join(', ')}] -> normalized [${normalizedRecipeTags.join(', ')}]`);
          }
        });
      }
    }

    // Apply dietary restriction filters to all filter types
    if (dietaryRestrictions) {
      const beforeDietary = filtered.length;
      filtered = filtered.filter(recipe => this._meetsDietaryRestrictions(recipe, dietaryRestrictions));
      console.log(`🥗 After dietary restrictions filter: ${beforeDietary} -> ${filtered.length} recipes`);
    }

    // Apply personal preference filters ONLY for filters other than "With Available Ingredients"
    if (filter !== "With Available Ingredients") {
      if (preferredDifficulty && preferredDifficulty.trim() !== '') {
        const beforeDifficulty = filtered.length;
        filtered = filtered.filter(recipe =>
          recipe.difficulty?.toLowerCase() === preferredDifficulty.toLowerCase(),
        );
        console.log(`📊 After difficulty filter: ${beforeDifficulty} -> ${filtered.length} recipes`);
      } else {
        console.log(`📊 Skipping difficulty filter - no difficulty specified`);
      }

      if (maxCookingTimeMinutes !== undefined && maxCookingTimeMinutes !== null && maxCookingTimeMinutes > 0) {
        const beforeTime = filtered.length;
        filtered = filtered.filter(recipe => {
          if (!recipe.cookingTime) return false;
          const cookingTime = this._extractCookingTime(recipe.cookingTime);
          const matches = cookingTime <= maxCookingTimeMinutes;
          console.log(`⏰ Recipe "${recipe.name}" cooking time: ${recipe.cookingTime} (${cookingTime}min) - Match: ${matches} (limit: ${maxCookingTimeMinutes}min)`);
          return matches;
        });
        console.log(`⏰ After time filter: ${beforeTime} -> ${filtered.length} recipes`);
      } else {
        console.log(`⏰ Skipping cooking time filter - no time limit specified (value: ${maxCookingTimeMinutes})`);
      }
    } else {
      console.log(`🚫 Skipping personal preference filters for "With Available Ingredients" filter`);
    }

    if (this.DEBUG_MODE) console.log(`🎯 Final result: ${filtered.length} recipes`);
    return filtered;
  },

  // Optimized ingredient matching with caching
  _createUserIngredientLookup(userIngredients: UserIngredientOptimizedDto[]): Map<number, UserIngredientOptimizedDto> {
    const lookup = new Map<number, UserIngredientOptimizedDto>();
    userIngredients.forEach(ui => {
      if (ui.ingredient?.id) {
        lookup.set(ui.ingredient.id, ui);
      }
    });
    return lookup;
  },

  // Function for verifying ingredients, quantities, and units
  _hasAllIngredientsWithQuantity(recipe: RecipeDto, userIngredients: UserIngredientOptimizedDto[]): boolean {
    if (this.DEBUG_MODE) {
      console.log(`🧪 Checking recipe "${recipe.name}" with ${recipe.ingredients.length} ingredients`);
      console.log(`👤 User has ${userIngredients.length} ingredients available`);
    }

    // Create lookup map for O(1) ingredient access instead of O(n) searching
    const userIngredientLookup = this._createUserIngredientLookup(userIngredients);
    
    const result = recipe.ingredients.every((ri, index) => {
      if (this.DEBUG_MODE) {
        console.log(`\n  📋 Checking recipe ingredient ${index + 1}/${recipe.ingredients.length}:`);
      }
      
      // Verificar que el ingrediente de la receta existe
      if (!ri.ingredient) {
        if (this.DEBUG_MODE) console.log(`    ❌ Recipe ingredient has no ingredient object`);
        return false;
      }
      
      if (this.DEBUG_MODE) {
        console.log(`    🥬 Recipe needs: "${ri.ingredient.name}" (ID: ${ri.ingredient.id})`);
        console.log(`    📊 Recipe quantity: ${ri.quantity}`);
        console.log(`    🏷️ Recipe unit:`, ri.unit);
      }
      
      // Fast lookup using pre-built map (O(1) instead of O(n))
      let userIng = userIngredientLookup.get(ri.ingredient.id);
      
      // If not found in regular ingredients, check custom ingredients (still O(n) but only when needed)
      if (!userIng) {
        userIng = userIngredients.find(ui => {
          // Skip if already found in regular ingredients lookup
          if (ui.ingredient?.id) return false;
          
          // Check custom ingredients by name matching
          if (ui.customIngredient) {
            const recipeName = ri.ingredient.name.toLowerCase().trim();
            const customName = ui.customIngredient.name.toLowerCase().trim();
            
            // Try exact match first
            if (recipeName === customName) {
              if (this.DEBUG_MODE) console.log(`    🔍 Custom ingredient exact match: "${customName}" vs "${recipeName}" = true`);
              return true;
            }
            
            // Try fuzzy matching for similar names (contains or partial match)
            const fuzzyMatch = recipeName.includes(customName) || customName.includes(recipeName);
            if (this.DEBUG_MODE) console.log(`    🔍 Custom ingredient fuzzy match: "${customName}" vs "${recipeName}" = ${fuzzyMatch}`);
            return fuzzyMatch;
          }
          
          return false;
        });
      }

      if (!userIng) {
        if (this.DEBUG_MODE) console.log(`    ❌ User doesn't have this ingredient`);
        return false;
      }
      
      if (this.DEBUG_MODE) {
        console.log(`    ✅ User has ingredient: "${userIng.ingredient?.name || userIng.customIngredient?.name}"`);
        console.log(`    👤 User quantity: ${userIng.quantity}`);
        console.log(`    🏷️ User unit:`, userIng.unit);
      }

      // Verificar que tenga cantidad y unidad definida
      if (!userIng.unit || !ri.unit) {
        console.log(`    ❌ Missing units - User unit: ${!!userIng.unit}, Recipe unit: ${!!ri.unit}`);
        return false;
      }

      // Verificar compatibilidad de unidades
      const compatible = this._areUnitsCompatible(userIng.unit, ri.unit);
      console.log(`    🔗 Units compatible: ${compatible} (user: "${userIng.unit.abbreviation}" vs recipe: "${ri.unit.abbreviation}")`);
      if (!compatible) {
        return false;
      }

      // Verificar que tenga suficiente cantidad
      try {
        const userAmountBase = this._convertToBase(userIng.quantity, userIng.unit);
        const recipeAmountBase = this._convertToBase(ri.quantity, ri.unit);
        const hasEnough = userAmountBase >= recipeAmountBase;
        
        console.log(`    📐 Conversion - User: ${userIng.quantity} ${userIng.unit.abbreviation} = ${userAmountBase} base units`);
        console.log(`    📐 Conversion - Recipe: ${ri.quantity} ${ri.unit.abbreviation} = ${recipeAmountBase} base units`);
        console.log(`    ✔️ Has enough quantity: ${hasEnough}`);
        
        return hasEnough;
      } catch (error) {
        console.log(`    ❌ Conversion failed:`, error);
        return false; // Si falla la conversión, asumir que no alcanza
      }
    });
    
    if (this.DEBUG_MODE) console.log(`🎯 Recipe "${recipe.name}" result: ${result ? 'PASSED' : 'FAILED'}\n`);
    return result;
  },

  // Función para "Recommended" que verifica ratio y cantidades (como en Flutter)
  _hasRecommendedIngredients(recipe: RecipeDto, userIngredients: UserIngredientOptimizedDto[]): boolean {
    // Si no hay ingredientes del usuario, retornar todas las recetas como recomendadas
    if (!userIngredients || userIngredients.length === 0) {
      console.log(`  📝 No user ingredients provided - recommending all recipes`);
      return true;
    }

    // Paso 1: Verificar ratio de ingredientes (mínimo 60% como en Flutter)
    const matchedCount = recipe.ingredients.filter(ri => {
      if (!ri.ingredient) return false;
      return userIngredients.some(ui => {
        // Check regular ingredients
        if (ui.ingredient?.id === ri.ingredient.id) return true;
        
        // Check custom ingredients by name with fuzzy matching
        if (ui.customIngredient) {
          const recipeName = ri.ingredient.name.toLowerCase().trim();
          const customName = ui.customIngredient.name.toLowerCase().trim();
          return recipeName === customName || recipeName.includes(customName) || customName.includes(recipeName);
        }
        
        return false;
      });
    }).length;

    const validIngredients = recipe.ingredients.filter(ri => ri.ingredient !== null);
    const ratio = matchedCount / validIngredients.length;
    
    console.log(`  📊 Recipe "${recipe.name}": ${matchedCount}/${validIngredients.length} ingredients matched (${(ratio * 100).toFixed(1)}%)`);
    
    if (ratio < 0.4) return false; // 40% threshold - better balance for recommendations

    // Paso 2: Para "Recommended", ser más flexible con las cantidades
    // Solo verificar ingredientes que coinciden, pero no rechazar por incompatibilidad de unidades
    const hasEnoughMatched = recipe.ingredients.every(ri => {
      if (!ri.ingredient) return true; // Ignorar ingredientes inválidos
      
      const userIng = userIngredients.find(ui => {
        // Check regular ingredients
        if (ui.ingredient?.id === ri.ingredient.id) return true;
        
        // Check custom ingredients by name with fuzzy matching
        if (ui.customIngredient) {
          const recipeName = ri.ingredient.name.toLowerCase().trim();
          const customName = ui.customIngredient.name.toLowerCase().trim();
          return recipeName === customName || recipeName.includes(customName) || customName.includes(recipeName);
        }
        
        return false;
      });
      
      if (!userIng) return true; // Si no lo tiene, no es problema para "Recommended"

      // Si no tiene cantidad o unit definida, asumir que está bien para "Recommended"
      if (!userIng.unit || !ri.unit) return true;

      // Para "Recommended", si las unidades no son compatibles, asumir que está bien
      if (!this._areUnitsCompatible(userIng.unit, ri.unit)) {
        console.log(`    🔄 Units not compatible for "${ri.ingredient.name}" - allowing for Recommended filter`);
        return true;
      }

      try {
        const userAmountBase = this._convertToBase(userIng.quantity, userIng.unit);
        const recipeAmountBase = this._convertToBase(ri.quantity, ri.unit);
        const hasEnough = userAmountBase >= recipeAmountBase;
        console.log(`    ✔️ Quantity check for "${ri.ingredient.name}": ${hasEnough}`);
        return hasEnough;
      } catch (error) {
        console.log(`    🔄 Conversion failed for "${ri.ingredient.name}" - allowing for Recommended filter`);
        return true; // Para "Recommended", ser permisivo con errores de conversión
      }
    });

    console.log(`  🎯 Recipe "${recipe.name}" final result: ${hasEnoughMatched} (ratio: ${(ratio * 100).toFixed(1)}%)`);
    return hasEnoughMatched;
  },

  _hasAllIngredients(recipe: RecipeDto, userIngredients: UserIngredientOptimizedDto[]): boolean {
    return recipe.ingredients.every(ri => {
      // Verificar que el ingrediente de la receta existe
      if (!ri.ingredient) return false;
      
      // Buscar si el usuario tiene este ingrediente
      return userIngredients.some(ui => {
        // Check regular ingredients
        if (ui.ingredient?.id === ri.ingredient.id) return true;
        
        // Check custom ingredients by name with fuzzy matching
        if (ui.customIngredient) {
          const recipeName = ri.ingredient.name.toLowerCase().trim();
          const customName = ui.customIngredient.name.toLowerCase().trim();
          return recipeName === customName || recipeName.includes(customName) || customName.includes(recipeName);
        }
        
        return false;
      });
    });
  },

  _hasMissingIngredients(recipe: RecipeDto, userIngredients: UserIngredientOptimizedDto[]): boolean {
    return recipe.ingredients.some(ri => {
      // Verificar que el ingrediente de la receta existe
      if (!ri.ingredient) return false;
      
      // Verificar si el usuario NO tiene este ingrediente
      return !userIngredients.some(ui => {
        // Check regular ingredients
        if (ui.ingredient?.id === ri.ingredient.id) return true;
        
        // Check custom ingredients by name with fuzzy matching
        if (ui.customIngredient) {
          const recipeName = ri.ingredient.name.toLowerCase().trim();
          const customName = ui.customIngredient.name.toLowerCase().trim();
          return recipeName === customName || recipeName.includes(customName) || customName.includes(recipeName);
        }
        
        return false;
      });
    });
  },

  _hasSomeIngredients(recipe: RecipeDto, userIngredients: UserIngredientOptimizedDto[]): boolean {
    // Para RECOMMENDED, mostramos recetas que tienen al menos 50% de los ingredientes
    const availableIngredients = recipe.ingredients.filter(ri => {
      // Verificar que el ingrediente de la receta existe
      if (!ri.ingredient) return false;
      
      // Verificar si el usuario tiene este ingrediente
      return userIngredients.some(ui => {
        // Check regular ingredients
        if (ui.ingredient?.id === ri.ingredient.id) return true;
        
        // Check custom ingredients by name with fuzzy matching
        if (ui.customIngredient) {
          const recipeName = ri.ingredient.name.toLowerCase().trim();
          const customName = ui.customIngredient.name.toLowerCase().trim();
          return recipeName === customName || recipeName.includes(customName) || customName.includes(recipeName);
        }
        
        return false;
      });
    });
    
    // Solo contar ingredientes válidos
    const validIngredients = recipe.ingredients.filter(ri => ri.ingredient !== null);
    return availableIngredients.length >= validIngredients.length * 0.5;
  },

  // AI Flexible filtering methods

  /**
   * Checks if user has almost all ingredients (allows up to maxMissing missing ingredients)
   * Used for AI flexible filtering
   */
  _hasAlmostAllIngredients(recipe: RecipeDto, userIngredients: UserIngredientOptimizedDto[], maxMissing: number = 2): boolean {
    if (this.DEBUG_MODE) {
      console.log(`🤖 AI Flexible: Checking recipe "${recipe.name}" (max missing: ${maxMissing})`);
    }

    const userIngredientLookup = this._createUserIngredientLookup(userIngredients);
    let missingCount = 0;
    let checkedIngredients = 0;

    for (const ri of recipe.ingredients) {
      if (!ri.ingredient) continue; // Skip invalid ingredients
      checkedIngredients++;

      // Fast lookup using pre-built map
      let userIng = userIngredientLookup.get(ri.ingredient.id);
      
      // Check custom ingredients if not found in regular ingredients
      if (!userIng) {
        userIng = userIngredients.find(ui => {
          if (ui.ingredient?.id) return false; // Skip regular ingredients (already checked)
          
          if (ui.customIngredient) {
            const recipeName = ri.ingredient.name.toLowerCase().trim();
            const customName = ui.customIngredient.name.toLowerCase().trim();
            return recipeName === customName || recipeName.includes(customName) || customName.includes(recipeName);
          }
          
          return false;
        });
      }

      if (!userIng) {
        missingCount++;
        if (this.DEBUG_MODE) {
          console.log(`    ❌ Missing: "${ri.ingredient.name}" (${missingCount}/${maxMissing})`);
        }
        
        // Early exit if too many missing
        if (missingCount > maxMissing) {
          if (this.DEBUG_MODE) {
            console.log(`🤖 Recipe "${recipe.name}" rejected: ${missingCount} missing > ${maxMissing} allowed`);
          }
          return false;
        }
      } else {
        if (this.DEBUG_MODE) {
          console.log(`    ✅ Available: "${ri.ingredient.name}"`);
        }
      }
    }

    const passed = missingCount <= maxMissing;
    if (this.DEBUG_MODE) {
      console.log(`🤖 Recipe "${recipe.name}" result: ${passed} (${missingCount}/${maxMissing} missing from ${checkedIngredients} ingredients)`);
    }
    
    return passed;
  },

  /**
   * More flexible version of recommended ingredients for AI
   * Lower threshold and more permissive with missing ingredients
   */
  _hasFlexibleRecommendedIngredients(recipe: RecipeDto, userIngredients: UserIngredientOptimizedDto[]): boolean {
    if (!userIngredients || userIngredients.length === 0) {
      return true; // If no ingredients, recommend all recipes
    }

    // Count available vs total ingredients
    const userIngredientLookup = this._createUserIngredientLookup(userIngredients);
    let availableCount = 0;
    let totalCount = 0;

    recipe.ingredients.forEach(ri => {
      if (!ri.ingredient) return;
      totalCount++;

      // Check if user has this ingredient (regular or custom)
      let hasIngredient = userIngredientLookup.has(ri.ingredient.id);
      
      if (!hasIngredient) {
        hasIngredient = userIngredients.some(ui => {
          if (ui.ingredient?.id) return false;
          
          if (ui.customIngredient) {
            const recipeName = ri.ingredient.name.toLowerCase().trim();
            const customName = ui.customIngredient.name.toLowerCase().trim();
            return recipeName === customName || recipeName.includes(customName) || customName.includes(recipeName);
          }
          
          return false;
        });
      }

      if (hasIngredient) {
        availableCount++;
      }
    });

    if (totalCount === 0) return false;

    const ratio = availableCount / totalCount;
    const missingCount = totalCount - availableCount;
    
    // For AI flexible mode: accept if either:
    // 1. Has at least 30% of ingredients (lower than strict 40%), OR
    // 2. Missing 2 or fewer ingredients regardless of ratio (for small recipes)
    const passesRatio = ratio >= 0.3;
    const passesMissingCount = missingCount <= 2;
    const passes = passesRatio || passesMissingCount;

    if (this.DEBUG_MODE) {
      console.log(`🤖 Flexible Recommended "${recipe.name}": ${availableCount}/${totalCount} (${(ratio * 100).toFixed(1)}%, missing: ${missingCount}) → ${passes}`);
    }

    return passes;
  },

  /**
   * Special method for AI recommendations that returns detailed missing ingredient information
   * This allows the AI to suggest recipes with missing ingredients and provide shopping recommendations
   */
  filterRecipesWithMissingData({
    allRecipes,
    userIngredients,
    filter = "Recommended Recipes",
    preferredTags = [],
    maxCookingTimeMinutes,
    preferredDifficulty,
    dietaryRestrictions,
    maxMissingIngredients = 2,
  }: FilterOptions & { maxMissingIngredients?: number }): RecipeWithMissingIngredients[] {
    
    if (this.DEBUG_MODE) {
      console.log(`🤖 AI Detailed filtering: ${filter} (max missing: ${maxMissingIngredients})`);
      console.log(`📊 Initial recipes: ${allRecipes.length}`);
    }

    const userIngredientLookup = this._createUserIngredientLookup(userIngredients);
    const recipesWithData: RecipeWithMissingIngredients[] = [];

    // Analyze each recipe for missing ingredients
    for (const recipe of allRecipes) {
      const missingIngredients: Array<{ ingredient: any; quantity: number; unit: any }> = [];
      let availableCount = 0;
      let totalCount = 0;

      // Check each ingredient in the recipe
      for (const ri of recipe.ingredients) {
        if (!ri.ingredient) continue;
        totalCount++;

        // Check if user has this ingredient
        let userIng = userIngredientLookup.get(ri.ingredient.id);
        
        if (!userIng) {
          userIng = userIngredients.find(ui => {
            if (ui.ingredient?.id) return false;
            
            if (ui.customIngredient) {
              const recipeName = ri.ingredient.name.toLowerCase().trim();
              const customName = ui.customIngredient.name.toLowerCase().trim();
              return recipeName === customName || recipeName.includes(customName) || customName.includes(recipeName);
            }
            
            return false;
          });
        }

        if (userIng) {
          availableCount++;
        } else {
          missingIngredients.push({
            ingredient: ri.ingredient,
            quantity: ri.quantity,
            unit: ri.unit,
          });
        }
      }

      const missingCount = missingIngredients.length;
      const matchPercentage = totalCount > 0 ? (availableCount / totalCount) * 100 : 0;

      // Apply AI flexible criteria
      const shouldInclude = this._shouldIncludeForAI(
        missingCount, 
        matchPercentage, 
        maxMissingIngredients, 
        totalCount
      );

      if (shouldInclude) {
        recipesWithData.push({
          recipe,
          missingIngredients,
          missingCount,
          availableCount,
          totalCount,
          matchPercentage,
        });
      }
    }

    if (this.DEBUG_MODE) {
      console.log(`🤖 AI Detailed filtering found: ${recipesWithData.length} recipes`);
    }

    // Apply additional filters (tags, time, difficulty, dietary restrictions)
    let filtered = recipesWithData.filter(data => {
      const recipe = data.recipe;
      
      // Tag filtering
      if (preferredTags.length > 0) {
        const recipeTags = recipe.tags?.map(tag => tag.name.toLowerCase()) || [];
        const normalizedPreferredTags = preferredTags.map(tag => tag.toLowerCase());
        const hasMatchingTag = normalizedPreferredTags.every(preferredTag => 
          recipeTags.includes(preferredTag)
        );
        if (!hasMatchingTag) return false;
      }

      // Dietary restrictions
      if (dietaryRestrictions && !this._meetsDietaryRestrictions(recipe, dietaryRestrictions)) {
        return false;
      }

      // Time and difficulty filters (only for non-"With Available Ingredients" filter)
      if (filter !== "With Available Ingredients") {
        if (preferredDifficulty && preferredDifficulty.trim() !== '') {
          if (recipe.difficulty?.toLowerCase() !== preferredDifficulty.toLowerCase()) {
            return false;
          }
        }

        if (maxCookingTimeMinutes !== undefined && maxCookingTimeMinutes !== null && maxCookingTimeMinutes > 0) {
          if (!recipe.cookingTime) return false;
          const cookingTime = this._extractCookingTime(recipe.cookingTime);
          if (cookingTime > maxCookingTimeMinutes) return false;
        }
      }

      return true;
    });

    // Sort by match percentage (best matches first)
    filtered.sort((a, b) => {
      // First sort by missing count (fewer missing = better)
      if (a.missingCount !== b.missingCount) {
        return a.missingCount - b.missingCount;
      }
      // Then by match percentage (higher percentage = better)
      return b.matchPercentage - a.matchPercentage;
    });

    if (this.DEBUG_MODE) {
      console.log(`🤖 After additional filters: ${filtered.length} recipes`);
      filtered.slice(0, 3).forEach(data => {
        console.log(`  📖 "${data.recipe.name}": ${data.availableCount}/${data.totalCount} ingredients (${data.matchPercentage.toFixed(1)}%, missing: ${data.missingCount})`);
      });
    }

    return filtered;
  },

  /**
   * Helper method to determine if a recipe should be included in AI recommendations
   */
  _shouldIncludeForAI(
    missingCount: number, 
    matchPercentage: number, 
    maxMissingIngredients: number, 
    totalIngredients: number
  ): boolean {
    // Don't include recipes with too many missing ingredients
    if (missingCount > maxMissingIngredients) return false;
    
    // Always include recipes with no missing ingredients
    if (missingCount === 0) return true;
    
    // For recipes with missing ingredients, apply percentage thresholds
    if (missingCount === 1) {
      // Allow 1 missing if we have at least 60% of ingredients
      return matchPercentage >= 60;
    } else if (missingCount === 2) {
      // Allow 2 missing if we have at least 70% of ingredients
      return matchPercentage >= 70;
    }
    
    return false;
  },

  // Funciones auxiliares para conversión de unidades
  _areUnitsCompatible(unit1: any, unit2: any): boolean {
    const unit1Type = unit1.type?.toLowerCase();
    const unit2Type = unit2.type?.toLowerCase();
    const unit1Abbr = unit1.abbreviation?.toLowerCase();
    const unit2Abbr = unit2.abbreviation?.toLowerCase();
    
    if (this.DEBUG_MODE) console.log(`      🔍 Checking compatibility: "${unit1Abbr}" (${unit1Type}) vs "${unit2Abbr}" (${unit2Type})`);

    // First try type-based compatibility (preferred method)
    if (unit1Type && unit2Type && unit1Type !== 'other' && unit2Type !== 'other') {
      if (this._areTypesCompatible(unit1Type, unit2Type)) {
        if (this.DEBUG_MODE) console.log(`      ✅ Compatible by type: ${unit1Type} = ${unit2Type}`);
        return true;
      }
    }

    // Fallback to abbreviation-based compatibility for legacy support
    const weightUnits = ['gr', 'g', 'kg', 'oz', 'lb'];
    const volumeUnits = ['ml', 'l', 'tsp', 'tbsp', 'cup', 'fl oz', 'pt', 'qt'];
    const countUnits = ['u', 'unit', 'pcs', 'pc', 'piece', 'pieces', 'doz', 'clove', 'stalk', 'sprig', 'bunch', 'slice'];
    const measureUnits = ['pinch', 'dash', 'to taste'];
    const containerUnits = ['can', 'bottle', 'jar', 'pkg'];

    if (weightUnits.includes(unit1Abbr) && weightUnits.includes(unit2Abbr)) {
      console.log(`      ✅ Both are weight units (by abbreviation)`);
      return true;
    }
    if (volumeUnits.includes(unit1Abbr) && volumeUnits.includes(unit2Abbr)) {
      console.log(`      ✅ Both are volume units (by abbreviation)`);
      return true;
    }
    if (countUnits.includes(unit1Abbr) && countUnits.includes(unit2Abbr)) {
      console.log(`      ✅ Both are count/unit units (by abbreviation)`);
      return true;
    }
    if (measureUnits.includes(unit1Abbr) && measureUnits.includes(unit2Abbr)) {
      console.log(`      ✅ Both are measure units (by abbreviation)`);
      return true;
    }
    if (containerUnits.includes(unit1Abbr) && containerUnits.includes(unit2Abbr)) {
      console.log(`      ✅ Both are container units (by abbreviation)`);
      return true;
    }

    // Special case: Allow weight units to be compatible with measure units for common ingredients
    // This helps with ingredients like salt where users might have kg but recipes call for pinch/tsp
    if ((weightUnits.includes(unit1Abbr) && measureUnits.includes(unit2Abbr)) ||
        (measureUnits.includes(unit1Abbr) && weightUnits.includes(unit2Abbr))) {
      console.log(`      ✅ Weight and measure units are compatible for cooking ingredients`);
      return true;
    }

    // Special case: Allow volume units to be compatible with measure units
    if ((volumeUnits.includes(unit1Abbr) && measureUnits.includes(unit2Abbr)) ||
        (measureUnits.includes(unit1Abbr) && volumeUnits.includes(unit2Abbr))) {
      console.log(`      ✅ Volume and measure units are compatible for cooking ingredients`);
      return true;
    }

    // Special case: Small amounts - allow weight/volume compatibility for cooking seasonings
    // This handles cases like: user has salt in kg, recipe needs salt in tsp
    if (this._isCommonSeasoningCompatibility(unit1Abbr, unit2Abbr)) {
      console.log(`      ✅ Common seasoning units are compatible for cooking flexibility`);
      return true;
    }
    
    console.log(`      ❌ Units are not compatible`);
    console.log(`      📝 Weight units: ${weightUnits.join(', ')}`);
    console.log(`      📝 Volume units: ${volumeUnits.join(', ')}`);
    console.log(`      📝 Count units: ${countUnits.join(', ')}`);
    console.log(`      📝 Measure units: ${measureUnits.join(', ')}`);
    console.log(`      📝 Container units: ${containerUnits.join(', ')}`);
    return false;
  },

  _areTypesCompatible(type1: string, type2: string): boolean {
    if (!type1 || !type2 || type1 === 'other' || type2 === 'other') {
      return false;
    }

    const type1Lower = type1.toLowerCase();
    const type2Lower = type2.toLowerCase();

    // Exact type matches
    if (type1Lower === type2Lower) return true;

    // Count/Quantitative types (server uses 'quantitative', client might use 'count')
    const countTypes = ['count', 'quantitative', 'quantity', 'unit'];
    if (countTypes.includes(type1Lower) && countTypes.includes(type2Lower)) {
      return true;
    }

    // Allow measure type to be compatible with weight and volume for cooking flexibility
    if ((type1Lower === 'measure' && (type2Lower === 'weight' || type2Lower === 'volume')) ||
        (type2Lower === 'measure' && (type1Lower === 'weight' || type1Lower === 'volume'))) {
      return true;
    }

    return false;
  },

  _isCommonSeasoningCompatibility(unit1Abbr: string, unit2Abbr: string): boolean {
    // Allow weight-volume compatibility for common seasonings and small amounts
    // This is specifically for ingredients that are commonly used in small quantities
    // where users might have large amounts (kg) but recipes call for small measures (tsp)
    
    const weightUnits = ['gr', 'g', 'kg'];
    const smallVolumeUnits = ['tsp', 'tbsp']; // Small volume units commonly used for seasonings
    
    return (weightUnits.includes(unit1Abbr) && smallVolumeUnits.includes(unit2Abbr)) ||
           (smallVolumeUnits.includes(unit1Abbr) && weightUnits.includes(unit2Abbr));
  },

  _convertToBase(quantity: number, unit: any): number {
    const conversionFactors: { [key: string]: number } = {
      // Weight units (base: grams)
      'gr': 1,
      'g': 1,
      'kg': 1000,
      'oz': 28.35, // ounce to grams
      'lb': 453.59, // pound to grams

      // Volume units (base: milliliters)
      'ml': 1,
      'l': 1000,
      'tsp': 5,
      'tbsp': 15,
      'cup': 240,
      'fl oz': 29.57, // fluid ounce to ml
      'pt': 473.18, // pint to ml
      'qt': 946.35, // quart to ml

      // Count units (base: pieces)
      'unit': 1,
      'u': 1,
      'pcs': 1,
      'pc': 1, // piece
      'piece': 1,
      'pieces': 1,
      'doz': 12, // dozen
      'clove': 1,
      'stalk': 1,
      'sprig': 1,
      'bunch': 1,
      'slice': 1,

      // Measure units - these are approximate and context-dependent
      // For compatibility, we use reasonable defaults
      'pinch': 0.5, // roughly 0.5g for dry ingredients, 0.5ml for liquids
      'dash': 1, // roughly 1g/1ml
      'to taste': 1, // default to 1 unit

      // Container units - these are very approximate as they vary greatly
      // We use rough averages for common ingredients
      'can': 400, // average can size in ml/g
      'bottle': 500, // average bottle size
      'jar': 250, // average jar size
      'pkg': 100, // average package size
    };

    const unitAbbr = unit.abbreviation?.toLowerCase();
    const factor = conversionFactors[unitAbbr];
    
    console.log(`      🔄 Converting ${quantity} ${unitAbbr} (factor: ${factor})`);
    
    if (factor !== undefined) {
      const result = quantity * factor;
      console.log(`      ➡️ Result: ${result} base units`);
      return result;
    }
    
    // For measure units or special cases, provide a reasonable fallback
    if (unit.type?.toLowerCase() === 'measure') {
      console.log(`      ⚠️ Using default conversion for measure unit "${unitAbbr}"`);
      return quantity; // For measure units, assume 1:1 conversion
    }

    // Handle cross-unit conversions for common seasonings
    // This is approximate but works for cooking purposes
    if (unitAbbr === 'kg' || unitAbbr === 'g') {
      console.log(`      ⚠️ Converting weight unit "${unitAbbr}" for seasoning compatibility`);
      return quantity * (unitAbbr === 'kg' ? 1000 : 1); // Convert to grams base
    }
    
    if (unitAbbr === 'tsp' || unitAbbr === 'tbsp') {
      console.log(`      ⚠️ Converting volume unit "${unitAbbr}" for seasoning compatibility`);
      return quantity * (unitAbbr === 'tbsp' ? 15 : 5); // Convert to ml base
    }
    
    console.log(`      ❌ No conversion factor found for "${unitAbbr}"`);
    console.log(`      📝 Available factors:`, Object.keys(conversionFactors));
    throw new Error(`No conversion factor found for ${unit.abbreviation}`);
  },

  _extractCookingTime(cookingTime: string): number {
    const regex = /(\d+)\s*(h|hour|hours|m|min|minutes)?/gi;
    let totalMinutes = 0;
    let match;

    while ((match = regex.exec(cookingTime)) !== null) {
      const value = parseInt(match[1]);
      const unit = match[2]?.toLowerCase() ?? "";

      if (unit.includes("h")) {
        totalMinutes += value * 60;
      } else {
        totalMinutes += value;
      }
    }
    return totalMinutes;
  },

  /**
   * Checks if a recipe meets dietary restrictions based on all its ingredients
   */
  _meetsDietaryRestrictions(recipe: RecipeDto, restrictions: {
    isVegan?: boolean;
    isVegetarian?: boolean;
    isGlutenFree?: boolean;
    isLactoseFree?: boolean;
  }): boolean {
    console.log(`🥗 Checking dietary restrictions for recipe "${recipe.name}"`);
    console.log(`📋 Restrictions requested:`, restrictions);

    // Check each dietary restriction
    for (const [restriction, required] of Object.entries(restrictions)) {
      if (!required) continue; // Skip if not required

      console.log(`  🔍 Checking ${restriction}...`);

      // All ingredients in the recipe must meet this dietary requirement
      const meetsRestriction = recipe.ingredients.every(ri => {
        if (!ri.ingredient) {
          console.log(`    ⚠️ Ingredient missing for recipe ingredient, assuming safe`);
          return true; // Assume safe if ingredient data is missing
        }

        const ingredient = ri.ingredient;
        let passes = false;

        switch (restriction) {
          case 'isVegan':
            passes = ingredient.isVegan === true;
            break;
          case 'isVegetarian':
            passes = ingredient.isVegetarian === true;
            break;
          case 'isGlutenFree':
            passes = ingredient.isGlutenFree === true;
            break;
          case 'isLactoseFree':
            passes = ingredient.isLactoseFree === true;
            break;
          default:
            passes = true;
        }

        console.log(`    ${passes ? '✅' : '❌'} "${ingredient.name}" - ${restriction}: ${ingredient[restriction as keyof typeof ingredient]}`);
        return passes;
      });

      if (!meetsRestriction) {
        console.log(`  ❌ Recipe "${recipe.name}" does not meet ${restriction} requirement`);
        return false;
      }

      console.log(`  ✅ Recipe "${recipe.name}" meets ${restriction} requirement`);
    }

    console.log(`🎯 Recipe "${recipe.name}" meets all dietary restrictions`);
    return true;
  },
};