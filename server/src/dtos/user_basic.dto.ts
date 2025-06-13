import { Expose } from 'class-transformer';
import { SubscriptionDto } from './subscription.dto';

export class UserBasicDto {
  @Expose()
  id!: number;

  @Expose()
  name!: string;

  @Expose()
  uid!: string;

  @Expose()
  subscription?: SubscriptionDto;
}