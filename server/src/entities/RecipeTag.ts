import { Entity, PrimaryGeneratedColumn, ManyToOne, Column } from 'typeorm';
import { Recipe } from './Recipe';

@Entity({ name: 'recipe_tags' })
export class RecipeTag {
  @PrimaryGeneratedColumn()
  id!: number;
  
  @Column({ type: 'varchar', length: 255 })
  name!: string;

  @ManyToOne(() => Recipe, recipe => recipe.tags)
  recipe!: Recipe;
}