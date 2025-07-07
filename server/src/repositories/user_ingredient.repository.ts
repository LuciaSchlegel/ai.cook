import { AppDataSource } from "../config/data_source";
import { UserIngredient } from "../entities/UserIngredient";

export const UserIngredientRepository = AppDataSource.getRepository(UserIngredient);