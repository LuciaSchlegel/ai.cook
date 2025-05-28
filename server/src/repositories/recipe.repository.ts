import { AppDataSource } from "../config/data_source";
import { Recipe } from "../entities/recipe";

export const RecipeRepository = AppDataSource.getRepository(Recipe);