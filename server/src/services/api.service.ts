import axios from "axios";
import { GetRecipeParams, RecipeSearchParams } from "../controllers/api.controller";
import { ExternalRecipePreviewDto } from "../dtos/ext_recipe_prev.dto";
import { ExternalRecipeStepsDto } from "../dtos/ext_recipe_steps";
import { ExternalRecipeFullDto } from "../dtos/ext_recipe_full.dto";

const apiKey = process.env.SPOONACULAR_API_KEY;
const baseUrl = "https://api.spoonacular.com/recipes";

type CachedRecipeSteps = {
  data: ExternalRecipeFullDto;
  timestamp: number; // epoch ms
};

const cache = new Map<number, CachedRecipeSteps>();
const TTL = 1000 * 60 * 60 * 6; // 6 horas

export async function searchExternalRecipesService(
  params: RecipeSearchParams
): Promise<{ results: ExternalRecipePreviewDto[] }> {
  const searchResponse = await axios.get(`${baseUrl}/complexSearch`, {
    params: {
      ...params,
      instructionsRequired: true,
      addRecipeInformation: true, // trae info parcial
      apiKey,
    },
  });

  const rawResults = searchResponse.data.results || [];

  const results: ExternalRecipePreviewDto[] = await Promise.all(
    rawResults.map(async (r: any) => {
      let extendedIngredients: ExternalRecipePreviewDto["extendedIngredients"] = [];

      try {
        const detailResponse = await axios.get(`${baseUrl}/${r.id}/information`, {
          params: {
            includeNutrition: false,
            apiKey,
          },
        });

        const full = detailResponse.data;
        if (full.extendedIngredients?.length) {
          extendedIngredients = full.extendedIngredients.map((i: any) => ({
            id: i.id,
            name: i.name,
            original: i.original,
            amount: i.measures?.metric?.amount ?? 0,
            unit: i.measures?.metric?.unitShort ?? '',
          }));
        }
      } catch (err) {
        console.warn(`Failed to fetch extendedIngredients for recipe ${r.id}`);
      }

      return {
        id: r.id,
        title: r.title,
        image: r.image,
        readyInMinutes: r.readyInMinutes,
        servings: r.servings,
        cuisines: r.cuisines ?? [],
        dishTypes: r.dishTypes ?? [],
        diets: r.diets ?? [],
        extendedIngredients,
      };
    })
  );

  return { results };
}

export async function getRecipeStepsService(
  params: GetRecipeParams
): Promise<ExternalRecipeStepsDto | null> {
  const cached = cache.get(params.recipeId);
  const now = Date.now();

  if (cached && now - cached.timestamp < TTL) {
    return {
      id: cached.data.id,
      steps: cached.data.steps,
    };
  }

  try {
    const response = await axios.get(`${baseUrl}/${params.recipeId}/information`, {
      params: { includeNutrition: false, apiKey },
    });

    const r = response.data;

    if (!r.analyzedInstructions?.length || !r.analyzedInstructions[0].steps?.length) {
      return null;
    }

    const steps = r.analyzedInstructions[0].steps.map((s: any) => ({
      number: s.number,
      step: s.step,
    }));

    const fullRecipe: ExternalRecipeFullDto = {
      id: r.id,
      title: r.title,
      image: r.image,
      readyInMinutes: r.readyInMinutes,
      servings: r.servings,
      cuisines: r.cuisines ?? [],
      dishTypes: r.dishTypes ?? [],
      diets: r.diets ?? [],
      extendedIngredients: r.extendedIngredients.map((i: any) => ({
        id: i.id,
        name: i.name,
        original: i.original,
        amount: i.measures?.metric?.amount ?? 0,
        unit: i.measures?.metric?.unitShort ?? '',
      })),
      steps,
    };

    cache.set(r.id, { data: fullRecipe, timestamp: now });

    return {
      id: r.id,
      steps,
    };
  } catch (error) {
    console.warn(`Error fetching recipe steps for ID ${params.recipeId}`);
    return null;
  }
}