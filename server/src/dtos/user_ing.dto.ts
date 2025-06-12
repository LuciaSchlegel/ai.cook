import { Expose, Type } from 'class-transformer';
import { IngredientDto } from './ingredient.dto';
import { CustomIngredientDto } from './custom_ing.dto';
import { UnitDto } from './unit.dto';

export class UserIngredientDto {
  @Expose()
  id!: number;

  @Expose({ name: 'user_id' })
  userId!: string;

  @Expose()
  quantity!: number;

  @Expose()
  @Type(() => IngredientDto)
  ingredient?: IngredientDto;

  @Expose()
  @Type(() => CustomIngredientDto)
  custom_ingredient?: CustomIngredientDto;

  @Expose()
  @Type(() => UnitDto)
  unit?: UnitDto;
}