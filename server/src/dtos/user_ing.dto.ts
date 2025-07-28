import { Expose, Type, Transform } from 'class-transformer';
import { IngredientDto } from './ingredient.dto';
import { CustomIngredientDto } from './custom_ing.dto';
import { UnitDto } from './unit.dto';
import { UserBasicDto } from './user_basic.dto';

export class UserIngredientDto {
  @Expose()
  id!: number;

  @Expose()
  @Type(() => UserBasicDto)
  @Transform(({ value, obj }) => {
    // Si viene como objeto user, usarlo directamente
    if (value && typeof value === 'object') {
      return value;
    }
    // Si viene como uid directo, crear el objeto user
    if (obj.uid) {
      return { uid: obj.uid };
    }
    return value;
  })
  user!: UserBasicDto;

  @Expose()
  quantity!: number;

  @Expose()
  @Type(() => IngredientDto)
  ingredient!: IngredientDto;

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
