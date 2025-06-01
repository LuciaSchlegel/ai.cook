// server.ts defines the server functionality 
import { AppDataSource } from "./config/data_source";
import express from "express";
import cors from "cors";
import router from "./routes";
import { errorHandler } from "./utils/errorhandler";
import { spawn } from "child_process"; // ✅ nur dieser
import { loadIngredientsFromLocalFile } from "./services/ingredient.service";


// set up server
const app = express();

//allow cross-origin requests
app.use(cors());
// parse incoming requests with JSON payloads
app.use(express.json());
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

const initializeIngredients = async () => {
  try {
    await loadIngredientsFromLocalFile();
    console.log("Ingredients loaded from local file successfully.");
  } catch (error) {
    console.error("Error loading ingredients from local file:", error);
  }
}

const initializeLLMmicroservice = async () => {
  const isWindows = process.platform === "win32";
  const pythonPath = isWindows
    ? "./llm_microservice/venv/Scripts/python.exe"
    : "./llm_microservice/venv/bin/python";

  console.log("LLM microservice initialized.");

  const pythonProcess = spawn(pythonPath, ["llm_microservice/main.py"]);

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

export { initializeDatabase, initializeLLMmicroservice , initializeIngredients};
export default app;
