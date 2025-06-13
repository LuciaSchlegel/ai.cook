import { Expose, Type } from 'class-transformer';
import { RecipeIngredientDto } from './recipe_ing.dto';
import { RecipeTagDto } from './recipe_tag.dto';
import { UserDto } from './user.dto';

export class RecipeDto {
  @Expose()
  id!: number;

  @Expose()
  name!: string;

  @Expose()
  description!: string;

  @Expose()
  @Type(() => UserDto)
  createdByUser!: UserDto;

  @Expose()
  @Type(() => RecipeIngredientDto)
  ingredients!: RecipeIngredientDto[];

  @Expose()
  steps!: string[];

  @Expose()
  @Type(() => Date)
  createdAt!: Date;

  @Expose()
  @Type(() => Date)
  updatedAt!: Date;

  @Expose()
  image?: string;

  @Expose()
  cookingTime?: string;

  @Expose()
  difficulty?: string;

  @Expose()
  servings?: string;

  @Expose()
  @Type(() => RecipeTagDto)
  tags!: RecipeTagDto[];
}