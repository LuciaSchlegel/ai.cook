//UserIngredient.ts
import { Entity, PrimaryGeneratedColumn, ManyToOne, Column } from 'typeorm';
import { User } from './User';
import { Ingredient } from './Ingredient';

@Entity({ name: 'user_ingredients' })
export class UserIngredient {
  @PrimaryGeneratedColumn()
  id!: number;

  @ManyToOne(() => User, user => user.userIngredients, { onDelete: 'CASCADE' })
  user!: User;

  @ManyToOne(() => Ingredient, ingredient => ingredient, { onDelete: 'CASCADE' })
  ingredient!: Ingredient;

  @Column({ type: 'int', default: 1 })
  quantity!: number; // opcional: cantidad, unidad, etc.
}