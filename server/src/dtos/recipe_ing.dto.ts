import { Expose, Type, Transform } from 'class-transformer';
import { IngredientDto } from './ingredient.dto';
import { UnitDto } from './unit.dto';

export class RecipeIngredientDto {
  @Expose()
  id!: number;

  @Expose()
  @Transform(({ value }) => {
    // Convert string decimal values from database to number
    if (typeof value === 'string') {
      const parsed = parseFloat(value);
      return isNaN(parsed) ? 0 : parsed;
    }
    return typeof value === 'number' ? value : 0;
  })
  quantity!: number;

  @Expose()
  @Type(() => IngredientDto)
  ingredient!: IngredientDto;

  @Expose()
  @Type(() => UnitDto)
  unit?: UnitDto;
}