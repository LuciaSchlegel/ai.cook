# AI LLM Integration Setup

This document explains how to set up and use the AI LLM integration between the Node.js server and Python microservice.

## Architecture

```
Flutter App → Node.js Server → Python LLM Microservice → OpenAI API
```

## Environment Variables

### Server (Node.js) - `.env`
```env
# LLM Microservice Configuration
LLM_SERVICE_URL=http://localhost:8000

# Other existing variables...
DATABASE_HOST=localhost
DATABASE_PORT=5432
# ... etc
```

### Python Microservice - `llm_microservice/.env`
```env
# OpenAI Configuration
OPENAI_API_KEY=your_openai_api_key_here

# OR OpenRouter Configuration (alternative)
OPENROUTER_API_KEY=your_openrouter_api_key_here

# Service Configuration
PORT=8000
HOST=0.0.0.0
```

## Setup Instructions

### 1. Python Microservice Setup

```bash
cd llm_microservice

# Install dependencies
pip install -r requirements.txt

# Create .env file with your API keys
cp .env.example .env
# Edit .env with your actual API keys

# Run the service
python app.py
```

The service will be available at `http://localhost:8000`

### 2. Node.js Server Setup

The server will automatically connect to the Python microservice using the `LLM_SERVICE_URL` environment variable.

## API Endpoints

### Python Microservice

- `GET /health` - Health check
- `POST /api/get-recepies` - Generate recipe from keywords
- `POST /api/talk-to-chat` - General chat with LLM

### Node.js Server

- `GET /llm/health` - Health check for LLM service
- `POST /llm/generate` - Generate recipe from keywords
- `POST /llm/talk` - General chat with LLM
- `POST /ai-recommendations/recommendations` - AI-powered recipe recommendations

## Usage Examples

### Generate Recipe
```bash
curl -X POST http://localhost:3000/llm/generate \
  -H "Content-Type: application/json" \
  -d '{"keywords": ["chicken", "garlic", "lemon"]}'
```

### Chat with LLM
```bash
curl -X POST http://localhost:3000/llm/talk \
  -H "Content-Type: application/json" \
  -d '{"prompt": "Give me cooking tips for beginners"}'
```

### AI Recommendations
```bash
curl -X POST http://localhost:3000/ai-recommendations/recommendations \
  -H "Content-Type: application/json" \
  -d '{
    "userIngredients": [
      {
        "ingredient": {"name": "chicken"},
        "quantity": 1,
        "unit": {"abbreviation": "kg"}
      }
    ],
    "preferredTags": [{"name": "quick"}],
    "maxCookingTimeMinutes": 30,
    "numberOfRecipes": 5
  }'
```

## Integration with AI Recommendation Service

The `AIRecommendationService` in `server/src/services/ai_recommendation.service.ts` automatically uses the LLM service for generating personalized recommendations. It:

1. Filters recipes based on user ingredients and preferences
2. Sends the filtered recipes to the LLM service
3. Receives personalized recommendations
4. Returns structured response to the frontend

## Testing

### Run Integration Tests

```bash
cd server

# Run all tests
npm test

# Run specific AI integration tests
npm test -- --testNamePattern="AI Recommendation Service Integration Test"

# Run with verbose output
npm test -- --verbose
```

### Test Coverage

The integration tests cover:

1. **Recipe Filtering Logic**
   - User ingredients matching
   - Cooking time limits
   - Difficulty preferences
   - Tag filtering

2. **Prompt Generation**
   - User data inclusion
   - Recipe information formatting
   - Preference handling
   - Minimal input scenarios

3. **Python Microservice Connection**
   - HTTP communication
   - Error handling
   - Timeout management
   - Health checks

4. **End-to-End AI Recommendations**
   - Complete flow testing
   - Response validation
   - Performance testing

### Manual Testing

Start both services and test endpoints manually:

```bash
# Terminal 1: Start Python LLM service
cd llm_microservice
python app.py

# Terminal 2: Start Node.js server
cd server
npm run dev

# Terminal 3: Run tests
cd server
npm test
```

## Troubleshooting

### Common Issues

1. **Connection Refused**: Make sure the Python microservice is running on port 8000
2. **Invalid API Key**: Check your OpenAI or OpenRouter API key in the Python microservice `.env`
3. **CORS Issues**: The Python service includes CORS middleware for cross-origin requests
4. **Test Failures**: Ensure both services are running before executing integration tests

### Health Checks

- Python service: `curl http://localhost:8000/health`
- Node.js LLM proxy: `curl http://localhost:3000/llm/health`

### Debug Mode

Enable debug logging by setting:
```env
NODE_ENV=development
DEBUG=ai-recommendations
```

## Security Notes

- Never commit `.env` files with real API keys
- In production, configure CORS properly with specific origins
- Use environment variables for all sensitive configuration
- Implement rate limiting for AI endpoints
- Monitor API usage and costs 