import { Router } from "express";
import { generateAIRecommendationsController } from "../controllers/ai_recommendation.controller";
import { RecipesLLMController } from "../controllers/recipes-llm.controller";

const aiRecommendationRouter = Router();
const recipesLLMController = new RecipesLLMController();

// Endpoint para generar recomendaciones personalizadas con IA // to be deprecated
aiRecommendationRouter.post("/recommendations", generateAIRecommendationsController);

// Endpoint para generar recetas para LLM
aiRecommendationRouter.post("/:uid/for-llm", recipesLLMController.getRecipesForAI);

export default aiRecommendationRouter; 