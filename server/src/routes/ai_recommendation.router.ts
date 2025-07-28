import { Router } from "express";
import { generateAIRecommendationsController } from "../controllers/ai_recommendation.controller";

const aiRecommendationRouter = Router();

// Endpoint para generar recomendaciones personalizadas con IA
aiRecommendationRouter.post("/recommendations", generateAIRecommendationsController);

export default aiRecommendationRouter; 