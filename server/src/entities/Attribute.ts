//Attribute.ts
import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';
import { User } from './user';

@Entity({ name: 'attributes' })
export class Attribute {
    @PrimaryGeneratedColumn()
    id!: number;

    @Column()
    key!: string; // ej: 'dieta', 'lifestyle', 'allergy', etc.

    @Column()
    value!: string; // ej: 'vegetariano', 'sin gluten', etc.

    @ManyToOne(() => User, user => user.attributes, { onDelete: 'CASCADE' })
    user!: User;
}