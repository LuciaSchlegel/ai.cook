import { Expose } from 'class-transformer';

export class CustomIngredientDto {
  @Expose()
  id!: number;

  @Expose()
  name!: string;

  @Expose()
  category?: string;

  @Expose()
  tags?: string[];

  @Expose({ name: 'created_by_user_id' })
  createdByUserId!: string;

  @Expose()
  is_deleted!: boolean;

  @Expose()
  is_approved!: boolean;
}