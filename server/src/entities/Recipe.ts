//Recipe.ts
import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, CreateDateColumn, UpdateDateColumn, OneToMany } from 'typeorm';
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

  @Column('simple-array', { nullable: true })
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

  @OneToMany(() => RecipeTag, tag => tag.recipe)
  tags!: RecipeTag[];
}