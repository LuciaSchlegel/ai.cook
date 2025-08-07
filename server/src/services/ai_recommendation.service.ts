import { RecipeDto } from "../dtos/recipe.dto";
import { UserIngredientOptimizedDto } from "../dtos/user_ing_optimized.dto";
import { RecipeFilterService, RecipeWithMissingIngredients } from "./recipe_filter.service";
import { talk_to_llm_service } from "./llm.service";
import { AIAlmostReadyRecipeDto, AIRecipeMinimalDto, AIRecommendationResponseDto, AIShoppingSuggestionDto, AISubstitutionDto } from "../dtos/ai_recommendation.dto";

export interface AIRecommendationOptions {
  userIngredients: UserIngredientOptimizedDto[];
  preferredTags?: string[];
  maxCookingTimeMinutes?: number;
  preferredDifficulty?: string;
  userPreferences?: string;
  numberOfRecipes?: number;
  dietaryRestrictions?: {
    isVegan?: boolean;
    isVegetarian?: boolean;
    isGlutenFree?: boolean;
    isLactoseFree?: boolean;
  };
}

export class AIRecommendationService {
  /**
   * Genera recomendaciones personalizadas usando IA con respuesta JSON estructurada
   */
  static async generatePersonalizedRecommendations(
    allRecipes: RecipeDto[],
    options: AIRecommendationOptions
  ): Promise<AIRecommendationResponseDto> {
    console.log('🤖 Starting AI recommendation generation with JSON response...');
    
    // Paso 1: Usar filtrado flexible que permite ingredientes faltantes
    const recipesWithMissingData = RecipeFilterService.filterRecipesWithMissingData({
      allRecipes,
      userIngredients: options.userIngredients,
      filter: "Recommended Recipes",
      preferredTags: options.preferredTags || [],
      maxCookingTimeMinutes: options.maxCookingTimeMinutes,
      preferredDifficulty: options.preferredDifficulty,
      dietaryRestrictions: options.dietaryRestrictions,
      maxMissingIngredients: 2,
    });

    console.log(`📊 AI Flexible filtering: ${allRecipes.length} recipes → ${recipesWithMissingData.length} candidates`);
    
    const perfectMatches = recipesWithMissingData.filter(r => r.missingCount === 0).length;
    const oneIngredientMissing = recipesWithMissingData.filter(r => r.missingCount === 1).length;
    const twoIngredientsMissing = recipesWithMissingData.filter(r => r.missingCount === 2).length;
    
    console.log(`🎯 Recipe breakdown: ${perfectMatches} perfect matches, ${oneIngredientMissing} missing 1 ingredient, ${twoIngredientsMissing} missing 2 ingredients`);

    // Paso 2: Limitar el número de recetas para enviar a la IA
    const numberOfRecipes = options.numberOfRecipes || 10;
    const topRecipesWithData = recipesWithMissingData.slice(0, numberOfRecipes);
    const recipesForAI = topRecipesWithData.map(r => r.recipe);
    
    console.log(`🎯 Sending ${recipesForAI.length} recipes to AI for JSON analysis`);

    // Paso 3: Generar el prompt para la IA con formato JSON
    const prompt = this._buildJSONRecommendationPrompt(topRecipesWithData, options);
    
    // Paso 4: Llamar a la IA
    let aiResponse: AIRecommendationResponseDto;
    try {
      if (recipesForAI.length === 0) {
        console.log('⚠️ No recipes found after filtering - generating fallback JSON response');
        aiResponse = this._generateNoRecipesJSONResponse(options);
      } else {
        const rawResponse = await talk_to_llm_service(prompt);
        console.log('✅ AI JSON response generated successfully');
        
        // Parse the JSON response from AI
        try {
          // Extract JSON from the response (in case AI adds extra text)
          const jsonMatch = rawResponse.match(/\{[\s\S]*\}/);
          if (jsonMatch) {
            const parsedResponse = JSON.parse(jsonMatch[0]);
            aiResponse = {
              ...parsedResponse,
              filteredRecipes: recipesForAI,
              totalRecipesConsidered: allRecipes.length,
              recipesWithMissingInfo: topRecipesWithData,
            };
          } else {
            throw new Error('No valid JSON found in AI response');
          }
        } catch (parseError) {
          console.error('❌ Error parsing AI JSON response:', parseError);
          console.log('🔄 Using fallback JSON response');
          aiResponse = this._generateFallbackJSONResponse(topRecipesWithData, options);
        }
      }
    } catch (error) {
      console.error('❌ Error calling AI service:', error);
      
      if (recipesForAI.length > 0) {
        console.log('🔄 Using fallback JSON response with available recipes');
        aiResponse = this._generateFallbackJSONResponse(topRecipesWithData, options);
      } else {
        console.log('🔄 Using no-recipes fallback JSON response');
        aiResponse = this._generateNoRecipesJSONResponse(options);
      }
    }

    return aiResponse;
  }

