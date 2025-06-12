import { Expose } from 'class-transformer';

export class SubscriptionDto {
  @Expose()
  id!: number;

  @Expose()
  type!: string;

  @Expose({ name: 'start_date' })
  startDate?: Date;

  @Expose({ name: 'end_date' })
  endDate?: Date;

  @Expose({ name: 'is_active' })
  isActive!: boolean;

  @Expose({ name: 'created_at' })
  createdAt!: Date;

  @Expose({ name: 'updated_at' })
  updatedAt!: Date;
}