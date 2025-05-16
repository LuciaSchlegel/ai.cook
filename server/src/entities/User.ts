import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, OneToOne, OneToMany } from 'typeorm';
import { Subscription } from './Subscription';
import { Attribute } from './Attribute';

enum UserRole {
    USER = 'user',
    ADMIN = 'admin',
}

@Entity({ name: 'users' })
export class User {
    @PrimaryGeneratedColumn()
    id!: number;

    @Column({ unique: true })
    uid!: string;

    @Column({ type: 'varchar', length: 255, nullable: false })
    firstName!: string;

    @Column({ type: 'varchar', length: 255, nullable: false })
    lastName!: string;

    @Column({ type: 'varchar', length: 255, nullable: false })
    email!: string;

    @Column({ type: 'varchar', length: 255, nullable: false })
    phone!: string;

    @Column({ type: 'varchar', length: 255, nullable: false })
    address!: string;

    @Column({ type: 'varchar', length: 255, nullable: false })
    password!: string;

    @Column({ nullable: false, default: UserRole.USER })
    role!: UserRole;

    @CreateDateColumn({ name: "created_at" })
    createdAt!: Date;

    @UpdateDateColumn({ name: "updated_at" })
    updatedAt!: Date;

    @Column({ default: false })
    isDeleted!: boolean;

    @OneToOne(() => Subscription, subscription => subscription.user)
    subscription!: Subscription;

    @OneToMany(() => Attribute, attribute => attribute.user)
    attributes!: Attribute[];
}