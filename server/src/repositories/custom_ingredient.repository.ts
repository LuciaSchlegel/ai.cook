import { AppDataSource } from "../config/data_source";
import { CustomIngredient } from "../entities/Custom_Ingredient";

export const CustomIngredientRepository = AppDataSource.getRepository(CustomIngredient);