  /**
   * Construye el prompt para que la IA devuelva JSON estructurado
   */
  private static _buildJSONRecommendationPrompt(
    recipesWithData: RecipeWithMissingIngredients[],
    options: AIRecommendationOptions
  ): string {
    const userIngredientsList = options.userIngredients
      .map(ui => {
        const name = ui.ingredient?.name || ui.customIngredient?.name || 'Unknown';
        return `${name} (${ui.quantity} ${ui.unit?.abbreviation || 'no unit'})`;
      })
      .join(', ');

    // Build recipes data for AI
    const recipesData = recipesWithData.map(recipeData => {
      const recipe = recipeData.recipe;
      return {
        name: recipe.name,
        cookingTime: recipe.cookingTime,
        difficulty: recipe.difficulty,
        tags: recipe.tags?.map(tag => tag.name) || [],
        description: recipe.description,
        ingredients: recipe.ingredients.map(ri => ({
          name: ri.ingredient?.name || 'Unknown',
          quantity: `${ri.quantity} ${ri.unit?.abbreviation || 'units'}`
        })),
        steps: recipe.steps,
        missingCount: recipeData.missingCount,
        missingIngredients: recipeData.missingIngredients.map(mi => ({
          name: mi.ingredient.name,
          quantity: `${mi.quantity} ${mi.unit?.abbreviation || 'units'}`
        })),
        matchPercentage: recipeData.matchPercentage
      };
    });

    const preferences = options.userPreferences 
      ? `\n\nAdditional user preferences: ${options.userPreferences}`
      : '';

    const prompt = `
You are an expert culinary assistant. Analyze the provided recipes and generate personalized recommendations in JSON format.

**User's available ingredients:**
${userIngredientsList}

**User preferences:**
- Maximum time: ${options.maxCookingTimeMinutes ? `${options.maxCookingTimeMinutes} minutes` : 'No limit'}
- Preferred difficulty: ${options.preferredDifficulty || 'Any'}
- Preferred tags: ${options.preferredTags?.join(', ') || 'Any'}${preferences}

**Available recipes data:**
${JSON.stringify(recipesData, null, 2)}

**CRITICAL: You must respond with ONLY a valid JSON object following this exact structure:**

{
  "ready_to_cook": [
    {
      "title": "Recipe Name",
      "time_minutes": 30,
      "difficulty": "Easy",
      "tags": ["tag1", "tag2"],
      "description": "Brief description why this recipe is perfect for the user",
      "ingredients": [
        {"name": "ingredient name", "quantity": "amount unit"}
      ],
      "steps": ["step 1", "step 2", "step 3"]
    }
  ],
  "almost_ready": [
    {
      "title": "Recipe Name",
      "description": "Brief description and why it's good for the user",
      "time_minutes": 30,
      "difficulty": "Easy",
      "tags": ["tag1", "tag2"],
      "missing_ingredients": ["ingredient1", "ingredient2"],
      "shopping_suggestions": [
        {"name": "ingredient", "reason": "why this ingredient is valuable"}
      ]
    }
  ],
  "shopping_suggestions": [
    {
      "name": "ingredient name",
      "reason": "why buying this ingredient unlocks multiple recipes or is versatile"
    }
  ],
  "possible_substitutions": [
    {
      "original": "original ingredient",
      "alternatives": ["alternative1", "alternative2", "alternative3"]
    }
  ]
}

**Instructions:**
1. Prioritize recipes with 0 missing ingredients for "ready_to_cook"
2. Include recipes with 1-2 missing ingredients in "almost_ready"
3. Suggest versatile ingredients in "shopping_suggestions" that unlock multiple recipes
4. Provide practical substitutions using ingredients the user likely has
5. Focus on recipes that match user preferences (time, difficulty, tags)
6. Keep descriptions concise but personalized
7. Convert cooking times to minutes (numbers only)
8. Extract actual recipe steps from the provided data

**IMPORTANT: Return ONLY the JSON object, no additional text, markdown, or explanations.**
    `.trim();

    return prompt;
  }

