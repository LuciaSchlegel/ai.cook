//UserIngredient.ts
import { Entity, PrimaryGeneratedColumn, ManyToOne, Column } from 'typeorm';
import { User } from './User';
import { Ingredient } from './Ingredient';
import { CustomIngredient } from './Custom_Ingredient';
import { Unit } from './Unit';

@Entity({ name: 'user_ingredients' })
export class UserIngredient {
  @PrimaryGeneratedColumn()
  id!: number;

  @ManyToOne(() => User, user => user.userIngredients, { onDelete: 'CASCADE' })
  user!: User;

  @ManyToOne(() => Ingredient, { nullable: true, onDelete: 'SET NULL' })
  ingredient?: Ingredient;

  @ManyToOne(() => CustomIngredient, { nullable: true, onDelete: 'SET NULL' })
  customIngredient?: CustomIngredient;

  @Column({ type: 'int', default: 1 })
  quantity!: number;

  @ManyToOne(() => Unit, { nullable: true, onDelete: 'SET NULL' })
  unit?: Unit;
}