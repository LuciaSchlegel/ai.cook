//Ingredient.ts
import { Entity, PrimaryGeneratedColumn, Column, ManyToMany } from 'typeorm';
import { Recipe } from './Recipe';


@Entity({ name: 'ingredients' })
export class Ingredient {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column({ type: 'varchar', length: 255, unique: true })
  name!: string;

  @Column({nullable: true, type: 'text'})
  description?: string; // Descripción del ingrediente

  @Column({ type: 'varchar', length: 100, nullable: true })
  category?: string; // ej: 'verdura', 'carne', 'cereal'

  @Column({ type: 'simple-array', nullable: true })
  tags?: string[]; // ej: ['vegan', 'sin gluten', 'sin lactosa']

  @Column({nullable: true})
  isVegan?: boolean; // Indica si es apto para veganos

  @Column({nullable: true})
  isVegetarian?: boolean; // Indica si es apto para vegetarianos

  @Column({nullable: true})
  isGlutenFree?: boolean; // Indica si es apto para celíacos

  @Column({nullable: true})
  isLactoseFree?: boolean; // Indica si es apto para intolerantes a la lactosa

  // Relación inversa: en qué recetas aparece este ingrediente
  //@ManyToMany(() => Recipe, recipe => recipe.ingredients)
  //recipes!: Recipe[];

  @Column({nullable: true})
  image?: string;
}