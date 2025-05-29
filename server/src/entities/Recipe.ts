//Recipe.ts
import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, ManyToMany, JoinTable, CreateDateColumn, UpdateDateColumn } from 'typeorm';
import { User } from './User';
import { Ingredient } from './Ingredient';

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
  creator?: User;

  // Relación: ingredientes de la receta (ManyToMany)
  //@ManyToMany(() => Ingredient, ingredient => ingredient.recipes, { cascade: true })
  //@JoinTable()
  //ingredients!: Ingredient[];

  @Column('simple-array', { nullable: true })
  steps?: string[];

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;
}