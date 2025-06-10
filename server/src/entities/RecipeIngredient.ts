import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';
import { Recipe } from './Recipe';
import { Ingredient } from './Ingredient';

@Entity({ name: 'recipe_ingredients' })
export class RecipeIngredient {
  @PrimaryGeneratedColumn()
  id!: number;

  @ManyToOne(() => Recipe, recipe => recipe.ingredients)
  recipe!: Recipe;

  @ManyToOne(() => Ingredient, ingredient => ingredient.recipeIngredients)
  ingredient!: Ingredient;

  @Column({ type: 'int', default: 1 })
  quantity!: number;

  @Column({ nullable: true })
  unit?: string;

}