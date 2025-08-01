import { Expose, Type } from 'class-transformer';
import { CategoryDto } from './category.dto';
import { UserBasicDto } from './user_basic.dto';

export class CustomIngredientDto {
  @Expose()
  id!: number;

  @Expose()
  name!: string;

  @Expose()
  isVegan!: boolean;

  @Expose()
  isVegetarian!: boolean;

  @Expose()
  isGlutenFree!: boolean;

  @Expose()
  isLactoseFree!: boolean;

  @Expose()
  @Type(() => CategoryDto)
  category?: CategoryDto;

  @Expose()
  @Type(() => UserBasicDto)
  createdByUser!: UserBasicDto;

  @Expose()
  isDeleted!: boolean;

  @Expose()
  isApproved!: boolean;
}