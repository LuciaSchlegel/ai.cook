import { AppDataSource } from "../config/data_source";
import { Ingredient } from "../entities/Ingredient";

export const IngredientRepository = AppDataSource.getRepository(Ingredient);