  /**
   * Genera respuesta JSON de fallback cuando la IA no está disponible
   */
  private static _generateFallbackJSONResponse(
    recipesWithData: RecipeWithMissingIngredients[],
    options: AIRecommendationOptions
  ): AIRecommendationResponseDto {
    const perfectMatches = recipesWithData.filter(r => r.missingCount === 0).slice(0, 3);
    const almostReady = recipesWithData.filter(r => r.missingCount > 0 && r.missingCount <= 2).slice(0, 2);

    const ready_to_cook: AIRecipeMinimalDto[] = perfectMatches.map(recipeData => {
      const recipe = recipeData.recipe;
      return {
        title: recipe.name,
        time_minutes: this._extractTimeInMinutes(recipe.cookingTime || ''),
        difficulty: recipe.difficulty || 'Not specified',
        tags: recipe.tags?.map(tag => tag.name) || [],
        description: `Perfect match! You have all ingredients for this delicious ${recipe.difficulty?.toLowerCase() || ''} recipe.`,
        ingredients: recipe.ingredients.map(ri => ({
          name: ri.ingredient?.name || 'Unknown',
          quantity: `${ri.quantity} ${ri.unit?.abbreviation || 'units'}`
        })),
        steps: recipe.steps || []
      };
    });

    const almost_ready: AIAlmostReadyRecipeDto[] = almostReady.map(recipeData => {
      const recipe = recipeData.recipe;
      const missingList = recipeData.missingIngredients.map(mi => mi.ingredient.name);
      
      return {
        title: recipe.name,
        description: `${recipeData.matchPercentage.toFixed(0)}% ingredient match - just need a few items from the store!`,
        missing_ingredients: missingList,
        shopping_suggestions: missingList.map(ingredient => ({
          name: ingredient,
          reason: `Essential for ${recipe.name}`
        }))
      };
    });

    // Extract common missing ingredients for shopping suggestions
    const allMissingIngredients = almostReady.flatMap(recipe => recipe.missingIngredients);
    const ingredientCounts = allMissingIngredients.reduce((acc, item) => {
      const name = item.ingredient?.name ?? 'Unknown'
      acc[name] = (acc[name] || 0) + 1;
      return acc;
    }, {} as Record<string, number>);
    
    const shopping_suggestions: AIShoppingSuggestionDto[] = Object.entries(ingredientCounts)
      .sort(([,a], [,b]) => b - a)
      .slice(0, 3)
      .map(([ingredient, count]) => ({
        name: ingredient,
        reason: count > 1 ? `Unlocks ${count} recipes` : 'Versatile ingredient for cooking'
      }));

    const possible_substitutions: AISubstitutionDto[] = [
      {
        original: "Butter",
        alternatives: ["Olive oil", "Coconut oil", "Margarine"]
      },
      {
        original: "Milk",
        alternatives: ["Almond milk", "Oat milk", "Coconut milk"]
      }
    ];

    return {
      ready_to_cook,
      almost_ready,
      shopping_suggestions,
      possible_substitutions,
      filteredRecipes: recipesWithData.map(r => r.recipe),
      totalRecipesConsidered: 0,
      recipesWithMissingInfo: recipesWithData
    };
  }

  /**
   * Genera respuesta JSON cuando no hay recetas disponibles
   */
  private static _generateNoRecipesJSONResponse(
    options: AIRecommendationOptions
  ): AIRecommendationResponseDto {
    return {
      ready_to_cook: [],
      almost_ready: [],
      shopping_suggestions: [
        {
          name: "Flour",
          reason: "Basic ingredient that unlocks many baking and cooking recipes"
        },
        {
          name: "Eggs",
          reason: "Versatile protein source for countless dishes"
        },
        {
          name: "Olive oil",
          reason: "Essential cooking oil for most recipes"
        }
      ],
      possible_substitutions: [
        {
          original: "Butter",
          alternatives: ["Olive oil", "Coconut oil", "Margarine"]
        }
      ],
      filteredRecipes: [],
      totalRecipesConsidered: 0
    };
  }

  /**
   * Extrae el tiempo en minutos de un string de tiempo
   */
  private static _extractTimeInMinutes(timeString: string): number {
    if (!timeString) return 0;
    
    const minutesMatch = timeString.match(/(\d+)\s*(?:min|minute)/i);
    if (minutesMatch) {
      return parseInt(minutesMatch[1]);
    }
    
    const hoursMatch = timeString.match(/(\d+)\s*(?:h|hour)/i);
    if (hoursMatch) {
      return parseInt(hoursMatch[1]) * 60;
    }
    
    // Try to extract any number
    const numberMatch = timeString.match(/(\d+)/);
    if (numberMatch) {
      return parseInt(numberMatch[1]);
    }
    
    return 0;
  }
}