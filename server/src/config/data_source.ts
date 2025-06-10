import 'reflect-metadata';
import { DataSource } from 'typeorm';
import { Subscription } from '../entities/Subscription';
import { Attribute } from '../entities/Attribute';
import { UserIngredient } from '../entities/UserIngredient';
import { Recipe } from '../entities/Recipe';
import { Event } from '../entities/Event';
import { Ingredient } from '../entities/Ingredient';
import dotenv from 'dotenv';
import { Tag } from '../entities/Tag';
import { User } from '../entities/User';
import { RecipeIngredient } from '../entities/RecipeIngredient';
import { Category } from '../entities/Category';
import { RecipeTag } from '../entities/RecipeTag';
import { CustomIngredient } from '../entities/Custom_Ingredient';

dotenv.config();

export const AppDataSource = new DataSource({
  type: 'postgres',
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '5432'),
  username: process.env.DB_USERNAME || 'luciaschlegel',
  password: process.env.DB_PASSWORD ,
  database: process.env.DB_NAME,
  entities: [ User, Ingredient, Tag, Recipe, Event, UserIngredient, Attribute, Subscription, RecipeIngredient, Category, RecipeTag, CustomIngredient ],
  synchronize: true, // True solo para desarrollo (genera tablas automáticamente)
  logging: false,
  ssl: {
    rejectUnauthorized: false,
  },
  //dropSchema: true,  if you want to reset the db content 
});