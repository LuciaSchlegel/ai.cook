import { Request } from "express";
import { BadRequestError } from "../types/AppError";
import {
  seedIngredientsService,
  seedRecipesService,
  seedResourcesService,
  setAdminRoleService,
} from "../services/admin.service";
import { controllerWrapper } from "../helpers/controllerWrapper";

export const setAdminRoleController = controllerWrapper(
  async (req: Request) => {
    const { uid } = req.params;
    if (!uid) throw new BadRequestError("User ID is required");
    return setAdminRoleService(uid);
  },
  {}
);

export const seedResourcesController = controllerWrapper(
  async (req: Request) => {
    const { resourceType } = req.params;
    const { resource } = req.body;
    if (!resourceType) throw new BadRequestError("Resource type is required");
    return seedResourcesService(resourceType, resource);
  },
  {}
);

export const seedIngredientsController = controllerWrapper(
  async (req: Request) => {
    const { ingredient } = req.body;
    if (!ingredient) throw new BadRequestError("Ingredient is required");
    return seedIngredientsService(ingredient);
  },
  {}
);

export const seedRecipesController = controllerWrapper(async (req: Request) => {
  const { recipes } = req.body;
  if (!recipes) throw new BadRequestError("Recipe is required");
  return seedRecipesService(recipes);
}, {});

export const seedRecipesFromJsonController = controllerWrapper(
  async (req: Request) => {
    const { recipes, autoCreateIngredients = true } = req.body;

    if (!recipes || !Array.isArray(recipes)) {
      throw new BadRequestError("Recipes array is required");
    }

    const convertedRecipes = recipes.map((recipe: any) => ({
      name: recipe.name,
      description: recipe.description,
      steps: recipe.steps,
      cookingTime: recipe.cookingTime,
      difficulty: recipe.difficulty,
      servings: recipe.servings,
      image: recipe.image || "",
      ingredients: recipe.ingredients.map((ing: any) => ({
        name: ing.name,
        quantity: ing.quantity,
        unit: ing.unit,
        additionalInfo: ing.additionalInfo,
        relativeQuantity: ing.relativeQuantity,
      })),
      tags: recipe.tags,
    }));

    return seedRecipesService(convertedRecipes);
  },
  {}
);
