//CustomIngredient.ts
import { Column, Entity, ManyToOne, PrimaryGeneratedColumn, JoinColumn, ManyToMany, JoinTable } from "typeorm";
import { User } from "./User";
import { Category } from "./Category";
import { Tag } from "./Tag";

@Entity({ name: 'custom_ingredients' })
export class CustomIngredient {
    @PrimaryGeneratedColumn()
    id!: number;

    @Column({ type: 'varchar', length: 255, unique: false })
    name!: string;

    @ManyToOne(() => Category, { nullable: true })
    category?: Category;

    @ManyToMany(() => Tag, { nullable: true })
    @JoinTable({
        name: 'custom_ingredient_tags',
        joinColumn: { name: 'custom_ingredient_id', referencedColumnName: 'id' },
        inverseJoinColumn: { name: 'tag_id', referencedColumnName: 'id' }
    })
    tags?: Tag[];

    @ManyToOne(() => User, user => user.customIngredients, { onDelete: 'SET NULL' })
    @JoinColumn({ name: 'uid', referencedColumnName: 'uid' })
    createdBy?: User;
}