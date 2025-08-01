//CustomIngredient.ts
import { Column, Entity, ManyToOne, PrimaryGeneratedColumn, JoinColumn } from "typeorm";
import { User } from "./User";
import { Category } from "./Category";

@Entity({ name: 'custom_ingredients' })
export class CustomIngredient {
    @PrimaryGeneratedColumn()
    id!: number;

    @Column({ type: 'varchar', length: 255, unique: false })
    name!: string;

    @ManyToOne(() => Category, { nullable: true })
    category?: Category;

    @Column({nullable: false, default: false})
    isVegan!: boolean; 

    @Column({nullable: false, default: false})
    isVegetarian!: boolean;

    @Column({nullable: false, default: false})
    isGlutenFree!: boolean;

    @Column({nullable: false, default: false})
    isLactoseFree!: boolean;

    @ManyToOne(() => User, user => user.customIngredients, { onDelete: 'SET NULL' })
    @JoinColumn({ name: 'uid', referencedColumnName: 'uid' })
    createdBy?: User;
}