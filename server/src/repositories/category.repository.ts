import { AppDataSource } from "../config/data_source";
import { Category } from "../entities/Category";

export const categoryRepository = AppDataSource.getRepository(Category);