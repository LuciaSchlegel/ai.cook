import { Expose } from 'class-transformer';

export class DietaryTagDto {
  @Expose()
  id!: number;

  @Expose()
  name!: string;
}