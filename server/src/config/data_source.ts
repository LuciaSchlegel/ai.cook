import 'reflect-metadata';
import { DataSource } from 'typeorm';
import { Subscription } from '../entities/Subscription';
import { Attribute } from '../entities/Attribute';
import { UserIngredient } from '../entities/UserIngredient';
import { Recipe } from '../entities/Recipe';
import { Event } from '../entities/Event';
import { Ingredient } from '../entities/Ingredient';
import dotenv from 'dotenv';
import { RecipeDennis } from '../entities/RecipeDennis';
import { Tag } from '../entities/Tag';

dotenv.config();
console.log('DB_HOST:', process.env.DB_HOST);


export const AppDataSource = new DataSource({
  type: 'postgres',
  host: process.env.DB_HOST || 'localhost',
  port: 5432,
  username: process.env.DB_USERNAME || 'luciaschlegel',
  password: process.env.DB_PASSWORD ,
  database: 'aicook',
  entities: [ RecipeDennis, Ingredient, Tag ],
  //User, Subscription, Attribute, UserIngredient, Recipe, Event, Ingredient,
  synchronize: true, // True solo para desarrollo (genera tablas automáticamente)
  logging: false,
});