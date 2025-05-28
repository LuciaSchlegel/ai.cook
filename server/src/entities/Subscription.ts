//Subscription.ts
import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, CreateDateColumn, UpdateDateColumn, OneToOne, JoinColumn } from 'typeorm';
import { User } from './user';

enum SubscriptionType {
    FREE = 'free',
    PREMIUM = 'premium',
    PRO = 'pro',
}

@Entity({ name: 'subscriptions' })
export class Subscription {
  @PrimaryGeneratedColumn()
  id!: number;

  @OneToOne(() => User, user => user.subscription, { onDelete: 'CASCADE' })
  @JoinColumn()
  user!: User;

  @Column({ type: 'enum', enum: SubscriptionType, default: SubscriptionType.FREE })
  type!: SubscriptionType;

  @Column({ type: 'timestamp', nullable: true })
  startDate?: Date;

  @Column({ type: 'timestamp', nullable: true })
  endDate?: Date;

  @Column({ type: 'boolean', default: false })
  isActive!: boolean;

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;
}