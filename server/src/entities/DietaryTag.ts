import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity({ name: 'dietary_tags' })
export class DietaryTag {
  @PrimaryGeneratedColumn()
  id!: number;
  
  @Column({ type: 'varchar', length: 255, unique: true })
  name!: string;
}