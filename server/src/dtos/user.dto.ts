import { Expose, Type } from 'class-transformer';
import { SubscriptionDto } from './subscription.dto';
import { UserRole } from '../entities/User';

export class UserDto {
  @Expose()
  id!: number;

  @Expose()
  uid!: string;

  @Expose()
  name!: string;

  @Expose()
  email!: string;

  @Expose()
  phone?: string;

  @Expose()
  gender?: string;

  @Expose()
  @Type(() => Date)
  birthDate?: Date;

  @Expose()
  role!: UserRole;

  @Expose()
  @Type(() => SubscriptionDto)
  subscription?: SubscriptionDto;
}