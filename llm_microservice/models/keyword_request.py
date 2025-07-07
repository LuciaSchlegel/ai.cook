from pydantic import BaseModel
from typing import List

class KeywordRequest(BaseModel):
    keywords: List[str]

class ChatRequest(BaseModel):
    prompt: str