import { Router } from "express";
import { generateAIRecommendationsController } from "../controllers/ai_recommendation.controller";
import { RecipesLLMCleanController } from "../controllers/recipes-llm-clean.controller";

const aiRecommendationRouter = Router();
const recipesLLMCleanController = new RecipesLLMCleanController();

// Endpoint para generar recomendaciones personalizadas con IA // to be deprecated
aiRecommendationRouter.post("/recommendations", generateAIRecommendationsController);

// CLEAN ENDPOINT (backend pre-computes everything, AI just generates language)
aiRecommendationRouter.post("/:uid/for-llm-clean", recipesLLMCleanController.getStructuredRecipesForAI);

export default aiRecommendationRouter; 