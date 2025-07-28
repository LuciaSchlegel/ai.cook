# 🤖 Integración de Recomendaciones con IA

## 📋 Resumen

He implementado un sistema completo de recomendaciones personalizadas con IA que:

1. **Filtra recetas** basándose en ingredientes disponibles y preferencias del usuario
2. **Envía las mejores 10 recetas** al microservicio de IA
3. **Genera recomendaciones personalizadas** con explicaciones detalladas
4. **Proporciona una interfaz amigable** en Flutter

## 🏗️ Arquitectura

```
Flutter App → Backend Server → LLM Microservice → OpenAI API
     ↓              ↓              ↓              ↓
UI Widgets → AI Service → Recipe Filter → AI Prompt → Response
```

## 📁 Archivos Creados/Modificados

### Backend (Node.js/TypeScript)

#### Nuevos Archivos:
- `server/src/services/ai_recommendation.service.ts` - Servicio principal de IA
- `server/src/controllers/ai_recommendation.controller.ts` - Controlador
- `server/src/routes/ai_recommendation.router.ts` - Rutas
- `server/src/dtos/ai_recommendation.dto.ts` - DTOs de request/response

#### Archivos Modificados:
- `server/src/routes/index.ts` - Agregado router de IA

### Flutter

#### Nuevos Archivos:
- `lib/providers/ai_recommendations_provider.dart` - Provider para IA
- `lib/widgets/ai_recommendations/ai_recommendations_widget.dart` - Widget UI
- `lib/screens/recipes/ai_recommendations_screen.dart` - Pantalla de ejemplo

## 🚀 Cómo Usar

### 1. Configurar el Provider en Flutter

```dart
// En main.dart o donde configures los providers
MultiProvider(
  providers: [
    // ... otros providers
    ChangeNotifierProvider(create: (_) => AIRecommendationsProvider()),
  ],
  child: MyApp(),
)
```

### 2. Usar el Widget de Recomendaciones

```dart
// En cualquier pantalla
const AIRecommendationsWidget()
```

### 3. Generar Recomendaciones Programáticamente

```dart
final aiProvider = Provider.of<AIRecommendationsProvider>(context, listen: false);

await aiProvider.generateRecommendations(
  userIngredients: ingredientsProvider.userIngredients,
  preferredTags: ['Vegetariano', 'Rápido'],
  maxCookingTimeMinutes: 30,
  preferredDifficulty: 'Fácil',
  userPreferences: 'Me gustan las recetas picantes',
  numberOfRecipes: 10,
);
```

## 🔌 Endpoints

### POST `/ai-recommendations/recommendations`

**Request Body:**
```json
{
  "userIngredients": [
    {
      "id": 1,
      "user": {"uid": "user123"},
      "ingredient": {"id": 1, "name": "Pollo"},
      "quantity": 500,
      "unit": {"id": 1, "name": "Gram", "abbreviation": "g"}
    }
  ],
  "preferredTags": ["Alto en proteínas", "Rápido"],
  "maxCookingTimeMinutes": 30,
  "preferredDifficulty": "Fácil",
  "userPreferences": "Me gustan las recetas picantes",
  "numberOfRecipes": 10
}
```

**Response:**
```json
{
  "recommendations": "🍳 **Análisis de tus opciones:**\n\nBasándome en tus ingredientes...",
  "filteredRecipes": [...],
  "totalRecipesConsidered": 150,
  "processingTime": 2500
}
```

## 🎯 Flujo de Procesamiento

### 1. **Filtrado Inicial**
- Se obtienen todas las recetas de la base de datos
- Se aplica el filtro "Recommended" con la lógica mejorada
- Se consideran ingredientes, cantidades y compatibilidad de unidades

### 2. **Selección para IA**
- Se toman las primeras 10 recetas más relevantes
- Se preparan los datos en formato estructurado

