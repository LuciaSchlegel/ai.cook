from dotenv import load_dotenv
import os
from openai import OpenAI

# Cargar variables de .env
load_dotenv()

# Leer la API Key y quitar espacios o saltos de línea
apikey = os.getenv("OPENAI_API_KEY", "").strip()

# Verificar que realmente la clave se haya leído
print(f"API Key: {apikey[:10]}...")  # Solo imprime los primeros caracteres para seguridad

# Instanciar el cliente
client = OpenAI(api_key=apikey)

# Hacer la request
response = client.chat.completions.create(
    model="gpt-4o-mini",
    messages=[
        {"role": "user", "content": "Write a one-sentence bedtime story about a unicorn."}
    ]
)

# Imprimir la respuesta
print(response.choices[0].message.content)