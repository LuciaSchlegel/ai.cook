import { Expose } from 'class-transformer';

export class TagDto {
  @Expose()
  id!: number;

  @Expose()
  name!: string;
}