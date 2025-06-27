import { Column, CreateDateColumn, Entity, JoinColumn, ManyToOne, PrimaryGeneratedColumn } from "typeorm";
import { User } from "./User";
  
  @Entity({ name: 'external_recipes' })
  export class ExternalRecipe {
    @PrimaryGeneratedColumn()
    id!: number;
  
    @Column()
    spoonacularId!: number;
  
    @Column()
    title!: string;
  
    @Column()
    image!: string;
  
    @Column({ nullable: true })
    summary?: string;
  
    @Column()
    readyInMinutes!: number;
  
    @Column()
    servings!: number;
  
    @Column('jsonb')
    extendedIngredients!: {
      id: number;
      name: string;
      original: string;
      amount: number;
      unit: string;
    }[];
  
    @Column('jsonb')
    steps!: {
      number: number;
      step: string;
    }[];
  
    @Column('jsonb', { nullable: true })
    nutrition?: {
      name: string;
      amount: number;
      unit: string;
      percentOfDailyNeeds: number;
    }[];
  
    @Column('text', { array: true, nullable: true })
    cuisines?: string[];
  
    @Column('text', { array: true, nullable: true })
    dishTypes?: string[];
  
    @Column('text', { array: true, nullable: true })
    diets?: string[];
  
    @Column('text', { array: true, nullable: true })
    intolerances?: string[];
  
    @CreateDateColumn()
    savedAt!: Date;
  
    @ManyToOne(() => User, user => user.savedExternalRecipes, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'uid', referencedColumnName: 'uid' })
    savedBy!: User;
  }