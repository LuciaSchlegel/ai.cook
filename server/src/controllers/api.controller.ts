import { NextFunction, RequestHandler, Request, Response } from "express";
import {
  getRecipeStepsService,
  searchExternalRecipesService,
} from "../services/api.service";

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

type ControllerFunction = (req: Request) => Promise<any>;

const controllerWrapper = (handler: ControllerFunction): RequestHandler => {
  return async (req: Request, res: Response, next: NextFunction) => {
    try {
      const result = await handler(req);
      res.status(200).json(result);
    } catch (error) {
      next(error);
    }
  };
};

export const searchExternalRecipesController = controllerWrapper(async (req) => {
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

  return await searchExternalRecipesService(cleanedParams);
});

export const getRecipeStepsController = controllerWrapper(async (req) => {
  const { recipeId } = req.params;
  const id = Number(recipeId);
  if (isNaN(id)) throw new Error("Invalid recipe ID.");

  const result = await getRecipeStepsService({ recipeId: id });
  if (!result) throw new Error("No steps found for this recipe.");

  return result;
});