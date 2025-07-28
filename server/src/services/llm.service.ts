import axios from 'axios';

// Configuration for the Python LLM microservice
const LLM_SERVICE_URL = process.env.LLM_SERVICE_URL || 'http://127.0.0.1:8000';
const LLM_API_TIMEOUT = 30000; // 30 seconds

export interface LLMConfig {
  timeout?: number;
}

export interface RecipeGenerationRequest {
  keywords: string[];
}

export interface RecipeGenerationResponse {
  title: string;
  ingredients: string[];
  instructions: string[];
  cookingTime?: string;
  servings?: string;
  servingSuggestion?: string;
}

export interface ChatRequest {
  prompt: string;
}

export interface ChatResponse {
  response: string;
}

/**
 * Main function for communicating with LLM via Python microservice
 * Used by AI recommendation service
 * @param prompt The prompt to send to the LLM
 * @param config Optional configuration for the request
 * @returns The LLM's response as a string
 */
export async function talk_to_llm_service(
  prompt: string,
  config: LLMConfig = {}
): Promise<string> {
  try {
    console.log('🤖 Sending prompt to Python LLM service...');
    
    if (!prompt || prompt.trim().length === 0) {
      throw new Error('Prompt cannot be empty');
    }

    const { timeout = LLM_API_TIMEOUT } = config;

    const requestBody: ChatRequest = {
      prompt: prompt.trim()
    };

    console.log(`📡 Calling ${LLM_SERVICE_URL}/api/talk-to-chat`);

    const response = await axios.post<ChatResponse>(
      `${LLM_SERVICE_URL}/api/talk-to-chat`,
      requestBody,
      {
        headers: {
          'Content-Type': 'application/json',
          'Connection': 'close',
        },
        timeout,
      }
    );

    if (!response.data?.response) {
      throw new Error('No valid response received from LLM service');
    }

    console.log('✅ LLM service response received successfully');
    return response.data.response;

  } catch (error) {
    console.error('❌ Error calling Python LLM service:', error);
    
    if (axios.isAxiosError(error)) {
      if (error.code === 'ECONNREFUSED') {
        throw new Error('LLM service is not available. Please make sure the Python microservice is running on ' + LLM_SERVICE_URL + '. Try: cd llm_microservice && python app.py');
      }
      
      if (error.response) {
        throw new Error(`LLM service error (${error.response.status}): ${error.response.data?.message || error.response.statusText}`);
      }
      
      if (error.request) {
        throw new Error('No response received from LLM service. Please check if the service is running.');
      }
    }
    
    if (error instanceof Error) {
      throw new Error(`LLM Service Error: ${error.message}`);
    }
    
    throw new Error('Unknown error occurred while calling LLM service');
  }
}

/**
 * Specialized function for generating recipes from keywords
 * Uses the Python microservice's recipe generation endpoint
 * @param request Recipe generation request with keywords
 * @returns Structured recipe response
 */
export async function generateRecipeFromKeywords(
  request: RecipeGenerationRequest
): Promise<RecipeGenerationResponse> {
  try {
    console.log('🍳 Generating recipe from keywords via Python service:', request.keywords);

    if (!request.keywords || request.keywords.length === 0) {
      throw new Error('Keywords array cannot be empty');
    }

    const requestBody = {
      keywords: request.keywords
    };

    console.log(`📡 Calling ${LLM_SERVICE_URL}/api/get-recepies`);

    const response = await axios.post(
      `${LLM_SERVICE_URL}/api/get-recepies`,
      requestBody,
      {
        headers: {
          'Content-Type': 'application/json',
          'Connection': 'close',
        },
        timeout: LLM_API_TIMEOUT,
      }
    );

    if (!response.data?.recipe) {
      throw new Error('No recipe received from LLM service');
    }

    // The Python service returns a JSON string, so we need to parse it
    let recipe: RecipeGenerationResponse;
    try {
      if (typeof response.data.recipe === 'string') {
        recipe = JSON.parse(response.data.recipe) as RecipeGenerationResponse;
      } else {
        recipe = response.data.recipe as RecipeGenerationResponse;
      }
    } catch (parseError) {
      console.error('❌ Failed to parse recipe JSON from Python service:', parseError);
      throw new Error('Invalid recipe format received from LLM service');
    }

    // Validate that required fields are present
    if (!recipe.title || !recipe.ingredients || !recipe.instructions) {
      throw new Error('Invalid recipe structure received from LLM service');
    }

    console.log('✅ Recipe generated successfully:', recipe.title);
    return recipe;

  } catch (error) {
    console.error('❌ Error generating recipe:', error);
    
    if (axios.isAxiosError(error)) {
      if (error.code === 'ECONNREFUSED') {
        throw new Error('Recipe generation service is not available. Please make sure the Python microservice is running on ' + LLM_SERVICE_URL + '. Try: cd llm_microservice && python app.py');
      }
    }
    
    throw error;
  }
}

/**
 * Health check function to verify LLM service is working
 * @returns Success message if service is operational
 */
export async function healthCheck(): Promise<string> {
  try {
    console.log('🏥 Performing health check on LLM service...');
    
    const response = await talk_to_llm_service(
      'Respond with exactly "LLM service is working" in English',
      { timeout: 10000 }
    );
    
    console.log('✅ Health check successful');
    return response;
  } catch (error) {
    console.error('❌ Health check failed:', error);
    throw new Error(`Health check failed: ${error}`);
  }
}

/**
 * Check if the Python LLM microservice is reachable
 * @returns Promise that resolves to true if service is reachable
 */
export async function checkServiceHealth(): Promise<boolean> {
  try {
    console.log('🔍 Checking if Python LLM service is reachable...');
    
    // Try a simple request to see if the service responds
    await axios.get(`${LLM_SERVICE_URL}/health`, {
      timeout: 5000,
      headers: {
        'Connection': 'close',
      },
    });
    
    console.log('✅ Python LLM service is reachable');
    return true;
  } catch (error) {
    console.log('❌ Python LLM service is not reachable:', error);
    return false;
  }
}
