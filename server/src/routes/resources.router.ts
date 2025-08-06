import { Router } from "express";
import { getUnitsController, getCategoriesController, getRecipeTagsController, getDietaryTagsController } from "../controllers/resources.controller";

const resourcesRouter = Router();

resourcesRouter.get("/units", getUnitsController);
resourcesRouter.get("/categories", getCategoriesController);
resourcesRouter.get("/recipe_tags", getRecipeTagsController);
resourcesRouter.get("/dietary_tags", getDietaryTagsController);

export default resourcesRouter;