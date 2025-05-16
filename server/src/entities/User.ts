//User.ts
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, OneToOne, OneToMany } from 'typeorm';
import { Subscription } from './Subscription';
import { Attribute } from './Attribute';
import { UserIngredient } from './UserIngredient';
import { Recipe } from './Recipe';
import { Event } from './Event';
import { CustomIngredient } from './CustomIngredient';

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

    @OneToMany(() => UserIngredient, userIngredient => userIngredient.user)
    userIngredients!: UserIngredient[];

    @OneToMany(() => CustomIngredient, customIngredient => customIngredient.createdBy)
    customIngredients!: CustomIngredient[];

    @OneToMany(() => Recipe, recipe => recipe.creator)
    recipes!: Recipe[];

    @OneToMany(() => Event, event => event.user)
    events!: Event[];
}