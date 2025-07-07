from fastapi import FastAPI
from routes.recepies import router as api_router
from dotenv import load_dotenv
import os


app = FastAPI()

# .env-Datei laden
load_dotenv()
# key leaden 
api_key = os.getenv("OPENROUTER_API_KEY")
print(api_key)

#cors für frontend calls 

# Alle API-Endpunkte unter /api
app.include_router(api_router, prefix="/api")
