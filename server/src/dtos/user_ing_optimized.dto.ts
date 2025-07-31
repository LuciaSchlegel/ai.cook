import { Expose, Type, Transform } from 'class-transformer';
import { IngredientDto } from './ingredient.dto';
import { CustomIngredientDto } from './custom_ing.dto';
import { UnitDto } from './unit.dto';

export class UserIngredientOptimizedDto {
  @Expose()
  id!: number;

  @Expose()
  @Transform(({ value }) => {
    if (typeof value === 'string') {
      const parsed = parseFloat(value);
      return isNaN(parsed) ? 0 : parsed;
    }
    return typeof value === 'number' ? value : 0;
  })
  quantity!: number;

  @Expose()
  @Type(() => IngredientDto)
  ingredient?: IngredientDto;

  @Expose()
  @Type(() => CustomIngredientDto)
  @Transform(({ value, obj }) => {
    // Manejar tanto custom_ingredient como customIngredient
    return value || obj.custom_ingredient;
  })
  customIngredient?: CustomIngredientDto;

  @Expose()
  @Type(() => UnitDto)
  unit!: UnitDto;
}