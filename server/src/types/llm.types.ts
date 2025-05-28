// types/llm.types.ts
export interface PromptRequest {
  keywords: string[];
}

export interface PromptResponse {
  recipe: string;
  
  /*
  {
    title: string;
    ingredients: string[];
    instructions: string[];
    servingSuggestion?: string;
  };
  */
}

