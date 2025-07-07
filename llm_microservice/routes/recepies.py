from fastapi import APIRouter
from models.keyword_request import KeywordRequest, ChatRequest
from services.api_service import find_recipes_by_keywords, communicateWithModel

router = APIRouter()


""" endpoint to get recipes based on keywords
    erwartet ein json request mit einem "keywords" array feld
    und gibt die gefundenen rezepte als json zurück
 """
@router.post("/get-recepies")
async def get_recepies(request: KeywordRequest):
    recipe = await find_recipes_by_keywords(request.keywords)
    return {"recipe": recipe}


""" endpoint to communicate with the llm api
    erwartet ein json request mit einem "promt" feld
    und gibt die antwort des llm als json zurück
 """
@router.post("/talk-to-chat")
async def talk_to_chat(request: ChatRequest):
    """
    chat endpoint: einfach an service weiter geben 
    """
    print("Received request in router:", request)
    response = await communicateWithModel(request.prompt)
    return {"response": response}  