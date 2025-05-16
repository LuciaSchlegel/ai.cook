import { AppDataSource } from "../config/data_source";
import { CustomIngredient } from "../entities/CustomIngredient";

export const CustomIngredientRepository = AppDataSource.getRepository(CustomIngredient);