import { Recipe } from "../entities/Recipe";
import { RecipeRepository } from "../repositories/recipe.repository";

export const getRecipesService = async (): Promise<Recipe[]> => {
  return await RecipeRepository.find({
    relations: {
      ingredients: {
        ingredient: true,
        unit: true,
      },
      tags: true,
    //   createdByUser: true,
    },
  });
};