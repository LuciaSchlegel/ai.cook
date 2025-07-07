import { Expose, Type } from 'class-transformer';

export class SubscriptionDto {
  @Expose()
  id!: number;

  @Expose()
  type!: string;

  @Expose()
  @Type(() => Date)
  startDate?: Date;

  @Expose()
  @Type(() => Date)
  endDate?: Date;

  @Expose()
  isActive!: boolean;

  @Expose()
  @Type(() => Date)
  createdAt!: Date;

  @Expose()
  @Type(() => Date)
  updatedAt!: Date;
}