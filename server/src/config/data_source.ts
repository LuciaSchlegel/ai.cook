import 'reflect-metadata';
import { DataSource } from 'typeorm';

export const AppDataSource = new DataSource({
  type: 'postgres',
  host: 'localhost',
  port: 5432,
  username: 'luciaschlegel',
  password: '152509',
  database: 'aicook',
  entities: [__dirname + '/entities/*.ts'],
  synchronize: true, // True solo para desarrollo (genera tablas automáticamente)
  logging: false,
});