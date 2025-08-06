import { AppDataSource } from "../config/data_source";
import { DietaryTag } from "../entities/DietaryTag";

export const DietaryTagRepository = AppDataSource.getRepository(DietaryTag);