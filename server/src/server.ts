import { AppDataSource } from "./config/data_source"
import express from "express";
import cors from "cors";
import router from "./routes";

const app = express();

app.use(cors());
app.use(express.json());
app.use(router);

const initializeDatabase = async () => {
    try {
        await AppDataSource.initialize();
        console.log("Database connection established successfully.");
    } catch (error) {
        console.error("Error establishing database connection:", error);
    }
};

export { initializeDatabase };
export default app;