import { Expose, Type } from 'class-transformer';
import { CategoryDto } from './category.dto';
import { TagDto } from './tag.dto';

export class IngredientDto {
  @Expose()
  id!: number;

  @Expose()
  name!: string;

  @Expose()
  is_vegan?: boolean;

  @Expose()
  is_vegetarian?: boolean;

  @Expose()
  is_gluten_free?: boolean;

  @Expose()
  is_lactose_free?: boolean;

  @Expose()
  @Type(() => CategoryDto)
  category?: CategoryDto;

  @Expose()
  @Type(() => TagDto)
  tags?: TagDto[];
}   