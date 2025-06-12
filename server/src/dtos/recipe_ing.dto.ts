import { Expose, Type } from 'class-transformer';
import { Ingredient } from '../entities/Ingredient';
import { Unit } from '../entities/Unit';

export class RecipeIngredientDto {
  @Expose()
  id!: number;

  @Expose()
  quantity!: number;

  @Expose()
  @Type(() => Ingredient)
  ingredient!: Ingredient;

  @Expose()
  @Type(() => Unit)
  unit?: Unit;
}