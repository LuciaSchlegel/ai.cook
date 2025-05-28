import 'reflect-metadata';
import { DataSource } from 'typeorm';
import { Subscription } from '../entities/subscription';
import { Attribute } from '../entities/Attribute';
import { UserIngredient } from '../entities/UserIngredient';
import { Recipe } from '../entities/recipe';
import { Event } from '../entities/Event';
import { Ingredient } from '../entities/Ingredient';
import { User } from '../entities/user';

export const AppDataSource = new DataSource({
  type: 'postgres',
  host: 'localhost',
  port: 5432,
  username: 'luciaschlegel',
  password: '152509',
  database: 'aicook',
  entities: [User, Subscription, Attribute, UserIngredient, Recipe, Event, Ingredient],
  synchronize: true, // True solo para desarrollo (genera tablas automáticamente)
  logging: false,
});