import { Expose, Type } from 'class-transformer';
import { RecipeDto } from './recipe.dto';
import { UserDto } from './user.dto';

export class EventDto {
  @Expose()
  id!: number;

  @Expose()
  @Type(() => UserDto)
  user!: UserDto;

  @Expose()
  @Type(() => Date)
  eventDate!: Date;

  @Expose()
  title?: string;

  @Expose()
  @Type(() => Date)
  createdAt!: Date;

  @Expose()
  @Type(() => RecipeDto)
  recipes!: RecipeDto[];
}