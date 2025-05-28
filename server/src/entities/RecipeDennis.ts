import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity({name: 'recipes_dennis'})
export class RecipeDennis {
    @PrimaryGeneratedColumn()
    id!: number; 

    @Column()
    title!: string;

    @Column("text", {array: true})
    ingredients!: string[];

    @Column("text", {array: true})
    instructions!: string[];

    @Column("text", { nullable: true })
    servingSuggestion?: string;
}