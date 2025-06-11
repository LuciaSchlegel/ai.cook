import { NextFunction, Request, RequestHandler, Response } from "express";
import { getRecipesService } from "../services/recipe.service";

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
  return await getRecipesService();
});