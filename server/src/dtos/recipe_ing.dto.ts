import { Expose, Type } from 'class-transformer';
import { IngredientDto } from './ingredient.dto';
import { UnitDto } from './unit.dto';

export class RecipeIngredientDto {
  @Expose()
  id!: number;

  @Expose()
  quantity!: number;

  @Expose()
  @Type(() => IngredientDto)
  ingredient!: IngredientDto;

  @Expose()
  @Type(() => UnitDto)
  unit?: UnitDto;
}