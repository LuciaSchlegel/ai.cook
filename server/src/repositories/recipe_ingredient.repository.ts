import { AppDataSource } from "../config/data_source";
import { RecipeIngredient } from "../entities/RecipeIngredient";

export const RecipeIngredientRepository = AppDataSource.getRepository(RecipeIngredient);