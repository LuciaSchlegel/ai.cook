Got you bro 💥 Straight to the point. Here’s your ultra-clean doc:

⸻
INGREDIENTS 
	- GET "ingredients/initialize"
		initializes basic ingredients from themealdb.com
		HAS TO BE CALLED ONE AT APP STARTUP IF DB IS STILL IN SYNCHRONE MODE
	- GET "ingredients/global"
		returns a JSON of all ingredients


# 🧠 LLM API
## POST /llm/talk
- **Payload:**
```json
{ "prompt": "Was ist ein gutes veganes Rezept?" }

	•	Response:

{ "response": "Ein gutes veganes Rezept ist..." }
⸻

## POST /llm/generate
	•	Payload:

{ "keywords": ["vegan", "einfach"] }

	•	Response:

{ "recipes": ["Vegane Suppe", "Tofu-Pfanne", "Kichererbsen-Salat"] }
