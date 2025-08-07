import { NextFunction, Request, RequestHandler, Response } from "express";
import { getRecipesService } from "../services/recipe.service";
import { RecipeDto } from "../dtos/recipe.dto";
import { serialize } from "../helpers/serialize";
import { AIRecommendationService } from "../services/ai_recommendation.service";
import { AIRecommendationRequestDto, AIRecommendationResponseDto } from "../dtos/ai_recommendation.dto";
import { plainToInstance } from "class-transformer";
import { validate } from "class-validator";

type ControllerFunction = (req: Request) => Promise<any>;

const controllerWrapper = (handler: ControllerFunction): RequestHandler => {
  return async (req: Request, res: Response, next: NextFunction) => {
    try {
      const result = await handler(req);
      res.status(200).json(result);
    } catch (error: any) {
      if (error.status) {
        res.status(error.status).json({
          message: error.message,
          errors: error.errors,
          error: error.error
        });
      } else {
        console.error('Unhandled error:', error);
        res.status(500).json({
          message: "Internal server error",
          error: error.message
        });
      }
    }
  };
};

export const generateAIRecommendationsController = controllerWrapper(async (req) => {
  const startTime = Date.now();
  
  // Log only essential info, not full body for performance
  console.log('🤖 AI Recommendation request received:', {
    userIngredientsCount: req.body.userIngredients?.length || 0,
    preferredTagsCount: req.body.preferredTags?.length || 0,
    maxCookingTimeMinutes: req.body.maxCookingTimeMinutes,
    preferredDifficulty: req.body.preferredDifficulty,
    numberOfRecipes: req.body.numberOfRecipes || 10,
  });
  
  try {
    // Validar el DTO
    const dto = plainToInstance(AIRecommendationRequestDto, req.body);
    const errors = await validate(dto);

    if (errors.length > 0) {
      console.log('❌ Validation errors:', errors);
      const errorResponse = {
        status: 400,
        message: "Invalid input",
        errors: errors.map(error => ({
          property: error.property,
          constraints: error.constraints,
          value: error.value
        }))
      };
      throw errorResponse;
    }

    // Additional business logic validation
    if (!dto.userIngredients || dto.userIngredients.length === 0) {
      console.log('⚠️ No user ingredients provided');
      const errorResponse = {
        status: 400,
        message: "At least one ingredient is required to generate AI recommendations",
        error: "NO_INGREDIENTS"
      };
      throw errorResponse;
    }

    // Limit numberOfRecipes to reasonable range
    const numberOfRecipes = Math.min(Math.max(dto.numberOfRecipes || 10, 1), 20);
    if (dto.numberOfRecipes && dto.numberOfRecipes !== numberOfRecipes) {
      console.log(`⚠️ numberOfRecipes adjusted from ${dto.numberOfRecipes} to ${numberOfRecipes}`);
    }

    // Obtener todas las recetas
    const allRecipes = await getRecipesService();
    const serializedRecipes = serialize(RecipeDto, allRecipes) as RecipeDto[];

    console.log('🤖 Generating AI recommendations with:', {
      userIngredientsCount: dto.userIngredients?.length || 0,
      preferredTags: dto.preferredTags,
      maxCookingTimeMinutes: dto.maxCookingTimeMinutes,
      preferredDifficulty: dto.preferredDifficulty,
      userPreferences: dto.userPreferences,
      numberOfRecipes: numberOfRecipes,
      totalRecipesAvailable: serializedRecipes.length,
    });

    // Don't log all recipes for performance - too verbose
    if (process.env.NODE_ENV === 'development') {
      console.log(`📖 Total recipes available: ${serializedRecipes.length}`);
    }

    // Generar recomendaciones con IA
    const aiResponse = await AIRecommendationService.generatePersonalizedRecommendations(
      serializedRecipes,
      {
        userIngredients: dto.userIngredients || [],
        preferredTags: dto.preferredTags || [],
        maxCookingTimeMinutes: dto.maxCookingTimeMinutes,
        preferredDifficulty: dto.preferredDifficulty,
        userPreferences: dto.userPreferences,
        numberOfRecipes: numberOfRecipes, // Use validated value
        dietaryRestrictions: dto.dietaryRestrictions,
      }
    );

    const processingTime = Date.now() - startTime;

    console.log(`✅ AI recommendations generated in ${processingTime}ms`);
    console.log(`📊 Processed ${aiResponse.totalRecipesConsidered} recipes, sent ${aiResponse.filteredRecipes?.length} to AI`);

    // Serializar la respuesta
    const response = serialize(AIRecommendationResponseDto, {
      ...aiResponse,
      processingTime,
    });

    return response;
  } catch (error: any) {
    if (error.status === 400) {
      throw error;
    }
    
    console.error('Unexpected error in AI recommendations:', error);
    throw {
      status: 500,
      message: "Internal server error",
      error: error.message
    };
  }
}); 