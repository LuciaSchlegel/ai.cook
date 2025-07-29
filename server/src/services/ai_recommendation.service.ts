import { RecipeDto } from "../dtos/recipe.dto";
import { RecipeTagDto } from "../dtos/recipe_tag.dto";
import { UserIngredientDto } from "../dtos/user_ing.dto";
import { RecipeFilterService } from "./recipe_filter.service";
import { talk_to_llm_service } from "./llm.service";

export interface AIRecommendationOptions {
  userIngredients: UserIngredientDto[];
  preferredTags?: string[];
  maxCookingTimeMinutes?: number;
  preferredDifficulty?: string;
  userPreferences?: string; // Texto libre con preferencias del usuario
  numberOfRecipes?: number; // Cuántas recetas filtrar antes de enviar a IA
}

export interface AIRecommendationResponse {
  recommendations: string; // Respuesta de la IA
  filteredRecipes: RecipeDto[]; // Recetas que se enviaron a la IA
  totalRecipesConsidered: number; // Total de recetas antes del filtrado
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
    console.log('🤖 Starting AI recommendation generation...');
    
    // Paso 1: Filtrar recetas usando la lógica existente
    const filteredRecipes = RecipeFilterService.filterRecipes({
      allRecipes,
      userIngredients: options.userIngredients,
      filter: "Recommended Recipes", // Usar el filtro recomendado como base
      preferredTags: options.preferredTags || [],
      maxCookingTimeMinutes: options.maxCookingTimeMinutes,
      preferredDifficulty: options.preferredDifficulty,
    });

    console.log(`📊 Filtered ${allRecipes.length} recipes to ${filteredRecipes.length}`);

    // Paso 2: Limitar el número de recetas para enviar a la IA
    const numberOfRecipes = options.numberOfRecipes || 10;
    const recipesForAI = filteredRecipes.slice(0, numberOfRecipes);
    console.log('🎯 Recipes for AI:', recipesForAI);

    console.log(`🎯 Sending ${recipesForAI.length} recipes to AI for analysis`);

    // Paso 3: Generar el prompt para la IA
    const prompt = this._buildRecommendationPrompt(recipesForAI, options);
    console.log('🤖 Prompt:', prompt);

    // Paso 4: Llamar a la IA
    let aiResponse: string;
    try {
      aiResponse = await talk_to_llm_service(prompt);
      console.log('✅ AI response generated successfully');
      console.log('🤖 AI response:', aiResponse);
    } catch (error) {
      console.error('❌ Error calling AI service:', error);
      aiResponse = this._generateFallbackResponse(recipesForAI, options);
    }

    return {
      recommendations: aiResponse,
      filteredRecipes: recipesForAI,
      totalRecipesConsidered: allRecipes.length,
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
      .map(ui => `${ui.ingredient?.name} (${ui.quantity} ${ui.unit?.abbreviation})`)
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
5. **Alternatives** if no recipe is perfect

**Response format:**
Respond in a friendly and conversational manner, like an experienced chef advising a friend. Include emojis and be specific about why each recipe is good for this particular user.
Please respond with a valid JSON object with the following structure for each recipe:
{{
    "title": "Recipe Name",
    "ingredients": ["ingredient 1", "ingredient 2", "..."],
    "instructions": ["step 1", "step 2", "..."],
    "cookingTime": "30 minutes",
    "servings": "4 people",
    "servingSuggestion": "Serve with..."
}}

**Structure example:**
🍳 **Analysis of your options:**
[Personalized analysis]

🥇 **My top 3 recommendations:**
1. [Recipe] - [Specific reason]
[Recipe 1 JSON Object]
2. [Recipe] - [Specific reason]  
[Recipe 2 JSON Object]
3. [Recipe] - [Specific reason]
[Recipe 3 JSON Object]

💡 **Tips and adaptations:**
[Specific suggestions]

Would you like me to help you with any of these recipes in particular?
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
      return `${emoji} **${recipe.name}** - ${recipe.description}`;
    }).join('\n\n');

    return `
🍳 **Recommendations based on your ingredients:**

${recommendations}

💡 **Tip:** These recipes are the ones that best match the ingredients you have available. I recommend starting with the first option.

Would you like to see more details of any of these recipes?
    `.trim();
  }
} 