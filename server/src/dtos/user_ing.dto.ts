import { Expose, Type } from 'class-transformer';
import { IngredientDto } from './ingredient.dto';
import { CustomIngredientDto } from './custom_ing.dto';
import { UnitDto } from './unit.dto';
import { UserBasicDto } from './user_basic.dto';

export class UserIngredientDto {
  @Expose()
  id!: number;

  @Expose()
  @Type(() => UserBasicDto)
  user!: UserBasicDto;

  @Expose()
  quantity!: number;

  @Expose()
  @Type(() => IngredientDto)
  ingredient!: IngredientDto;

  @Expose()
  @Type(() => CustomIngredientDto)
  customIngredient?: CustomIngredientDto;

  @Expose()
  @Type(() => UnitDto)
  unit!: UnitDto;
}
