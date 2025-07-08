import httpx
import os
from dotenv import load_dotenv

load_dotenv()  # .env Datei laden

OPENROUTER_API_KEY = os.getenv("OPENROUTER_API_KEY")
OPENROUTER_URL = "https://openrouter.ai/api/v1/chat/completions"

headers = {
    "Authorization": f"Bearer {OPENROUTER_API_KEY}",
    "Content-Type": "application/json",
    "HTTP-Referer": "http://localhost",  # wichtig für manche Modelle
    "X-Title": "Recipe Generator Dev",   # frei wählbarer Projekttitel
}

async def find_recipes_by_keywords(keywords: list[str]) -> str:
    prompt = (
        "Hey! Gib mir bitte ein detailliertes Rezept als One-Pager auf Deutsch, "
        "das folgende Zutaten verwendet: " + ", ".join(keywords) + ". "
        "Bitte kreativ, aber alltagstauglich, mit Zutatenliste, Zubereitungsschritten und evtl. einem Serviervorschlag."
        " gib bitte als Antwort NUR einen Text in JSON dieser Form zurück:\n" 
        "{\n"
        "  \"title\": \"Rezeptname\",\n"
        "  \"ingredients\": [\n"    
        "    \"Zutat 1\",\n"
        "    \"Zutat 2\",\n"
        "    \"Zutat 3\"\n"
        "  ],\n"
        "  \"instructions\": [\n"
        "     \"Schritt-für-Schritt-Anleitung\",\n"
        "     \"Schritt 2\",\n"
        "     \"Schritt 3\"\n"
        "  ],\n"
        "  \"cookingTime\": \"Zubereitungszeit in Minuten\",\n"
        "  \"servings\": \"Anzahl der Portionen\",\n"
        "  \"servingSuggestion\": \"Serviervorschlag\"\n"
        "}\n"
        "Achte darauf, dass die Antwort im JSON-Format ist und keine zusätzlichen Erklärungen oder Kommentare enthält."

    )
    
    payload = {
        "model": "mistralai/devstral-small:free",  # kostenloses Modell
        "messages": [
            {"role": "user", "content": prompt}
        ]
    }

    async with httpx.AsyncClient(timeout=60.0) as client:
        response = await client.post(OPENROUTER_URL, headers=headers, json=payload)
        response.raise_for_status()

    data = response.json()
    return data["choices"][0]["message"]["content"]

async def communicateWithModel(prompt: str) -> str:
    if not prompt:
        return "kein prompt erhalten"
    
    payload = {
        "model": "mistralai/devstral-small:free",  # kostenloses Modell
        "messages": [
            {"role": "user", "content": prompt}
        ]
    }

    async with httpx.AsyncClient(timeout=60.0) as client:
        response = await client.post(OPENROUTER_URL, headers=headers, json=payload)
        response.raise_for_status()

    data = response.json()
    return data["choices"][0]["message"]["content"]