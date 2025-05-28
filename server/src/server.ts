import { AppDataSource } from "./config/data_source";
import express from "express";
import cors from "cors";
import router from "./routes";
import { errorHandler } from "./utils/errorhandler";
import { spawn } from "child_process"; // ✅ nur dieser

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

const initializeLLMmicroservice = async () => {
  const pythonProcess = spawn(
    "./llm_microservice/venv/bin/python",
    ["llm_microservice/main.py"]
  );

  console.log("LLM microservice initialized.");

  pythonProcess.stdout.on("data", (data) => {
    console.log(`[Python stdout]: ${data}`);
  });

  pythonProcess.stderr.on("data", (data) => {
    console.error(`[Python error]: ${data}`);
  });

  pythonProcess.on("close", (code) => {
    console.log(`[Python closed with code]: ${code}`);
  });
};

app.use(errorHandler);

export { initializeDatabase, initializeLLMmicroservice };
export default app;
