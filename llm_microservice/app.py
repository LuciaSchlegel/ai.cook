from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routes.recepies import router as recipes_router
import uvicorn
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Create FastAPI app
app = FastAPI(
    title="AI Cook LLM Microservice",
    description="Microservice for AI-powered recipe generation and chat functionality",
    version="1.0.0"
)

# CORS middleware configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify exact origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Health check endpoint
@app.get("/health")
async def health_check():
    return {"status": "healthy", "service": "llm-microservice"}

# Health check endpoint (alternative path for compatibility)
@app.get("/api/health")
async def api_health_check():
    return {"status": "healthy", "service": "llm-microservice"}

# Include routers
app.include_router(recipes_router, prefix="/api", tags=["recipes"])

if __name__ == "__main__":
    port = int(os.getenv("PORT", 8000))
    host = os.getenv("HOST", "0.0.0.0")
    
    print(f"🚀 Starting LLM Microservice on {host}:{port}")
    uvicorn.run("app:app", host=host, port=port, reload=True) 