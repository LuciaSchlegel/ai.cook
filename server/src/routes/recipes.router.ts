import { Router } from "express";
import { filterRecipesController, getMissingIngredientsController, getRecipesController } from "../controllers/recipe.controller";

const recipesRouter = Router();

recipesRouter.get("/", getRecipesController);
recipesRouter.post("/filter", filterRecipesController);
recipesRouter.post("/filter/ing", getMissingIngredientsController);

export default recipesRouter;