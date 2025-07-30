import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';
import { Recipe } from './Recipe';
import { Ingredient } from './Ingredient';
import { Unit } from './Unit';

@Entity({ name: 'recipe_ingredients' })
export class RecipeIngredient {
  @PrimaryGeneratedColumn()
  id!: number;

  @ManyToOne(() => Recipe, recipe => recipe.ingredients)
  recipe!: Recipe;

  @ManyToOne(() => Ingredient, ingredient => ingredient.recipeIngredients)
  ingredient!: Ingredient;

  @Column({ type: 'decimal', precision: 8, scale: 3, default: 1 })
  quantity!: number;

  @ManyToOne(() => Unit, { nullable: true })
  unit?: Unit;
}