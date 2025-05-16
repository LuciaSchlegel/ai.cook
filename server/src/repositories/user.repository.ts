import { AppDataSource } from "../config/data_source";
import { User } from "../entities/User";

export const UserRepository = AppDataSource.getRepository(User);