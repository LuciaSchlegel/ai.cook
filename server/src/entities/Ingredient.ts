//Ingredient.ts
import { Entity, PrimaryGeneratedColumn, Column, ManyToMany, ManyToOne } from 'typeorm';
import { Tag } from './Tag';
import { Category } from './Category';


@Entity({ name: 'ingredients' })
export class Ingredient {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column({ type: 'varchar', length: 255, unique: true })
  name!: string;

  @ManyToOne(() => Category, { nullable: true })
  category?: Category;

  @ManyToMany(() => Tag, { nullable: true })
  tags?: Tag[]; // ej: ['vegan', 'sin gluten', 'sin lactosa']

  @Column({nullable: true})
  isVegan?: boolean; // Indica si es apto para veganos

  @Column({nullable: true})
  isVegetarian?: boolean; // Indica si es apto para vegetarianos

  @Column({nullable: true})
  isGlutenFree?: boolean; // Indica si es apto para celíacos

  @Column({nullable: true})
  isLactoseFree?: boolean; // Indica si es apto para intolerantes a la lactosa

  @Column({nullable: true})
  image?: string;
}

// Ingredient {
//   title: string;
//   category: Category;
//   tags: Tag[];
//   isVegan: boolean;
//   isVegetarian: boolean;
//   isGlutenFree: boolean;
//   isLactoseFree: boolean;
// }

// Ingredient {
//   title: potatoe;
//   category: Vegetables;
//   tags: ['healthy', 'carbs', 'low-calorie'];
//   isVegan: true;
//   isVegetarian: true;
//   isGlutenFree: true;
//   isLactoseFree: true;
// }