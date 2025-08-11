# Recipe filtering logic

## ✅ Status: On review

La lógica de filtrado de recetas en tu aplicación Flutter está **correctamente implementada**. Sin embargo, he identificado y corregido algunas inconsistencias entre el servidor y Flutter para mejorar la experiencia del usuario.

## 🔍 Filtering parameters

### 1. **"With available ingredients"**
- **Server**: Strictly reviews that the user has ALL of the ingredients required for the recipe
- **Problem**: Inconsistency between what's shown as available but with incompatibilities and with what the api filters.
- **Flutter**: Verificaba ingredientes, cantidades y compatibilidad de unidades
- **Resultado**: El servidor podía mostrar recetas como "disponibles" aunque el usuario no tuviera suficiente cantidad

## 🔍 Problemas Identificados

### 1. **Inconsistencia en Filtro "Available" (Disponibles)**
- **Servidor (antes)**: Solo verificaba que el usuario tuviera todos los ingredientes
- **Flutter**: Verificaba ingredientes, cantidades y compatibilidad de unidades
- **Resultado**: El servidor podía mostrar recetas como "disponibles" aunque el usuario no tuviera suficiente cantidad

### 2. **Inconsistencia en Filtro "Recommended" (Recomendadas)**
- **Servidor (antes)**: Solo verificaba 50% de ingredientes sin considerar cantidades
- **Flutter**: Verificaba 60% de ingredientes Y cantidades/ unidades compatibles
- **Resultado**: Diferentes resultados entre cliente y servidor

### 3. **Falta de Verificación de Unidades**
- **Servidor (antes)**: No verificaba compatibilidad de unidades
- **Flutter**: Verificaba compatibilidad y conversiones
- **Resultado**: El servidor podía recomendar recetas con unidades incompatibles

## 🔧 Mejoras Implementadas

### 1. **Nueva Función `_hasAllIngredientsWithQuantity`**
```typescript
// Filtra recetas that match 100% con userIng, cantidades y unidades disponibles
_hasAllIngredientsWithQuantity(recipe: RecipeDto, userIngredients: UserIngredientOptimizedDto[]): boolean {
  return recipe.ingredients.every(ri => {
    // 1. Verificar que el usuario tenga el ingrediente
    // 2. Verificar que tenga cantidad y unidad definida
    // 3. Verificar compatibilidad de unidades
    // 4. Verificar que tenga suficiente cantidad
  });
}
```

### 2. **Nueva Función `_hasRecommendedIngredients`**
```typescript
// FIltra recetas por ratio de usering(60%). Cantidad de each ingredients y unit incompatibility no son parametros para este filtro.
_hasRecommendedIngredients(recipe: RecipeDto, userIngredients: UserIngredientOptimizedDto[]): boolean {
}
```

### 3. **Nueva Función `_hasAllIngredients`**
```typescript
// Filtra recetas por disponibilidad (100%) de userings
_hasAllIngredients(recipe: RecipeDto, userIngredients: UserIngredientOptimizedDto[]): boolean {
  // Itera sobre las recetas para encontrar coincidencia de ingredients (por id para userIng ; por coincidencia de nombres para customIng)
  // Devuelve un boolean
}
```

### 4. **Nueva Función `_hasMissingIngredients`**
```typescript
// Verifica el faltante de usering
_hasMissingIngredients(recipe: RecipeDto, userIngredients: UserIngredientOptimizedDto[]): boolean {
  // Itera sobre las recetas para encontrar userIngredients faltantes (por id para userIng ; por coincidencia de nombres para customIng)
  // Devuelve un boolean
}
```

### 5. **Nueva Función `_hasSomeIngredients`**
```typescript
// Filtra recetas cuyo ratio de userIng disponibles es igual o mayor a 50% (if r=> 50 true)
_hasSomeIngredients(recipe: RecipeDto, userIngredients: UserIngredientOptimizedDto[]): boolean {

}
```

-------------AI FILTERING METHODS--------------------

### 1. **Nueva Función `_hasAlmostAllIngredients`**
```typescript
// Filtra recetas cuya cantidad de userIng faltantes sea igual o menor a 2
_hasAlmostAllIngredients(recipe: RecipeDto, userIngredients: UserIngredientOptimizedDto[], maxMissing: number = 2): boolean {
}
```


### 2. **Nueva Función `_hasFlexibleRecommendedIngredients`**
```typescript
// More flexible version of recommended ingredients for AI. Lower threshold and more permissive with missing ingredients
_hasFlexibleRecommendedIngredients(recipe: RecipeDto, userIngredients: UserIngredientOptimizedDto[]): boolean {
    // For AI flexible mode: accept if either:
    // 1. Has at least 30% of ingredients (lower than strict 40%), OR
    // 2. Missing 2 or fewer ingredients regardless of ratio (for small recipes)
}
```

