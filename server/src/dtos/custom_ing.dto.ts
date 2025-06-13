import { Expose, Type } from 'class-transformer';
import { CategoryDto } from './category.dto';
import { TagDto } from './tag.dto';
import { UserBasicDto } from './user_basic.dto';

export class CustomIngredientDto {
  @Expose()
  id!: number;

  @Expose()
  name!: string;

  @Expose()
  @Type(() => CategoryDto)
  category?: CategoryDto;

  @Expose()
  @Type(() => TagDto)
  tags?: TagDto[];

  @Expose()
  @Type(() => UserBasicDto)
  createdByUser!: UserBasicDto;

  @Expose()
  isDeleted!: boolean;

  @Expose()
  isApproved!: boolean;
}