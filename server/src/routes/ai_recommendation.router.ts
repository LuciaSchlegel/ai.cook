import { Router } from "express";
import { generateAIRecommendationsController } from "../controllers/ai_recommendation.controller";
import { RecipesLLMCleanController } from "../controllers/recipes-llm-clean.controller";
import { enrichRecipesController } from "../controllers/recipe_enrichment.controller";

const aiRecommendationRouter = Router();
const recipesLLMCleanController = new RecipesLLMCleanController();

// Legacy (to be deprecated)
aiRecommendationRouter.post("/recommendations", generateAIRecommendationsController);

// Pre-compute data (unchanged)
aiRecommendationRouter.post("/:uid/for-llm-clean", recipesLLMCleanController.getStructuredRecipesForAI);

// Enrich pre-computed data via Claude
aiRecommendationRouter.post("/:uid/enrich", enrichRecipesController);

export default aiRecommendationRouter;