//Event.ts
import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, ManyToMany, JoinTable, CreateDateColumn } from 'typeorm';
import { User } from './user';
import { Recipe } from './recipe';

@Entity({ name: 'events' })
export class Event {
  @PrimaryGeneratedColumn()
  id!: number;

  @ManyToOne(() => User, user => user.events, { onDelete: 'CASCADE' })
  user!: User;

  @Column({ type: 'timestamp' })
  eventDate!: Date;

  @Column({ type: 'varchar', length: 255, nullable: true })
  title!: string;

  @ManyToMany(() => Recipe, { cascade: true })
  @JoinTable()
  recipes!: Recipe[]; // ej: recetas del día/evento

  @CreateDateColumn()
  createdAt!: Date;
}