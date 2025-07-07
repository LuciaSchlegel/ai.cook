import httpx

response = httpx.post(
    "http://localhost:8000/api/get-recepies",
    json={"keywords": ["chicken", "lemon", "garlic"]}
)

print("Status:", response.status_code)
print("Text:", response.text)

"""

curl -X POST https://openrouter.ai/api/v1/chat/completions \
  -H "Authorization: Bearer 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" \
  -H "Content-Type: application/json" \
  -H "HTTP-Referer: http://localhost" \
  -H "X-Title: RecipeGen" \
  -d '{
    "model": "deepseek/deepseek-chat-v3-0324:free",
    "messages": [
      {
        "role": "user",
        "content": "Gib mir ein deutsches Rezept als One-Pager mit Huhn, Knoblauch und Reis"
      }
    ]
  }'


curl -X POST https://openrouter.ai/api/v1/chat/completions \
  -H "Authorization: Bearersk-or-v1- \
  -H "Content-Type: application/json" \
  -H "HTTP-Referer: http://localhost" \
  -H "X-Title: RecipeGen" \
  -d '{
    "model": "mistralai/mistral-7b-instruct",
    "messages": [
      {
        "role": "user",
        "content": "Gib mir ein deutsches Rezept als One-Pager mit Huhn, Knoblauch und Reis"
      }
    ]
  }'

"""
  