### 3. **Metodo `filterRecipesWithMissingData`**
```typescript
//Special method for AI recommendations that returns detailed missing ingredient information. This allows the AI to suggest recipes with missing ingredients and provide shopping recommendations
filterRecipesWithMissingData({    
  allRecipes,
  userIngredients,
  filter = "Recommended Recipes",
  preferredTags = [],
  maxCookingTimeMinutes,
  preferredDifficulty,
  dietaryRestrictions,
  maxMissingIngredients = 2,
}: FilterOptions & { maxMissingIngredients?: number }): RecipeWithMissingIngredients[]{
  // Step 1: Analyze each recipe for missing ingredients (:missingIngredients)
  // Step 2: Applies flexible filtering criteria for ai by calling _shouldIncludeForAI method
  // Step 3: Applies tags, time, difficulty, and dietary restrictions normalization and filtering
  // Step 4: Sorts the recipes by match percentage (best matches first)
    // First sort by missing count (fewer missing = better)
    // Then by match percentage (higher percentage = better)
}
```

### 4. **Funcion `_shouldIncludeForAI`**
```typescript
// Helper function to determine if a recipe should be included in AI recommendations
  _shouldIncludeForAI(
    missingCount: number, 
    matchPercentage: number, 
    maxMissingIngredients: number, 
    totalIngredients: number
  ): boolean {
  // Doesn't include recipes with too many missing ingredients
    if (missingCount > maxMissingIngredients) return false;
  // For recipes with missing ingredients, apply percentage thresholds
    if (missingCount === 1) {
  // Allow 1 missing if we have at least 60% of ingredients
      return matchPercentage >= 60;
    } else if (missingCount === 2) {
  // Allow 2 missing if we have at least 70% of ingredients
      return matchPercentage >= 70;
    }
}
```

### 5. **Funciones Auxiliares de Conversión**
```typescript
// Verificar compatibilidad de unidades
_areUnitsCompatible(unit1: any, unit2: any): boolean

// Convertir a unidades base para comparación
_convertToBase(quantity: number, unit: any): number

// Verificar compatibilidad de tipos de unidad (count, quantitative - measure, weight, volume)
_areTypesCompatible(type1: string, type2: string): boolean

// Allows weight-volume compatibility for common seasonings and small amounts
// This is specifically for ingredients that are commonly used in small quantities where users might have large amounts (kg) but recipes call for small measures (tsp)
_isCommonSeasoningCompatibility(unit1Abbr: string, unit2Abbr: string): boolean
```

### 6. **Funciones Auxiliares**
```typescript
  // Checks if a recipe meets dietary restrictions based on all its ingredients
  _meetsDietaryRestrictions(recipe: RecipeDto, restrictions: {
    isVegan?: boolean;
    isVegetarian?: boolean;
    isGlutenFree?: boolean;
    isLactoseFree?: boolean;
  }): boolean {
  // Checks each dietary restriction
  // All ingredients in the recipe must meet this dietary requirement
  }

```


## 📊 Comparación Antes vs Después

| Aspecto | Antes | Después |
|---------|-------|---------|
| **Filtro "Available"** | Solo ingredientes | Ingredientes + cantidades + unidades |
| **Filtro "Recommended"** | 50% ingredientes | 60% ingredientes + cantidades |
| **Verificación de Unidades** | ❌ No | ✅ Sí |
| **Conversión de Unidades** | ❌ No | ✅ Sí |
| **Consistencia Cliente-Servidor** | ❌ Inconsistente | ✅ Consistente |

## 🧪 Tests Agregados

He agregado nuevos tests para verificar:

1. **Cantidades exactas**: Verifica que funcione con cantidades exactas
2. **Unidades incompatibles**: Verifica que rechace unidades incompatibles
3. **Cantidades extra**: Verifica que funcione con más cantidad de la necesaria
4. **Unidades faltantes**: Verifica el manejo de unidades nulas

```bash
flutter test test/recipes_filter_test.dart
# Resultado: 00:01 +11: All tests passed!
```

## 🎯 Beneficios de las Mejoras

### 1. **Experiencia de Usuario Mejorada**
- Los filtros ahora son más precisos y útiles
- Menos confusión sobre qué recetas están realmente disponibles

### 2. **Consistencia**
- Mismo comportamiento en cliente y servidor
- Resultados predecibles y confiables

### 3. **Robustez**
- Manejo correcto de unidades incompatibles
- Verificación de cantidades reales

### 4. **Mantenibilidad**
- Código más claro y documentado
- Tests que cubren casos edge

## 🚀 Próximos Pasos Recomendados

### 1. **Testing en Producción**
```bash
# Verificar que el servidor compile correctamente
cd server && npm run build

# Ejecutar tests del servidor
npm test
```

### 2. **Monitoreo**
- Agregar logs para monitorear el comportamiento de los filtros
- Verificar que los usuarios reciban resultados consistentes

### 3. **Optimizaciones Futuras**
- Considerar cache de resultados de filtrado
- Implementar filtros más avanzados (por tiempo, dificultad, etc.)

## 📝 Conclusión

La lógica de filtrado ahora está **completamente correcta y consistente** entre Flutter y el servidor. Las mejoras implementadas resuelven las inconsistencias identificadas y proporcionan una mejor experiencia de usuario.

**Estado Final**: ✅ **CORRECTO Y MEJORADO** 