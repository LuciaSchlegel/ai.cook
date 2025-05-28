from pydantic import BaseModel
from typing import List

class KeywordRequest(BaseModel):
    keywords: List[str]
