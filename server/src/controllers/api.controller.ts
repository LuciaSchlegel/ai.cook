import { Request } from "express";
import {
  getRecipeStepsService,
  searchExternalRecipesService,
  searchExtRecipesByIngService,
} from "../services/api.service";
import { controllerWrapper } from "../helpers/controllerWrapper";
import { BadRequestError } from "../types/AppError";

export interface RecipeSearchParams {
  query?: string;
  cuisine?: string;
  diet?: string;
  intolerances?: string;
  includeIngredients?: string;
  excludeIngredients?: string;
  type?: string;
  maxReadyTime?: number;
  number?: number;
  minCalories?: number;
  maxCalories?: number;
  minProtein?: number;
  maxProtein?: number;
  minCarbs?: number;
  maxCarbs?: number;
  minFat?: number;
  maxFat?: number;
}

export interface GetRecipeParams {
  recipeId: number;
}

export interface IngRecipeSearchParams {
  ingredients?: string;
  number?: number;
}

export const searchExternalRecipesController = controllerWrapper(
  async (req: Request) => {
    const {
      query,
      cuisine,
      diet,
      intolerances,
      includeIngredients,
      excludeIngredients,
      type,
      maxReadyTime,
      number,
      minCalories,
      maxCalories,
      minProtein,
      maxProtein,
      minCarbs,
      maxCarbs,
      minFat,
      maxFat,
    } = req.query as Partial<RecipeSearchParams>;

    const params: RecipeSearchParams = {
      query,
      cuisine,
      diet,
      intolerances,
      includeIngredients,
      excludeIngredients,
      type,
      maxReadyTime: maxReadyTime ? Number(maxReadyTime) : undefined,
      number: number ? Number(number) : 10,
      minCalories: isNaN(Number(minCalories)) ? undefined : Number(minCalories),
      maxCalories: isNaN(Number(maxCalories)) ? undefined : Number(maxCalories),
      minProtein: isNaN(Number(minProtein)) ? undefined : Number(minProtein),
      maxProtein: isNaN(Number(maxProtein)) ? undefined : Number(maxProtein),
      minCarbs: isNaN(Number(minCarbs)) ? undefined : Number(minCarbs),
      maxCarbs: isNaN(Number(maxCarbs)) ? undefined : Number(maxCarbs),
      minFat: isNaN(Number(minFat)) ? undefined : Number(minFat),
      maxFat: isNaN(Number(maxFat)) ? undefined : Number(maxFat),
    };

    const cleanedParams = Object.fromEntries(
      Object.entries(params).filter(([_, v]) => v !== undefined && v !== "")
    );

    return searchExternalRecipesService(cleanedParams);
  },
  {}
);

export const searchExtRecipesByIngController = controllerWrapper(
  async (req: Request) => {
    const { ingredients, number } = req.query;
    const params = {
      ingredients: ingredients ? ingredients : undefined,
      number: number ? Number(number) : 10,
    };

    const cleanedParams = Object.fromEntries(
      Object.entries(params).filter(([_, v]) => v !== undefined && v !== "")
    );

    return searchExtRecipesByIngService(cleanedParams);
  },
  {}
);

export const getRecipeStepsController = controllerWrapper(
  async (req: Request) => {
    const { recipeId } = req.params;
    const id = Number(recipeId);
    if (isNaN(id)) throw new BadRequestError("Invalid recipe ID.");

    const result = await getRecipeStepsService({ recipeId: id });
    if (!result) throw new BadRequestError("No steps found for this recipe.");

    return result;
  },
  {}
);
