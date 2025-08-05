import { RecipeDto } from "../dtos/recipe.dto";
import { UserIngredientOptimizedDto } from "../dtos/user_ing_optimized.dto";
import { RecipeFilterService, RecipeWithMissingIngredients } from "./recipe_filter.service";
import { talk_to_llm_service } from "./llm.service";
import { RecipeTagDto } from "../dtos/recipe_tag.dto";

export interface AIRecommendationOptions {
  userIngredients: UserIngredientOptimizedDto[];
  preferredTags?: string[]; // Tag names as strings (matches Flutter client and DTO)
  maxCookingTimeMinutes?: number;
  preferredDifficulty?: string;
  userPreferences?: string; // Texto libre con preferencias del usuario
  numberOfRecipes?: number; // Cuántas recetas filtrar antes de enviar a IA
  dietaryRestrictions?: {
    isVegan?: boolean;
    isVegetarian?: boolean;
    isGlutenFree?: boolean;
    isLactoseFree?: boolean;
  };
}

export interface AIRecommendationResponse {
  recommendations: string; // Respuesta de la IA
  filteredRecipes: RecipeDto[]; // Recetas que se enviaron a la IA
  totalRecipesConsidered: number; // Total de recetas antes del filtrado
  recipesWithMissingInfo?: RecipeWithMissingIngredients[]; // Detailed missing ingredient info for AI
}

export class AIRecommendationService {
  /**
   * Genera recomendaciones personalizadas usando IA
   * 1. Filtra las recetas basándose en ingredientes y preferencias
   * 2. Toma las primeras N recetas más relevantes
   * 3. Envía a la IA para generar recomendaciones personalizadas
   */
  static async generatePersonalizedRecommendations(
    allRecipes: RecipeDto[],
    options: AIRecommendationOptions
  ): Promise<AIRecommendationResponse> {
    console.log('🤖 Starting AI recommendation generation with flexible filtering...');
    
    // Paso 1: Usar filtrado flexible que permite ingredientes faltantes
    const recipesWithMissingData = RecipeFilterService.filterRecipesWithMissingData({
      allRecipes,
      userIngredients: options.userIngredients,
      filter: "Recommended Recipes", // Usar el filtro recomendado como base
      preferredTags: options.preferredTags || [], // Tag names are already strings
      maxCookingTimeMinutes: options.maxCookingTimeMinutes,
      preferredDifficulty: options.preferredDifficulty,
      dietaryRestrictions: options.dietaryRestrictions,
      maxMissingIngredients: 2, // Allow up to 2 missing ingredients for AI flexibility
    });

    console.log(`📊 AI Flexible filtering: ${allRecipes.length} recipes → ${recipesWithMissingData.length} candidates`);
    
    // Log some statistics about the results
    const perfectMatches = recipesWithMissingData.filter(r => r.missingCount === 0).length;
    const oneIngredientMissing = recipesWithMissingData.filter(r => r.missingCount === 1).length;
    const twoIngredientsMissing = recipesWithMissingData.filter(r => r.missingCount === 2).length;
    
    console.log(`🎯 Recipe breakdown: ${perfectMatches} perfect matches, ${oneIngredientMissing} missing 1 ingredient, ${twoIngredientsMissing} missing 2 ingredients`);

    // Paso 2: Limitar el número de recetas para enviar a la IA
    const numberOfRecipes = options.numberOfRecipes || 10;
    const topRecipesWithData = recipesWithMissingData.slice(0, numberOfRecipes);
    const recipesForAI = topRecipesWithData.map(r => r.recipe);
    
    console.log(`🎯 Sending ${recipesForAI.length} recipes to AI for analysis`);

    // Paso 3: Generar el prompt para la IA con información de ingredientes faltantes
    const prompt = this._buildRecommendationPromptWithMissingData(topRecipesWithData, options);
    console.log('🤖 Prompt:', prompt);

    // Paso 4: Llamar a la IA
    let aiResponse: string;
    try {
      // Check if we have recipes to send to AI
      if (recipesForAI.length === 0) {
        console.log('⚠️ No recipes found after filtering - generating fallback response');
        aiResponse = this._generateNoRecipesResponse(options);
      } else {
        aiResponse = await talk_to_llm_service(prompt);
        console.log('✅ AI response generated successfully');
        console.log('🤖 AI response:', aiResponse);
      }
    } catch (error) {
      console.error('❌ Error calling AI service:', error);
      
      // Provide different fallback based on whether we have recipes
      if (recipesForAI.length > 0) {
        console.log('🔄 Using fallback response with available recipes');
        aiResponse = this._generateFallbackResponseWithMissingData(topRecipesWithData, options);
      } else {
        console.log('🔄 Using no-recipes fallback response');
        aiResponse = this._generateNoRecipesResponse(options);
      }
    }

    return {
      recommendations: aiResponse,
      filteredRecipes: recipesForAI,
      totalRecipesConsidered: allRecipes.length,
      recipesWithMissingInfo: topRecipesWithData, // Include missing ingredient data for frontend
    };
  }

