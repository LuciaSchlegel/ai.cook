//Ingredient.ts
import { Entity, PrimaryGeneratedColumn, Column, ManyToMany, ManyToOne, OneToMany, JoinTable } from 'typeorm';
import { Tag } from './Tag';
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

  @ManyToMany(() => Tag, { nullable: true })
  @JoinTable({
    name: 'ingredient_tags',
    joinColumn: { name: 'ingredient_id', referencedColumnName: 'id' },
    inverseJoinColumn: { name: 'tag_id', referencedColumnName: 'id' }
  })
  tags?: Tag[]; // ej: ['low-fat', 'high-protein', 'healthy']

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

