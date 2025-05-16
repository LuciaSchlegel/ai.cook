//Event.ts
import { Entity, PrimaryGeneratedColumn, Column, ManyToMany } from 'typeorm';
import { Recipe } from './Recipe';

@Entity({ name: 'ingredients' })
export class Ingredient {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column({ type: 'varchar', length: 255, unique: true })
  name!: string;

  // Relación inversa: en qué recetas aparece este ingrediente
  @ManyToMany(() => Recipe, recipe => recipe.ingredients)
  recipes!: Recipe[];
}