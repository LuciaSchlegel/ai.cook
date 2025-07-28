import { Expose, Type, Transform } from 'class-transformer';
import { UserIngredientDto } from './user_ing.dto';
import { IsArray, IsEnum, IsInt, IsOptional, IsString } from 'class-validator';

export enum RecipeFilterEnum {
    ALL = 'All Recipes',
    AVAILABLE = 'Available',
    MISSING = 'Missing Ingredients',
    RECOMMENDED = 'Recommended',
  }

export class FilterRecipesDto {
  @Expose()
  @IsOptional()
  @Transform(({ value }) => {
    if (typeof value === 'string') {
      switch (value) {
        case 'All Recipes':
          return RecipeFilterEnum.ALL;
        case 'Available':
          return RecipeFilterEnum.AVAILABLE;
        case 'Missing Ingredients':
          return RecipeFilterEnum.MISSING;
        case 'Recommended':
          return RecipeFilterEnum.RECOMMENDED;
        default:
          return value;
      }
    }
    return value;
  })
  @IsEnum(RecipeFilterEnum)
  filter?: RecipeFilterEnum;

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
}