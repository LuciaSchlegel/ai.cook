import { Column, Entity, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import { Ingredient } from "./Ingredient";

@Entity({ name: 'categories' })
export class Category {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column({ type: 'varchar', length: 100, nullable: false, unique: true })
  name!: string;

  @OneToMany(() => Ingredient, ingredient => ingredient.category)
  ingredients?: Ingredient[];
}