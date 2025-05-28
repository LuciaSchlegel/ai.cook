import { AppDataSource } from "../config/data_source";
import { Subscription } from "../entities/subscription";

export const SubscriptionRepository = AppDataSource.getRepository(Subscription);