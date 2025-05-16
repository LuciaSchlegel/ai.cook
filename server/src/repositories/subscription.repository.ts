import { AppDataSource } from "../config/data_source";
import { Subscription } from "../entities/Subscription";

export const SubscriptionRepository = AppDataSource.getRepository(Subscription);