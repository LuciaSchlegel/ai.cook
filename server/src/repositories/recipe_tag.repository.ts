import { AppDataSource } from "../config/data_source";
import { RecipeTag } from "../entities/RecipeTag";

export const RecipeTagRepository = AppDataSource.getRepository(RecipeTag);