  /**
   * Construye el prompt para la IA basándose en las recetas filtradas y preferencias del usuario
   */
  private static _buildRecommendationPrompt(
    recipes: RecipeDto[],
    options: AIRecommendationOptions
  ): string {
    const userIngredientsList = options.userIngredients
      .map(ui => {
        const name = ui.ingredient?.name || ui.customIngredient?.name || 'Unknown';
        return `${name} (${ui.quantity} ${ui.unit?.abbreviation || 'no unit'})`;
      })
      .join(', ');

    const recipesInfo = recipes.map(recipe => {
      const ingredients = recipe.ingredients
        .map(ri => `${ri.ingredient?.name} (${ri.quantity} ${ri.unit?.abbreviation})`)
        .join(', ');
      
      const tags = recipe.tags?.map(tag => tag.name).join(', ') || 'No tags';

      const steps = recipe.steps.map(step => `- ${step}`).join('\n');
      
      return `
📖 **${recipe.name}**
- ⏱️ Time: ${recipe.cookingTime || 'Not specified'}
- 🎯 Difficulty: ${recipe.difficulty || 'Not specified'}
- 🏷️ Tags: ${tags}
- 🥘 Ingredients: ${ingredients}
- 📝 Description: ${recipe.description}
- 📝 Steps: ${steps}
      `.trim();
    }).join('\n\n');

    const preferences = options.userPreferences 
      ? `\n\n**Additional user preferences:** ${options.userPreferences}`
      : '';

    const prompt = `
You are an expert culinary assistant. Analyze the following recipes and generate personalized recommendations for the user.

**User's available ingredients:**
${userIngredientsList}

**User preferences:**
- Maximum time: ${options.maxCookingTimeMinutes ? `${options.maxCookingTimeMinutes} minutes` : 'No limit'}
- Preferred difficulty: ${options.preferredDifficulty || 'Any'}
- Preferred tags: ${options.preferredTags?.join(', ') || 'Any'}${preferences}

**Available recipes to recommend:**
${recipesInfo}

**Task:**
Generate a personalized response that includes:

1. **Analysis of the best options** based on available ingredients and preferences
2. **Top 3 recommendations** with explanation of why they are ideal
3. **Adaptation suggestions** if some ingredients are missing
4. **Preparation tips** for the recommended recipes

**Response format:**
Respond in a friendly and conversational manner, like an experienced chef advising a friend. Include emojis and be specific about why each recipe is good for this particular user.

**Structure:**
🍳 **Analysis of your options:**
[Brief personalized analysis of what recipes work best with their ingredients]

🥇 **My top 3 recommendations:**

1. **[Recipe Name]** - [Specific reason why it's perfect for this user]
   • ⏱️ **Time:** [cooking time]
   • 🎯 **Why it's great:** [specific benefits for this user's ingredients/preferences]
   • 💡 **Tip:** [helpful preparation or adaptation tip]

2. **[Recipe Name]** - [Specific reason]
   • ⏱️ **Time:** [cooking time]  
   • 🎯 **Why it's great:** [specific benefits]
   • 💡 **Tip:** [helpful tip]

3. **[Recipe Name]** - [Specific reason]
   • ⏱️ **Time:** [cooking time]
   • 🎯 **Why it's great:** [specific benefits]  
   • 💡 **Tip:** [helpful tip]

💡 **Additional suggestions:**
[Any missing ingredient substitutions or cooking tips]

Would you like me to help you with any of these recipes in particular?
    `.trim();

    return prompt;
  }

