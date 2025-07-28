import { Expose, Type, Transform } from 'class-transformer';
import { UserIngredientDto } from './user_ing.dto';
import { IsArray, IsInt, IsOptional, IsString } from 'class-validator';
import { RecipeTagDto } from './recipe_tag.dto';
import { RecipeDto } from './recipe.dto';

export class AIRecommendationRequestDto {
  @Expose()
  @Type(() => UserIngredientDto)
  @IsOptional()
  userIngredients?: UserIngredientDto[];

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
  @Type(() => UserIngredientDto)
  filteredRecipes!: RecipeDto[]; // Recetas que se enviaron a la IA

  @Expose()
  totalRecipesConsidered!: number; // Total de recetas antes del filtrado

  @Expose()
  processingTime?: number; // Tiempo de procesamiento en ms
} 