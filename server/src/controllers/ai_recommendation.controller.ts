import { Request } from "express";
import { getRecipesService } from "../services/recipe.service";
import { RecipeDto } from "../dtos/recipe.dto";
import { serialize } from "../helpers/serialize";
import { AIRecommendationService } from "../services/ai_recommendation.service";
import {
  AIRecommendationRequestDto,
  AIRecommendationResponseDto,
} from "../dtos/ai_recommendation.dto";
import { plainToInstance } from "class-transformer";
import { validate } from "class-validator";
import { controllerWrapper } from "../helpers/controllerWrapper";
import { BadRequestError } from "../types/AppError";

export const generateAIRecommendationsController = controllerWrapper(
  async (req: Request) => {
    const startTime = Date.now();

    // Validate DTO
    const dto = plainToInstance(AIRecommendationRequestDto, req.body);
    const errors = await validate(dto);

    if (errors.length > 0) {
      throw new BadRequestError(
        "Invalid input",
        errors.map((e) => ({
          property: e.property,
          constraints: e.constraints,
          value: e.value,
        }))
      );
    }

    // Business logic validation
    if (!dto.userIngredients || dto.userIngredients.length === 0) {
      throw new BadRequestError(
        "At least one ingredient is required to generate AI recommendations"
      );
    }

    // Limit numberOfRecipes to reasonable range
    const numberOfRecipes = Math.min(
      Math.max(dto.numberOfRecipes || 10, 1),
      20
    );

    // Get all recipes
    const allRecipes = await getRecipesService();
    const serializedRecipes = serialize(RecipeDto, allRecipes) as RecipeDto[];

    // Generate AI recommendations
    const aiResponse =
      await AIRecommendationService.generatePersonalizedRecommendations(
        serializedRecipes,
        {
          userIngredients: dto.userIngredients || [],
          preferredTags: dto.preferredTags || [],
          maxCookingTimeMinutes: dto.maxCookingTimeMinutes,
          preferredDifficulty: dto.preferredDifficulty,
          userPreferences: dto.userPreferences,
          numberOfRecipes,
          dietaryRestrictions: dto.dietaryRestrictions,
        }
      );

    const processingTime = Date.now() - startTime;

    return serialize(AIRecommendationResponseDto, {
      ...aiResponse,
      processingTime,
    });
  },
  {}
);
