import { AppDataSource } from "./config/data_source"
import express from "express";
import cors from "cors";
import router from "./routes";
import { errorHandler } from "./utils/errorHandler";

const app = express();

app.use(cors());
app.use(express.json());
app.use(router);

const initializeDatabase = async () => {
    try {
        await AppDataSource.initialize();
        console.log("Database connection established successfully.");
        console.log("Registered Entities:", AppDataSource.options.entities);

    } catch (error) {
        console.error("Error establishing database connection:", error);
    }
};

// Middleware for handling errors
app.use(errorHandler);

export { initializeDatabase };
export default app;