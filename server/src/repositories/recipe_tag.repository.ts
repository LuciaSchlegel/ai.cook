import { AppDataSource } from "../config/data_source";
import { RecipeTag } from "../entities/RecipeTag";

export const recipeTagRepository = AppDataSource.getRepository(RecipeTag);