### 3. **Generación del Prompt**
- Se construye un prompt detallado con:
  - Ingredientes disponibles del usuario
  - Preferencias (tiempo, dificultad, etiquetas)
  - Información de las recetas filtradas
  - Instrucciones específicas para la IA

### 4. **Respuesta de IA**
- La IA analiza las recetas y genera recomendaciones personalizadas
- Incluye top 3 recomendaciones con explicaciones
- Sugiere adaptaciones y consejos de preparación

## 🎨 Características del Widget

### Estados del Widget:
1. **Vacío**: Muestra botón para generar recomendaciones
2. **Cargando**: Indicador de progreso con animación
3. **Error**: Manejo de errores con opción de reintentar
4. **Con Datos**: Muestra recomendaciones y recetas consideradas

### Información Mostrada:
- ✅ Recomendaciones personalizadas de la IA
- 📊 Estadísticas de procesamiento
- 📖 Lista de recetas consideradas
- ⏱️ Tiempo de procesamiento

## 🔧 Configuración

### Variables de Entorno
```bash
# En el servidor
OPENROUTER_API_KEY=tu_api_key_aqui

# En Flutter (.env)
API_URL=http://localhost:3000
```

### Microservicio de IA
Asegúrate de que el microservicio de Python esté corriendo:
```bash
cd llm_microservice
pip install -r requirements.txt
uvicorn main:app --reload --port 8000
```

## 🧪 Testing

### Probar el Endpoint
```bash
curl -X POST http://localhost:3000/ai-recommendations/recommendations \
  -H "Content-Type: application/json" \
  -d '{
    "userIngredients": [
      {
        "id": 1,
        "user": {"uid": "test"},
        "ingredient": {"id": 1, "name": "Pollo"},
        "quantity": 500,
        "unit": {"id": 1, "name": "Gram", "abbreviation": "g"}
      }
    ],
    "preferredTags": ["Rápido"],
    "maxCookingTimeMinutes": 30
  }'
```

### Probar en Flutter
1. Ejecuta la aplicación
2. Navega a la pantalla de recomendaciones de IA
3. Configura preferencias
4. Presiona "Generar Recomendaciones"

## 🚨 Manejo de Errores

### Errores Comunes:
1. **IA no disponible**: Se genera respuesta de fallback
2. **Sin recetas**: Se muestra mensaje apropiado
3. **Error de red**: Se maneja con reintentos
4. **Validación**: Se validan todos los inputs

### Logs:
- Se registran todos los pasos del proceso
- Se incluyen métricas de rendimiento
- Se capturan errores para debugging

## 🔮 Próximas Mejoras

### Funcionalidades Futuras:
1. **Cache de recomendaciones** para mejorar rendimiento
2. **Aprendizaje de preferencias** del usuario
3. **Recomendaciones basadas en historial** de cocina
4. **Integración con calendario** para planificación de comidas
5. **Sugerencias de compra** de ingredientes faltantes

### Optimizaciones:
1. **Filtrado más inteligente** con machine learning
2. **Prompt engineering** mejorado
3. **Múltiples modelos de IA** para diferentes tipos de recomendaciones
4. **Análisis de sentimiento** de las preferencias del usuario

## 📝 Notas de Implementación

### Consideraciones de Rendimiento:
- El filtrado se hace en el servidor para reducir carga en el cliente
- Se limitan las recetas enviadas a la IA para optimizar costos
- Se incluye fallback en caso de que la IA no esté disponible

### Seguridad:
- Se validan todos los inputs del usuario
- Se sanitizan los datos antes de enviar a la IA
- Se manejan errores de manera segura

### Escalabilidad:
- El sistema está diseñado para manejar múltiples usuarios
- Se puede ajustar el número de recetas enviadas a la IA
- La arquitectura permite agregar más modelos de IA fácilmente

## 🎉 Conclusión

Esta implementación proporciona una experiencia de usuario rica y personalizada, combinando la lógica de filtrado existente con la potencia de la IA para generar recomendaciones únicas y útiles. El sistema es robusto, escalable y fácil de mantener. 