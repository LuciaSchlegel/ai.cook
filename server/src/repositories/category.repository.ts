import { AppDataSource } from "../config/data_source";
import { Category } from "../entities/Category";

export const CategoryRepository = AppDataSource.getRepository(Category);