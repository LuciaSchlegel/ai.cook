import { AppDataSource } from "../config/data_source";
import { Unit } from "../entities/Unit";

export const UnitRepository = AppDataSource.getRepository(Unit); 