import { AppDataSource } from "../config/data_source";
import { Recipe } from "../entities/Recipe";

export const RecipeRepository = AppDataSource.getRepository(Recipe);