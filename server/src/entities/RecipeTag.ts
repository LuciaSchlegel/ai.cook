import { Entity, PrimaryGeneratedColumn, ManyToMany, Column } from 'typeorm';
import { Recipe } from './Recipe';

@Entity({ name: 'recipe_tags' })
export class RecipeTag {
  @PrimaryGeneratedColumn()
  id!: number;
  
  @Column({ type: 'varchar', length: 255, unique: true })
  name!: string;

  @ManyToMany(() => Recipe, recipe => recipe.tags)
  recipes!: Recipe[];
}