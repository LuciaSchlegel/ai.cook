import { Router } from "express";
import { filterRecipesController, getRecipesController } from "../controllers/recipe.controller";

const recipesRouter = Router();

recipesRouter.get("/", getRecipesController);
recipesRouter.post("/filter", filterRecipesController);

export default recipesRouter;