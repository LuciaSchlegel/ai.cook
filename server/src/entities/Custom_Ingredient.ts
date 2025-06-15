//CustomIngredient.ts
import { Column, Entity, ManyToOne, PrimaryGeneratedColumn, JoinColumn } from "typeorm";
import { User } from "./User";

@Entity({ name: 'custom_ingredients' })
export class CustomIngredient {
    @PrimaryGeneratedColumn()
    id!: number;

    @Column({ type: 'varchar', length: 255, unique: true })
    name!: string;

    @Column({ nullable: true })
    category?: string; 

    @Column({ type: 'simple-array', nullable: true })
    tags?: string[]; // ej: ['vegan', 'sin gluten', 'sin lactosa']

    @ManyToOne(() => User, user => user.customIngredients, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'uid', referencedColumnName: 'id'})
    createdBy!: User;

}