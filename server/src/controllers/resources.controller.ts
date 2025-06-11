import { NextFunction, Request, RequestHandler, Response } from "express";
import { getCategoriesService, getRecipeTagsService, getTagsService, getUnitsService } from "../services/resources.service";

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

export const getUnitsController = controllerWrapper(async (req) => {
  return await getUnitsService();
});

export const getCategoriesController = controllerWrapper(async (req) => {
  return await getCategoriesService();
});

export const getTagsController = controllerWrapper(async (req) => {
  return await getTagsService();
});

export const getRecipeTagsController = controllerWrapper(async (req) => {
  return await getRecipeTagsService();
});
