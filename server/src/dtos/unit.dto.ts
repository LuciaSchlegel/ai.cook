import { Expose } from 'class-transformer';

export class UnitDto {
  @Expose()
  id!: number;

  @Expose()
  name!: string;

  @Expose()
  abbreviation!: string;

  @Expose()
  type?: string;
}