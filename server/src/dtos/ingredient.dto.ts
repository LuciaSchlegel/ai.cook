import { Expose, Type } from 'class-transformer';
import { CategoryDto } from './category.dto';

export class IngredientDto {
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
}