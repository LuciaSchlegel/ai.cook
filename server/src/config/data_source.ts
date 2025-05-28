import 'reflect-metadata';
import { DataSource } from 'typeorm';
import { User } from '../entities/User';
import { Subscription } from '../entities/Subscription';
import { Attribute } from '../entities/Attribute';
import { UserIngredient } from '../entities/UserIngredient';
import { Recipe } from '../entities/Recipe';
import { Event } from '../entities/Event';
import { Ingredient } from '../entities/Ingredient';
import dotenv from 'dotenv';
import { RecipeDennis } from '../entities/RecipeDennis';

dotenv.config();

export const AppDataSource = new DataSource({
  type: 'postgres',
  host: 'localhost',
  port: 5432,
  username: 'luciaschlegel',
  password: process.env.DB_PASSWORD,
  database: 'aicook',
  entities: [ RecipeDennis],
  //User, Subscription, Attribute, UserIngredient, Recipe, Event, Ingredient,
  synchronize: true, // True solo para desarrollo (genera tablas automáticamente)
  logging: false,
});