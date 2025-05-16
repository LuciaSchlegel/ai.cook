import { AppDataSource } from "../config/data_source";
import { Event } from "../entities/Event";

export const EventRepository = AppDataSource.getRepository(Event);