  /**
   * Construye el prompt para la IA incluyendo información de ingredientes faltantes
   * Permite a la IA sugerir recetas con ingredientes faltantes y dar recomendaciones de compra
   */
  private static _buildRecommendationPromptWithMissingData(
    recipesWithData: RecipeWithMissingIngredients[],
    options: AIRecommendationOptions
  ): string {
    const userIngredientsList = options.userIngredients
      .map(ui => {
        const name = ui.ingredient?.name || ui.customIngredient?.name || 'Unknown';
        return `${name} (${ui.quantity} ${ui.unit?.abbreviation || 'no unit'})`;
      })
      .join(', ');

    const recipesInfo = recipesWithData.map(recipeData => {
      const recipe = recipeData.recipe;
      const ingredients = recipe.ingredients
        .map(ri => `${ri.ingredient?.name} (${ri.quantity} ${ri.unit?.abbreviation})`)
        .join(', ');
      
      const tags = recipe.tags?.map(tag => tag.name).join(', ') || 'No tags';
      const steps = recipe.steps.map(step => `- ${step}`).join('\n');
      
      // Format missing ingredients information
      let missingInfo = '';
      if (recipeData.missingCount > 0) {
        const missingList = recipeData.missingIngredients
          .map(mi => `${mi.ingredient.name} (${mi.quantity} ${mi.unit?.abbreviation || 'units'})`)
          .join(', ');
        missingInfo = `\n- 🛒 **Missing ingredients (${recipeData.missingCount}):** ${missingList}`;
      }
      
      const matchInfo = `\n- 📊 **Ingredient match:** ${recipeData.availableCount}/${recipeData.totalCount} ingredients available (${recipeData.matchPercentage.toFixed(1)}%)`;
      
      return `
📖 **${recipe.name}**
- ⏱️ Time: ${recipe.cookingTime || 'Not specified'}
- 🎯 Difficulty: ${recipe.difficulty || 'Not specified'}
- 🏷️ Tags: ${tags}${matchInfo}${missingInfo}
- 🥘 All ingredients: ${ingredients}
- 📝 Description: ${recipe.description}
- 📝 Steps: ${steps}
      `.trim();
    }).join('\n\n');

    const preferences = options.userPreferences 
      ? `\n\n**Additional user preferences:** ${options.userPreferences}`
      : '';

    const prompt = `
You are an expert culinary assistant with access to recipes that match the user's available ingredients. Some recipes may require 1-2 additional ingredients that the user doesn't have yet.

**User's available ingredients:**
${userIngredientsList}

**User preferences:**
- Maximum time: ${options.maxCookingTimeMinutes ? `${options.maxCookingTimeMinutes} minutes` : 'No limit'}
- Preferred difficulty: ${options.preferredDifficulty || 'Any'}
- Preferred tags: ${options.preferredTags?.join(', ') || 'Any'}${preferences}

**Available recipes (including those with 1-2 missing ingredients):**
${recipesInfo}

**IMPORTANT INSTRUCTIONS:**
- Prioritize recipes where the user has ALL ingredients (0 missing)
- For recipes with missing ingredients, clearly explain what needs to be purchased
- Suggest easy substitutions when possible
- Group recommendations by ingredient availability (perfect matches first)

**Task:**
Generate a personalized response that includes:

1. **Perfect matches** - recipes with all ingredients available
2. **Almost-ready recipes** - recipes needing 1-2 ingredients with shopping suggestions
3. **Smart substitutions** - alternative ingredients the user might have
4. **Shopping recommendations** - specific ingredients to buy for maximum recipe options

**Response format:**
Respond in a friendly and conversational manner, like an experienced chef advising a friend. Include emojis and be specific about ingredient availability and shopping suggestions.

**Structure:**
🍳 **Ready-to-cook recipes**:
[List recipes user can make right now with this format:]
- **Recipe Name**
  - **Time:** [time]
  - **Difficulty:** [difficulty]
  - **Description:** [brief description]

🛒 **Almost-ready recipes**:
[List recipes with missing ingredients and what to buy]

💡 **Smart shopping suggestions**:
[Recommend specific ingredients that unlock multiple recipes with this format:]
- **Ingredient Name**: Description of why it's useful

🔄 **Possible substitutions**:
[Suggest ingredient swaps using what they have with this format:]
- **Original Ingredient**: can be substituted with [alternatives]
    `.trim();

    return prompt;
  }

  /**
   * Generates a fallback response if AI is not available
   */
  private static _generateFallbackResponse(
    recipes: RecipeDto[],
    options: AIRecommendationOptions
  ): string {
    const topRecipes = recipes.slice(0, 3);
    
    const recommendations = topRecipes.map((recipe, index) => {
      const emoji = index === 0 ? '🥇' : index === 1 ? '🥈' : '🥉';
      const cookingTime = recipe.cookingTime || 'Time not specified';
      const difficulty = recipe.difficulty || 'Difficulty not specified';
      
      return `${emoji} **${recipe.name}**
   • ⏱️ **Time:** ${cookingTime}
   • 🎯 **Difficulty:** ${difficulty}  
   • 📝 **Description:** ${recipe.description}`;
    }).join('\n\n');

    return `
🍳 **Recipe Recommendations** (AI temporarily unavailable)

Based on your ingredients and preferences, here are the best matches:

${recommendations}

💡 **Tip:** These recipes were selected using our smart filtering system that matches your available ingredients with recipe requirements. The first option is typically the best match.

🤖 **Note:** Our AI chef is temporarily unavailable, but these recommendations are still highly relevant to your ingredients and preferences!
    `.trim();
  }

