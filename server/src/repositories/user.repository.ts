import { AppDataSource } from "../config/data_source";
import { User } from "../entities/user";

export const UserRepository = AppDataSource.getRepository(User);