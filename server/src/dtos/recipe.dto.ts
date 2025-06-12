import { Expose, Type } from 'class-transformer';
import { RecipeIngredientDto } from './recipe_ing.dto';
import { RecipeTagDto } from './recipe_tag.dto';

export class RecipeDto {
  @Expose()
  id!: number;

  @Expose()
  name!: string;

  @Expose()
  description!: string;

  @Expose({ name: 'created_by_user_id' })
  createdByUserId?: string;

  @Expose()
  @Type(() => RecipeIngredientDto)
  ingredients!: RecipeIngredientDto[];

  @Expose()
  steps!: string[];

  @Expose({ name: 'created_at' })
  createdAt!: Date;

  @Expose({ name: 'updated_at' })
  updatedAt!: Date;

  @Expose({ name: 'image_url' })
  image?: string;

  @Expose({ name: 'cooking_time' })
  cookingTime?: string;

  @Expose()
  difficulty?: string;

  @Expose()
  servings?: string;

  @Expose()
  @Type(() => RecipeTagDto)
  tags!: RecipeTagDto[];
}