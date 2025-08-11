import { RecipeDto } from "../dtos/recipe.dto";
import { UserIngredientOptimizedDto } from "../dtos/user_ing_optimized.dto";
import { Recipe } from "../entities/Recipe";
import { RecipeRepository } from "../repositories/recipe.repository";
import { RecipeFilterService } from "./recipe_filter.service";

export const getRecipesService = async (): Promise<Recipe[]> => {
  return await RecipeRepository.find({
    relations: {
      ingredients: {
        ingredient: true,
        unit: true,
      },
      tags: true,
      createdByUser: true,
    },
  });
};

export const getMissingIngredientsByRecipeService = async (
  serializedRecipes: RecipeDto[],
  userIng: UserIngredientOptimizedDto[]
): Promise<{
  recipeId: number;
  missingIngredients: Array<{ ingredient: any; quantity: number; unit: any }>;
  missingCount: number;
}[]> => {
  const userIngredientIds = new Set<number>(
    userIng
      .map((ui) => ui.ingredient?.id)
      .filter((id): id is number => typeof id === "number")
  );

  const userCustomIngredientNames = new Set<string>(
    userIng
      .map((ui) => ui.customIngredient?.name?.toLowerCase().trim())
      .filter((n): n is string => !!n && n.length > 0)
  );

  const response: {
    recipeId: number;
    missingIngredients: Array<{ ingredient: any; quantity: number; unit: any }>;
    missingCount: number;
  }[] = [];

  // Build a fast lookup map for user's global ingredients
  const userIngredientLookup = RecipeFilterService._createUserIngredientLookup(userIng);

  for (const recipe of serializedRecipes) {
    const missing: Array<{ ingredient: any; quantity: number; unit: any }> = [];

    for (const ri of recipe.ingredients) {
      if (!ri?.ingredient) continue;
      const ingId = ri.ingredient.id;
      const ingName = ri.ingredient.name?.toLowerCase().trim();

      // Try to find matching user ingredient (global fast lookup)
      let userIngredient = userIngredientLookup.get(ingId);

      // If not found, try custom ingredient fuzzy name matching
      if (!userIngredient && ingName) {
        userIngredient = userIng.find((ui) => {
          if (ui.ingredient?.id) return false;
          const customName = ui.customIngredient?.name?.toLowerCase().trim();
          if (!customName) return false;
          return customName === ingName || customName.includes(ingName) || ingName.includes(customName);
        });
      }

      if (!userIngredient) {
        // User doesn't have this ingredient at all
        missing.push({ ingredient: ri.ingredient, quantity: ri.quantity, unit: ri.unit });
        continue;
      }

      // If either side lacks unit, consider it missing (cannot validate quantity)
      if (!userIngredient.unit || !ri.unit) {
        missing.push({ ingredient: ri.ingredient, quantity: ri.quantity, unit: ri.unit });
        continue;
      }

      // Units must be compatible
      const compatible = RecipeFilterService._areUnitsCompatible(userIngredient.unit, ri.unit);
      if (!compatible) {
        missing.push({ ingredient: ri.ingredient, quantity: ri.quantity, unit: ri.unit });
        continue;
      }

      // Compare quantities in base units
      try {
        const userAmountBase = RecipeFilterService._convertToBase(userIngredient.quantity, userIngredient.unit);
        const recipeAmountBase = RecipeFilterService._convertToBase(ri.quantity, ri.unit);
        const hasEnough = userAmountBase >= recipeAmountBase;
        if (!hasEnough) {
          missing.push({ ingredient: ri.ingredient, quantity: ri.quantity, unit: ri.unit });
        }
      } catch {
        // If conversion fails, treat as missing
        missing.push({ ingredient: ri.ingredient, quantity: ri.quantity, unit: ri.unit });
      }
    }

    response.push({ recipeId: recipe.id, missingIngredients: missing, missingCount: missing.length });
  }

  return response;
};