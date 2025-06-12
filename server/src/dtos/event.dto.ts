import { Expose, Type } from 'class-transformer';
import { RecipeDto } from './recipe.dto';

export class EventDto {
  @Expose()
  id!: number;

  @Expose({ name: 'user_id' })
  userId!: string;

  @Expose({ name: 'event_date' })
  eventDate!: Date;

  @Expose()
  title?: string;

  @Expose({ name: 'created_at' })
  createdAt!: Date;

  @Expose()
  @Type(() => RecipeDto)
  recipes!: RecipeDto[];
}