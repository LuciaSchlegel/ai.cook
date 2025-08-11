import { NextFunction, Request, RequestHandler, Response } from "express";
import { getMissingIngredientsByRecipeService, getRecipesService } from "../services/recipe.service";
import { RecipeDto } from "../dtos/recipe.dto";
import { serialize } from "../helpers/serialize";
import { RecipeFilterService } from "../services/recipe_filter.service";
import { FilterRecipesDto, RecipeFilterEnum } from "../dtos/recipe_filter.dto";
import { plainToInstance } from "class-transformer";
import { validate } from "class-validator";
import { UserIngredientOptimizedDto } from "../dtos/user_ing_optimized.dto";

type ControllerFunction = (req: Request) => Promise<any>;

const controllerWrapper = (handler: ControllerFunction): RequestHandler => {
  return async (req: Request, res: Response, next: NextFunction) => {
    try {
      const result = await handler(req);
      res.status(200).json(result);
    } catch (error: any) {
      // Si el error tiene un código de estado, usarlo
      if (error.status) {
        res.status(error.status).json({
          message: error.message,
          errors: error.errors,
          error: error.error
        });
      } else {
        // Error interno del servidor
        console.error('Unhandled error:', error);
        res.status(500).json({
          message: "Internal server error",
          error: error.message
        });
      }
    }
  };
};

export const getRecipesController = controllerWrapper(async () => {
  const recipes = await getRecipesService();
  return serialize(RecipeDto, recipes);
});

export const getMissingIngredientsController = controllerWrapper(async (req) => {
  try {
    const recipes = await getRecipesService();
    const serializedRecipes = serialize(RecipeDto, recipes) as RecipeDto[]
    const serializedUserIng = serialize(
      UserIngredientOptimizedDto,
      Array.isArray(req.body?.userIngredients) ? req.body.userIngredients : []
    ) as UserIngredientOptimizedDto[];

    // Return detailed missing ingredients per recipe
    const result = await getMissingIngredientsByRecipeService(serializedRecipes, serializedUserIng);
    return result;
  } catch (error: any) {
    // Si ya es un error de validación, re-lanzarlo
    if (error.status === 400) {
      throw error;
    }
    // Para otros errores, crear un error 500
    console.error('Unexpected error:', error);
    throw {
      status: 500,
      message: "Internal server error",
      error: error.message
    };
  }
})

export const filterRecipesController = controllerWrapper(async (req) => {
  console.log('=== RECIPE FILTER REQUEST ===');
  console.log('Full request body:', JSON.stringify(req.body, null, 2));
  console.log('Preferred tags specifically:', req.body.preferredTags);
  console.log('Preferred tags type:', typeof req.body.preferredTags);
  console.log('Preferred tags array?:', Array.isArray(req.body.preferredTags));
  if (Array.isArray(req.body.preferredTags)) {
    console.log('Preferred tags content:', req.body.preferredTags.map((tag: any, i: number) => `[${i}]: "${tag}" (${typeof tag})`));
  }

  try {
    const dto = plainToInstance(FilterRecipesDto, req.body);
    const errors = await validate(dto);

    if (errors.length > 0) {
      console.log('Validation errors:', errors);
      const errorResponse = {
        status: 400,
        message: "Invalid input",
        errors: errors.map(error => ({
          property: error.property,
          constraints: error.constraints,
          value: error.value
        }))
      };
      throw errorResponse;
    }

    const allRecipes = await getRecipesService();
    const serializedRecipes = serialize(RecipeDto, allRecipes) as RecipeDto[];

    const filterString = dto.filter === RecipeFilterEnum.RECOMMENDED
      ? "Recommended Recipes"
      : dto.filter;

    console.log('=== FILTERING PARAMETERS ===');
    console.log('Filter type:', filterString);
    console.log('User ingredients count:', dto.userIngredients?.length || 0);
    console.log('Preferred tags from DTO:', dto.preferredTags);
    console.log('Preferred tags count:', dto.preferredTags?.length || 0);
    console.log('Max cooking time:', dto.maxCookingTimeMinutes);
    console.log('Preferred difficulty:', dto.preferredDifficulty);

    const filteredRecipes = RecipeFilterService.filterRecipes({
      allRecipes: serializedRecipes,
      userIngredients: dto.userIngredients || [],
      filter: filterString,
      preferredTags: dto.preferredTags || [],
      maxCookingTimeMinutes: dto.maxCookingTimeMinutes,
      preferredDifficulty: dto.preferredDifficulty,
    });

    console.log(`=== FILTERING RESULT ===`);
    console.log(`Filtered ${serializedRecipes.length} recipes to ${filteredRecipes.length}`);
    return filteredRecipes;
  } catch (error: any) {
    // Si ya es un error de validación, re-lanzarlo
    if (error.status === 400) {
      throw error;
    }

    // Para otros errores, crear un error 500
    console.error('Unexpected error:', error);
    throw {
      status: 500,
      message: "Internal server error",
      error: error.message
    };
  }
});