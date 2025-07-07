import { Expose } from 'class-transformer';

export class RecipeTagDto {
  @Expose()
  id!: number;

  @Expose()
  name!: string;
}