// controllers/llm.controller.ts
import { Request, Response } from "express";
import { generateRecipeFromKeywords, talk_to_llm_service } from "../services/llm.service";

export async function generateLLMRecipe(req: Request, res: Response) {
  const { keywords } = req.body;
  const recipe = await generateRecipeFromKeywords(keywords);
  res.json({ recipe });
}

export async function talk_to_llm(req: Request, res: Response) {
  try {
    console.log("Received request to talk to LLM:", req.body);
    const { prompt } = req.body;
    const response = await talk_to_llm_service(prompt);
    res.json({ response });
  } catch (error) {
    console.error("Fehler beim LLM-Call:", error);
    res.status(500).json({ error: "Fehler beim LLM-Dienst." });
  }
} 