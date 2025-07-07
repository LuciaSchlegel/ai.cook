import { Router } from "express";
import { getRecipesController } from "../controllers/recipe.controller";

const recipesRouter = Router();

recipesRouter.get("/", getRecipesController);

export default recipesRouter;