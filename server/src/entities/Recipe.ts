//Recipe.ts
import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, CreateDateColumn, UpdateDateColumn, OneToMany, JoinTable, ManyToMany } from 'typeorm';
import { User } from './User';
import { RecipeTag } from './RecipeTag';
import { RecipeIngredient } from './RecipeIngredient';

@Entity({ name: 'recipes' })
export class Recipe {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column({ type: 'varchar', length: 255 })
  name!: string;

  @Column('text')
  description!: string;

  // Relación: El usuario que creó la receta (opcional, o puede ser 'system'/'ia')
  @ManyToOne(() => User, user => user.recipes, { nullable: true })
  createdByUser?: User;

  @OneToMany(() => RecipeIngredient, recipeIngredient => recipeIngredient.recipe)
  ingredients!: RecipeIngredient[];

  @Column('simple-json', { nullable: true })
  steps?: string[];

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;

  @Column({ nullable: true })
  image?: string;

  @Column({ nullable: true })
  cookingTime?: string;

  @Column({ nullable: true })
  difficulty?: string;

  @Column({ nullable: true })
  servings?: string;

  @ManyToMany(() => RecipeTag, recipeTag => recipeTag.recipes)
  @JoinTable({
    name: 'recipe_recipe_tags', // tabla intermedia
    joinColumn: { name: 'recipe_id', referencedColumnName: 'id' },
    inverseJoinColumn: { name: 'recipe_tag_id', referencedColumnName: 'id' }
  })
  tags!: RecipeTag[];
}