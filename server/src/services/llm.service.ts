// services/llm.service.ts
import axios from "axios";
import { PromptResponse } from "../types/llm.types";
import { RecipeDennis } from "../entities/RecipeDennis";
import { AppDataSource } from "../config/data_source";
import { parse } from "path";
import { talk_to_llm } from "../controllers/llm.controller";


//first service function asks the llm micro service for a recipe based on keywords
//the promt and api conncetion is in the python microservice
// this function returns a RecipeDennis object
// has only strings //TODO: ingredients should be an array of Ingredient objects
// the recipe is saved in the database
// has a helper function to parse the recipe data from the response

//second service function is a generic function to talk to the llm service
export async function generateRecipeFromKeywords(keywords: string[]): Promise<RecipeDennis> {
  const response = await axios.post<PromptResponse>(
    "http://localhost:8000/api/get-recepies",
    { keywords }
  );

    if (!response.data || !response.data.recipe) {
        throw new Error("Failed to generate recipe");
    }
    const recipeData = response.data.recipe;

    console.log("Received recipe data:", recipeData);

    // parse the recipe data
    const recipe = parseRecepieData2(recipeData);


  console.log("Generated recipe: title", recipe.title, "instructions", recipe.instructions);

  //save
  await AppDataSource.getRepository(RecipeDennis).save(recipe);

  //die save response returnen oder das rezept?

  return recipe;
}


function parseRecepieData2(recipeRaw: string): RecipeDennis {
  // Entferne mögliche Markdown-Formatierung wie ```json ... ```
  const cleaned = recipeRaw
    .replace(/```json/, '')
    .replace(/```/, '')
    .trim();
    const recipe = new RecipeDennis();

try{
  const parsed = JSON.parse(cleaned); // Jetzt echtes JSON
  console.log("Parsed recipe:", parsed);
    recipe.title = parsed.title;
  recipe.ingredients = parsed.ingredients;
  recipe.instructions = parsed.instructions;
  recipe.servingSuggestion = parsed.servingSuggestion;
}catch (error) {
  console.error("Error parsing recipe data:", error);
}

  return recipe;
}

export async function talk_to_llm_service(prompt: string): Promise<string> {
  try {
    console.log("service with prompt:", prompt);
    const response = await axios.post("http://localhost:8000/api/talk-to-chat", { prompt });
    return response.data.response;
  } catch (error) {
    console.error("Error talking to LLM service:", error);
    throw new Error("Failed to communicate with LLM service");
  }
}