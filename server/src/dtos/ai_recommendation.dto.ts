import { Expose, Type } from 'class-transformer';
import { UserIngredientOptimizedDto } from './user_ing_optimized.dto';
import { IsArray, IsInt, IsOptional, IsString } from 'class-validator';
import { RecipeDto } from './recipe.dto';

export class AIRecommendationRequestDto {
  @Expose()
  @Type(() => UserIngredientOptimizedDto)
  @IsOptional()
  userIngredients?: UserIngredientOptimizedDto[];

  @Expose()
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  preferredTags?: string[];

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
}

export class AIRecommendationResponseDto {
  @Expose()
  recommendations!: string; // Respuesta de la IA

  @Expose()
  @Type(() => UserIngredientOptimizedDto)
  filteredRecipes!: RecipeDto[]; // Recetas que se enviaron a la IA

  @Expose()
  totalRecipesConsidered!: number; // Total de recetas antes del filtrado

  @Expose()
  processingTime?: number; // Tiempo de procesamiento en ms
} 