  /**
   * Generates a fallback response with missing ingredient data if AI is not available
   */
  private static _generateFallbackResponseWithMissingData(
    recipesWithData: RecipeWithMissingIngredients[],
    options: AIRecommendationOptions
  ): string {
    const perfectMatches = recipesWithData.filter(r => r.missingCount === 0).slice(0, 2);
    const almostReady = recipesWithData.filter(r => r.missingCount > 0 && r.missingCount <= 2).slice(0, 2);
    
    let response = `🍳 **Recipe Recommendations** (AI temporarily unavailable)\n\nBased on your ingredients, here are smart suggestions:\n\n`;

    // Perfect matches section
    if (perfectMatches.length > 0) {
      response += `✅ **Ready to cook right now:**\n\n`;
      perfectMatches.forEach((recipeData, index) => {
        const emoji = index === 0 ? '🥇' : '🥈';
        const recipe = recipeData.recipe;
        response += `${emoji} **${recipe.name}**\n`;
        response += `   • ⏱️ **Time:** ${recipe.cookingTime || 'Not specified'}\n`;
        response += `   • 🎯 **Difficulty:** ${recipe.difficulty || 'Not specified'}\n`;
        response += `   • ✅ **All ingredients available!**\n\n`;
      });
    }

    // Almost ready section
    if (almostReady.length > 0) {
      response += `🛒 **Almost ready** (just need to buy a few things):\n\n`;
      almostReady.forEach((recipeData, index) => {
        const emoji = index === 0 ? '🥉' : '🔸';
        const recipe = recipeData.recipe;
        const missingList = recipeData.missingIngredients
          .map(mi => mi.ingredient.name)
          .join(', ');
        
        response += `${emoji} **${recipe.name}**\n`;
        response += `   • ⏱️ **Time:** ${recipe.cookingTime || 'Not specified'}\n`;
        response += `   • 🛒 **Need to buy:** ${missingList}\n`;
        response += `   • 📊 **Match:** ${recipeData.matchPercentage.toFixed(0)}% of ingredients available\n\n`;
      });
    }

    response += `💡 **Tip:** Our smart filtering found recipes that work well with your available ingredients. Perfect matches are ready to cook immediately, while "almost ready" recipes only need 1-2 additional ingredients.\n\n`;
    response += `🤖 **Note:** Our AI chef is temporarily unavailable, but these recommendations are based on intelligent ingredient matching and are highly relevant to what you have!`;

    return response;
  }

  /**
   * Generates a response when no recipes match the user's criteria
   */
  private static _generateNoRecipesResponse(
    options: AIRecommendationOptions
  ): string {
    const userIngredientsList = options.userIngredients
      .map(ui => ui.ingredient?.name || ui.customIngredient?.name || 'Unknown')
      .join(', ');

    const suggestions = [];
    
    if (options.preferredTags && options.preferredTags.length > 0) {
      suggestions.push(`Try removing some tag filters: ${options.preferredTags.join(', ')}`);
    }
    
    if (options.maxCookingTimeMinutes && options.maxCookingTimeMinutes < 30) {
      suggestions.push(`Consider increasing the maximum cooking time (currently ${options.maxCookingTimeMinutes} minutes)`);
    }
    
    if (options.preferredDifficulty && options.preferredDifficulty !== 'Easy') {
      suggestions.push(`Try changing the difficulty preference (currently ${options.preferredDifficulty})`);
    }

    const suggestionText = suggestions.length > 0 
      ? `\n\n💡 **Suggestions to find recipes:**\n• ${suggestions.join('\n• ')}`
      : '\n\n💡 **Suggestion:** Try adjusting your filters or adding more common ingredients to your cupboard.';

    return `
🍳 **No Matching Recipes Found**

I couldn't find any recipes that match your current criteria with the ingredients you have:

**Your ingredients:** ${userIngredientsList}

**Your preferences:**
• Maximum time: ${options.maxCookingTimeMinutes ? `${options.maxCookingTimeMinutes} minutes` : 'No limit'}
• Difficulty: ${options.preferredDifficulty || 'Any'}
• Tags: ${options.preferredTags?.join(', ') || 'Any'}${suggestionText}

🛒 **Alternative:** Consider adding some basic pantry staples like flour, eggs, or oil to unlock more recipe possibilities!
    `.trim();
  }
} 