import { Router } from "express";
import { getRecipeStepsController, searchExternalRecipesController, searchExtRecipesByIngController } from "../controllers/api.controller";

const apiRouter = Router();

apiRouter.get('/recipes', searchExternalRecipesController);
apiRouter.get('/recipes/:recipeId/steps', getRecipeStepsController);
apiRouter.get('/recipes/by-ingredients', searchExtRecipesByIngController)

export default apiRouter;