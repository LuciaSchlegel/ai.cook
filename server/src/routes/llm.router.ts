// routes/llm.router.ts
import { Router, Request, Response, NextFunction } from "express";
import { generateLLMRecipe, talk_to_llm, llmHealthCheck } from "../controllers/llm.controller";

const llmRouter = Router();

// Generate recipe from keywords using LLM
llmRouter.post("/generate", async (req: Request, res: Response, next: NextFunction) => {
    await generateLLMRecipe(req, res);
});

// General chat with LLM
llmRouter.post("/talk", async (req: Request, res: Response, next: NextFunction) => {
    await talk_to_llm(req, res);
});

// Health check for LLM service
llmRouter.get("/health", async (req: Request, res: Response, next: NextFunction) => {
    await llmHealthCheck(req, res);
});

export default llmRouter;
