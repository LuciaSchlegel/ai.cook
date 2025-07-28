from fastapi import APIRouter
from models.keyword_request import ChatRequest, KeywordRequest
from dotenv import load_dotenv
import os
import json
from openai import OpenAI

# Load environment variables
load_dotenv()

# Read API Key and strip spaces or newlines
apikey = os.getenv("OPENAI_API_KEY", "").strip()

# Verify that the key was actually read
print(f"API Key: {apikey[:10]}...")  # Only print first characters for security

# Initialize OpenAI client
client = OpenAI(api_key=apikey)

router = APIRouter()

""" endpoint to communicate with the llm api
    expects a json request with a "prompt" field
    and returns the llm response as json
 """
@router.post("/talk-to-chat")
async def talk_to_chat(request: ChatRequest):
    """
    chat endpoint: directly communicate with OpenAI
    """
    if not request.prompt or request.prompt.strip() == "":
        return {"error": "No prompt received or prompt is empty"}
    
    try:
        # Make the request using OpenAI client with timeout
        response = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[
                {"role": "user", "content": request.prompt}
            ],
            timeout=15.0  # 15 second timeout
        )
        
        ai_response = response.choices[0].message.content
        return {"response": ai_response}
        
    except Exception as e:
        print(f"Error calling OpenAI API: {e}")
        return {"error": f"Error processing request: {str(e)}"}

""" endpoint to generate recipes from keywords
    expects a json request with a "keywords" field (list of strings)
    and returns a structured recipe as json
 """
@router.post("/get-recepies")
async def get_recipes(request: KeywordRequest):
    """
    recipe generation endpoint: generate structured recipes from keywords
    """
    if not request.keywords or len(request.keywords) == 0:
        return {"error": "No keywords provided"}
    
    try:
        # Create a structured prompt for recipe generation
        keywords_str = ", ".join(request.keywords)
        prompt = f"""
Generate a detailed recipe using these ingredients: {keywords_str}

Please respond with a valid JSON object with the following structure:
{{
    "title": "Recipe Name",
    "ingredients": ["ingredient 1", "ingredient 2", "..."],
    "instructions": ["step 1", "step 2", "..."],
    "cookingTime": "30 minutes",
    "servings": "4 people",
    "servingSuggestion": "Serve with..."
}}

Make sure the response is only valid JSON, no additional text or formatting.
Create a practical, delicious recipe that makes good use of the provided ingredients.
"""
        
        # Make the request using OpenAI client with timeout
        response = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[
                {"role": "user", "content": prompt}
            ],
            timeout=15.0  # 15 second timeout
        )
        
        ai_response = response.choices[0].message.content
        
        # Try to parse the response as JSON to validate it
        try:
            recipe_json = json.loads(ai_response)
            return {"recipe": recipe_json}
        except json.JSONDecodeError:
            # If JSON parsing fails, return the raw response
            print(f"Warning: AI response is not valid JSON, returning as string")
            return {"recipe": ai_response}
        
    except Exception as e:
        print(f"Error calling OpenAI API for recipe generation: {e}")
        return {"error": f"Error generating recipe: {str(e)}"}