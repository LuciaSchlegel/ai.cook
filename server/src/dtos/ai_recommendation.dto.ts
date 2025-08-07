import { Expose, Type } from 'class-transformer';
import { UserIngredientOptimizedDto } from './user_ing_optimized.dto';
import { IsArray, IsInt, IsOptional, IsString } from 'class-validator';
import { RecipeDto } from './recipe.dto';

// Request DTO remains the same
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
  userPreferences?: string;

  @Expose()
  @IsOptional()
  @IsInt()
  numberOfRecipes?: number;

  @Expose()
  @IsOptional()
  dietaryRestrictions?: {
    isVegan?: boolean;
    isVegetarian?: boolean;
    isGlutenFree?: boolean;
    isLactoseFree?: boolean;
  };
}

// New structured response DTOs
export class IngredientQuantityDto {
  @Expose()
  name!: string;

  @Expose()
  quantity!: string;
}

export class AIRecipeMinimalDto {
  @Expose()
  id!: number;

  @Expose()
  title!: string;

  @Expose()
  time_minutes!: number;

  @Expose()
  difficulty!: string;

  @Expose()
  tags!: string[];

  @Expose()
  description!: string;

  @Expose()
  @Type(() => IngredientQuantityDto)
  ingredients!: IngredientQuantityDto[];

  @Expose()
  steps!: string[];
}

export class AIShoppingSuggestionDto {
  @Expose()
  name!: string;

  @Expose()
  reason!: string;
}

export class AIAlmostReadyRecipeDto {
  @Expose()
  id!: number;

  @Expose()
  title!: string;

  @Expose()
  description!: string;

  @Expose()
  missing_ingredients!: string[];

  @Expose()
  @Type(() => AIShoppingSuggestionDto)
  shopping_suggestions!: AIShoppingSuggestionDto[];
}

export class AISubstitutionDto {
  @Expose()
  original!: string;

  @Expose()
  alternatives!: string[];
}

// // deprecated - Keep legacy DTO for backward compatibility
// export class RecipeWithMissingIngredientsDto {
//   @Expose()
//   recipe!: RecipeDto;

//   @Expose()
//   missingIngredients!: Array<{
//     ingredient: any;
//     quantity: number;
//     unit: any;
//   }>;

//   @Expose()
//   missingCount!: number;

//   @Expose()
//   availableCount!: number;

//   @Expose()
//   totalCount!: number;

//   @Expose()
//   matchPercentage!: number;
// }

// New primary response DTO
export class AIRecommendationResponseDto {
  @Expose()
  @Type(() => AIRecipeMinimalDto)
  ready_to_cook!: AIRecipeMinimalDto[];

  @Expose()
  @Type(() => AIAlmostReadyRecipeDto)
  almost_ready!: AIAlmostReadyRecipeDto[];

  @Expose()
  @Type(() => AIShoppingSuggestionDto)
  shopping_suggestions!: AIShoppingSuggestionDto[];

  @Expose()
  @Type(() => AISubstitutionDto)
  possible_substitutions!: AISubstitutionDto[];

  @Expose()
  processingTime?: number;

  // deprecated - Keep legacy fields for backward compatibility
  // @Expose()
  // @Type(() => RecipeDto)
  // filteredRecipes?: RecipeDto[];

  // @Expose()
  // @Type(() => RecipeWithMissingIngredientsDto)
  // recipesWithMissingInfo?: RecipeWithMissingIngredientsDto[];

  // @Expose()
  // totalRecipesConsidered?: number;
}