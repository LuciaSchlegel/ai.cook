import { AppDataSource } from "../config/data_source";
import { Attribute } from "../entities/Attribute";

export const AttributeRepository = AppDataSource.getRepository(Attribute);