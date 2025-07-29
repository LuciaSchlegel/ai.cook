// controllers/llm.controller.ts
import { Request, Response } from "express";
import { talk_to_llm_service, healthCheck } from "../services/llm.service";

// export async function generateLLMRecipe(req: Request, res: Response) {
//   try {
//     console.log("Received request to generate recipe:", req.body);
//     const { keywords } = req.body;
    
//     if (!keywords || !Array.isArray(keywords) || keywords.length === 0) {
//       return res.status(400).json({ 
//         error: "Keywords array is required and must not be empty" 
//       });
//     }
    
//     const recipe = await generateRecipeFromKeywords({ keywords });
//     res.json({ recipe });
//   } catch (error) {
//     console.error("Controller llm.controller Error generating recipe:", error);
//     res.status(500).json({ 
//       error: error instanceof Error ? error.message : "Error generating recipe" 
//     });
//   }
// }

export async function talk_to_llm(req: Request, res: Response) {
  try {
    console.log("Received request to talk to LLM:", req.body);
    const { prompt } = req.body;
    
    if (!prompt || typeof prompt !== 'string' || prompt.trim().length === 0) {
      return res.status(400).json({ 
        error: "Prompt is required and must be a non-empty string" 
      });
    }
    
    const response = await talk_to_llm_service(prompt);
    res.json({ response });
  } catch (error) {
    console.error("Controller llm.controller Error during LLM call:", error);
    res.status(500).json({ 
      error: error instanceof Error ? error.message : "Error calling LLM service" 
    });
  }
}

export async function llmHealthCheck(req: Request, res: Response) {
  try {
    console.log("Received health check request for LLM service");
    const result = await healthCheck();
    res.json({ status: "healthy", message: result });
  } catch (error) {
    console.error("Controller llm.controller Health check failed:", error);
    res.status(503).json({ 
      status: "unhealthy", 
      error: error instanceof Error ? error.message : "Health check failed" 
    });
  }
} 