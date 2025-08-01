//Ingredient.ts
import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, OneToMany } from 'typeorm';
import { Category } from './Category';
import { RecipeIngredient } from './RecipeIngredient';


@Entity({ name: 'ingredients' })
export class Ingredient {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column({ type: 'varchar', length: 255, unique: true })
  name!: string;

  @ManyToOne(() => Category, { nullable: true })
  category?: Category;

  @Column({nullable: false, default: false})
  isVegan!: boolean; 

  @Column({nullable: false, default: false})
  isVegetarian!: boolean;

  @Column({nullable: false, default: false})
  isGlutenFree!: boolean;

  @Column({nullable: false, default: false})
  isLactoseFree!: boolean;

  @OneToMany(() => RecipeIngredient, recipeIngredient => recipeIngredient.ingredient)
  recipeIngredients?: RecipeIngredient[];
}

