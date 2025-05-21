//Ingredient.ts
import { Entity, PrimaryGeneratedColumn, Column, ManyToMany } from 'typeorm';
import { Recipe } from './Recipe';

@Entity({ name: 'ingredients' })
export class Ingredient {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column({ type: 'varchar', length: 255, unique: true })
  name!: string;

  @Column({ type: 'varchar', length: 100, nullable: true })
  category?: string; // ej: 'verdura', 'carne', 'cereal'

  @Column({ type: 'simple-array', nullable: true })
  tags?: string[]; // ej: ['vegan', 'sin gluten', 'sin lactosa']

  // Relación inversa: en qué recetas aparece este ingrediente
  @ManyToMany(() => Recipe, recipe => recipe.ingredients)
  recipes!: Recipe[];
}