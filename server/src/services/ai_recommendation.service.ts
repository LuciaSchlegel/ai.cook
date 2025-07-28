import { RecipeDto } from "../dtos/recipe.dto";
import { RecipeTagDto } from "../dtos/recipe_tag.dto";
import { UserIngredientDto } from "../dtos/user_ing.dto";
import { RecipeFilterService } from "./recipe_filter.service";
import { talk_to_llm_service } from "./llm.service";

export interface AIRecommendationOptions {
  userIngredients: UserIngredientDto[];
  preferredTags?: RecipeTagDto[];
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
      filter: "Recommended", // Usar el filtro recomendado como base
      preferredTags: options.preferredTags?.map(tag => tag.name) || [],
      maxCookingTimeMinutes: options.maxCookingTimeMinutes,
      preferredDifficulty: options.preferredDifficulty,
    });

    console.log(`📊 Filtered ${allRecipes.length} recipes to ${filteredRecipes.length}`);

    // Paso 2: Limitar el número de recetas para enviar a la IA
    const numberOfRecipes = options.numberOfRecipes || 10;
    const recipesForAI = filteredRecipes.slice(0, numberOfRecipes);

    console.log(`🎯 Sending ${recipesForAI.length} recipes to AI for analysis`);

    // Paso 3: Generar el prompt para la IA
    const prompt = this._buildRecommendationPrompt(recipesForAI, options);

    // Paso 4: Llamar a la IA
    let aiResponse: string;
    try {
      aiResponse = await talk_to_llm_service(prompt);
      console.log('✅ AI response generated successfully');
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
      
      const tags = recipe.tags?.map(tag => tag.name).join(', ') || 'Sin etiquetas';
      
      return `
📖 **${recipe.name}**
- ⏱️ Tiempo: ${recipe.cookingTime || 'No especificado'}
- 🎯 Dificultad: ${recipe.difficulty || 'No especificado'}
- 🏷️ Etiquetas: ${tags}
- 🥘 Ingredientes: ${ingredients}
- 📝 Descripción: ${recipe.description}
      `.trim();
    }).join('\n\n');

    const preferences = options.userPreferences 
      ? `\n\n**Preferencias adicionales del usuario:** ${options.userPreferences}`
      : '';

    const prompt = `
Eres un asistente culinario experto. Analiza las siguientes recetas y genera recomendaciones personalizadas para el usuario.

**Ingredientes disponibles del usuario:**
${userIngredientsList}

**Preferencias del usuario:**
- Tiempo máximo: ${options.maxCookingTimeMinutes ? `${options.maxCookingTimeMinutes} minutos` : 'Sin límite'}
- Dificultad preferida: ${options.preferredDifficulty || 'Cualquiera'}
- Etiquetas preferidas: ${options.preferredTags?.join(', ') || 'Cualquiera'}${preferences}

**Recetas disponibles para recomendar:**
${recipesInfo}

**Tarea:**
Genera una respuesta personalizada que incluya:

1. **Análisis de las mejores opciones** basado en los ingredientes disponibles y preferencias
2. **Top 3 recomendaciones** con explicación de por qué son ideales
3. **Sugerencias de adaptación** si faltan algunos ingredientes
4. **Consejos de preparación** para las recetas recomendadas
5. **Alternativas** si ninguna receta es perfecta

**Formato de respuesta:**
Responde de manera amigable y conversacional, como un chef experimentado aconsejando a un amigo. Incluye emojis y sé específico sobre por qué cada receta es buena para este usuario en particular.

**Ejemplo de estructura:**
🍳 **Análisis de tus opciones:**
[Análisis personalizado]

🥇 **Mis top 3 recomendaciones:**
1. [Receta] - [Razón específica]
2. [Receta] - [Razón específica]  
3. [Receta] - [Razón específica]

💡 **Consejos y adaptaciones:**
[Sugerencias específicas]

¿Te gustaría que te ayude con alguna de estas recetas en particular?
    `.trim();

    return prompt;
  }

  /**
   * Genera una respuesta de fallback si la IA no está disponible
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
🍳 **Recomendaciones basadas en tus ingredientes:**

${recommendations}

💡 **Consejo:** Estas recetas son las que mejor se adaptan a los ingredientes que tienes disponibles. Te recomiendo empezar con la primera opción.

¿Te gustaría ver más detalles de alguna de estas recetas?
    `.trim();
  }
} 