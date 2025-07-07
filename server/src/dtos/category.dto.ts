import { Expose } from 'class-transformer';

export class CategoryDto {
  @Expose()
  id!: number;

  @Expose()
  name!: string;
}