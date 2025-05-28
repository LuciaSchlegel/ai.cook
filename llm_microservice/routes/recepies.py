from fastapi import APIRouter
from models.keyword_request import KeywordRequest
from services.api_service import find_recipes_by_keywords, communicateWithModel

router = APIRouter()

@router.post("/get-recepies")
async def get_recepies(request: KeywordRequest):
    recipe = await find_recipes_by_keywords(request.keywords)
    return {"recipe": recipe}

@router.post("/talk-to-chat")
async def talk_to_chat(request: str):
    """
    chat endpoint: einfach an service weiter geben 
    """
    print("Received request in router:", request)
    response = await communicateWithModel(request)
    return {"response": response}  