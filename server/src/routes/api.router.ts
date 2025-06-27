import { Router } from "express";
import { getRecipeStepsController, searchExternalRecipesController } from "../controllers/api.controller";

const apiRouter = Router();

apiRouter.get('/recipes', searchExternalRecipesController);
apiRouter.get('/recipes/:recipeId/steps', getRecipeStepsController);

export default apiRouter;