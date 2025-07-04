// server.ts defines the server functionality 
import { AppDataSource } from "./config/data_source";
import express from "express";
import cors from "cors";
import router from "./routes";
import { errorHandler } from "./utils/errorhandler";

// set up server
const app = express();

//allow cross-origin requests
app.use(cors());
// parse incoming requests with JSON payloads
app.use(express.json());
// parse incoming requests with URL-encoded payloads
app.use(express.urlencoded({ extended: true }));
// include routes // offer routes to frontend 
app.use(router);
// error handling middleware
app.use(errorHandler);


const initializeDatabase = async () => {
  try {
    await AppDataSource.initialize();
    console.log("Database connection established successfully.");
    console.log("Registered Entities:", AppDataSource.options.entities);
  } catch (error) {
    console.error("Error establishing database connection:", error);
  }
};

export { initializeDatabase};
export default app;
