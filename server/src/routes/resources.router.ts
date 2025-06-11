import { Router } from "express";
import { getUnitsController, getCategoriesController, getTagsController, getRecipeTagsController } from "../controllers/resources.controller";

const resourcesRouter = Router();

resourcesRouter.get("/units", getUnitsController);
resourcesRouter.get("/categories", getCategoriesController);
resourcesRouter.get("/tags", getTagsController);
resourcesRouter.get("/recipe_tags", getRecipeTagsController);

export default resourcesRouter;