import { Expose, Type } from 'class-transformer';
import { UserIngredientOptimizedDto } from './user_ing_optimized.dto';
import { IsArray, IsInt, IsOptional, IsString } from 'class-validator';
import { RecipeDto } from './recipe.dto';
import { RecipeTagDto } from './recipe_tag.dto';

export class AIRecommendationRequestDto {
  @Expose()
  @Type(() => UserIngredientOptimizedDto)
  @IsOptional()
  userIngredients?: UserIngredientOptimizedDto[];

  @Expose()
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  preferredTags?: string[]; // Tag names as strings (matches Flutter client)

  @Expose()
  @IsOptional()
  @IsInt()
  maxCookingTimeMinutes?: number;

  @Expose()
  @IsOptional()
  @IsString()
  preferredDifficulty?: string;

  @Expose()
  @IsOptional()
  @IsString()
  userPreferences?: string; // Texto libre con preferencias adicionales

  @Expose()
  @IsOptional()
  @IsInt()
  numberOfRecipes?: number; // Cuántas recetas enviar a la IA (default: 10)

  @Expose()
  @IsOptional()
  dietaryRestrictions?: {
    isVegan?: boolean;
    isVegetarian?: boolean;
    isGlutenFree?: boolean;
    isLactoseFree?: boolean;
  };
}

export class RecipeWithMissingIngredientsDto {
  @Expose()
  recipe!: RecipeDto;

  @Expose()
  missingIngredients!: Array<{
    ingredient: any;
    quantity: number;
    unit: any;
  }>;

  @Expose()
  missingCount!: number;

  @Expose()
  availableCount!: number;

  @Expose()
  totalCount!: number;

  @Expose()
  matchPercentage!: number;
}

export class AIRecommendationResponseDto {
  @Expose()
  recommendations!: string; // Respuesta de la IA

  @Expose()
  @Type(() => UserIngredientOptimizedDto)
  filteredRecipes!: RecipeDto[]; // Recetas que se enviaron a la IA

  @Expose()
  @Type(() => RecipeWithMissingIngredientsDto)
  recipesWithMissingInfo?: RecipeWithMissingIngredientsDto[]; // Detailed missing ingredient info

  @Expose()
  totalRecipesConsidered!: number; // Total de recetas antes del filtrado

  @Expose()
  processingTime?: number; // Tiempo de procesamiento en ms
} 