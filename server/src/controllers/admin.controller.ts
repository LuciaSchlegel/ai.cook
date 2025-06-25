import { Request, Response, NextFunction, RequestHandler } from "express";
import { BadRequestError } from "../types/AppError";
import { seedIngredientsService, seedRecipesService, seedResourcesService, setAdminRoleService } from "../services/admin.service";

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

export const setAdminRoleController = controllerWrapper(async (req) => {
  const { uid } = req.params;
  if (!uid) {
    throw new BadRequestError("User ID is required");
  }
  return await setAdminRoleService(uid);
});

export const seedResourcesController = controllerWrapper(async (req) => {
  const { resourceType } = req.params;
  const { resource } = req.body;
  console.log("controller", resourceType, resource);
  if (!resourceType) {
    throw new BadRequestError("Resource type is required");
  }
  return await seedResourcesService(resourceType, resource);
});

export const seedIngredientsController = controllerWrapper(async (req) => {
  const { ingredient } = req.body;
  if (!ingredient) {
    throw new BadRequestError("Ingredient is required");
  }
  return await seedIngredientsService(ingredient);
});

export const seedRecipesController = controllerWrapper(async (req) => {
  const { recipes } = req.body;
  if (!recipes) {
    throw new BadRequestError("Recipe is required");
  }
  return await seedRecipesService(recipes);
});
