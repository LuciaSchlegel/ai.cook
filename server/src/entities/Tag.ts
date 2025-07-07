import { Column, Entity, ManyToMany, PrimaryGeneratedColumn } from "typeorm";
import { Ingredient } from "./Ingredient";

@Entity({ name: 'tags' })
export class Tag {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column({ type: 'varchar', length: 100, nullable: false, unique: true })
  name!: string;

  @ManyToMany(() => Ingredient, ingredient => ingredient.tags)
  ingredients!: Ingredient[];
}