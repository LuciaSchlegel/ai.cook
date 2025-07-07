import { AppDataSource } from "../config/data_source";
import { Tag } from "../entities/Tag";

export const TagRepository = AppDataSource.getRepository(Tag);