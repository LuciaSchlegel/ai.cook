import { NextFunction, Request, RequestHandler, Response } from "express";
import { getRecipesService } from "../services/recipe.service";
import { RecipeDto } from "../dtos/recipe.dto";
import { serialize } from "../helpers/serialize";

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

export const getRecipesController = controllerWrapper(async (req) => {
  const recipes = await getRecipesService();
  return serialize(RecipeDto, recipes);
});