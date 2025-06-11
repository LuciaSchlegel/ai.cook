import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity({ name: 'units' })
export class Unit {
    @PrimaryGeneratedColumn()
    id!: number;

    @Column({ type: 'varchar', length: 50, unique: true })
    name!: string;

    @Column({ type: 'varchar', length: 10, unique: true })
    abbreviation!: string;

    @Column({ type: 'varchar', length: 50, nullable: true })
    type?: string; // 'weight', 'volume', 'quantity', etc.
} 