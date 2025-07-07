// routes/llm.router.ts
import { Router } from "express";
import { generateLLMRecipe, talk_to_llm } from "../controllers/llm.controller";

const llmRouter = Router();

llmRouter.post("/generate", generateLLMRecipe);

llmRouter.post("/talk", talk_to_llm )

export default llmRouter;
