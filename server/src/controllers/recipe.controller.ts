import { Request } from "express";
import {
  getMissingIngredientsByRecipeService,
  getRecipesService,
} from "../services/recipe.service";
import { RecipeDto } from "../dtos/recipe.dto";
import { serialize } from "../helpers/serialize";
import { RecipeFilterService } from "../services/recipe_filter.service";
import { FilterRecipesDto, RecipeFilterEnum } from "../dtos/recipe_filter.dto";
import { plainToInstance } from "class-transformer";
import { validate } from "class-validator";
import { UserIngredientOptimizedDto } from "../dtos/user_ing_optimized.dto";
import { controllerWrapper } from "../helpers/controllerWrapper";
import { BadRequestError } from "../types/AppError";

export const getRecipesController = controllerWrapper(
  async () => {
    const recipes = await getRecipesService();
    return serialize(RecipeDto, recipes);
  },
  {} // kein DTO nötig, serialize passiert manuell
);

export const getMissingIngredientsController = controllerWrapper(
  async (req: Request) => {
    const recipes = await getRecipesService();
    const serializedRecipes = serialize(RecipeDto, recipes) as RecipeDto[];
    const serializedUserIng = serialize(
      UserIngredientOptimizedDto,
      Array.isArray(req.body?.userIngredients) ? req.body.userIngredients : []
    ) as UserIngredientOptimizedDto[];

    return getMissingIngredientsByRecipeService(
      serializedRecipes,
      serializedUserIng
    );
  },
  {}
);

export const filterRecipesController = controllerWrapper(
  async (req: Request) => {
    const dto = plainToInstance(FilterRecipesDto, req.body);
    const errors = await validate(dto);

    if (errors.length > 0) {
      throw new BadRequestError(
        "Invalid input",
        errors.map((e: any) => ({
          property: e.property,
          constraints: e.constraints,
          value: e.value,
        }))
      );
    }

    const allRecipes = await getRecipesService();
    const serializedRecipes = serialize(RecipeDto, allRecipes) as RecipeDto[];

    const filterString =
      dto.filter === RecipeFilterEnum.RECOMMENDED
        ? "Recommended Recipes"
        : dto.filter;

    return RecipeFilterService.filterRecipes({
      allRecipes: serializedRecipes,
      userIngredients: dto.userIngredients || [],
      filter: filterString,
      preferredTags: dto.preferredTags || [],
      maxCookingTimeMinutes: dto.maxCookingTimeMinutes,
      preferredDifficulty: dto.preferredDifficulty,
    });
  },
  {}
);
