import { RecipeDto } from "../dtos/recipe.dto";
import { UserIngredientDto } from "../dtos/user_ing.dto";

export type FilterOptions = {
  allRecipes: RecipeDto[];
  userIngredients: UserIngredientDto[];
  filter?: "All Recipes" | "Available" | "Missing Ingredients" | "Recommended";
  preferredTags?: string[];
  maxCookingTimeMinutes?: number;
  preferredDifficulty?: string;
};

export const RecipeFilterService = {
  filterRecipes({
    allRecipes,
    userIngredients,
    filter = "All Recipes",
    preferredTags = [],
    maxCookingTimeMinutes,
    preferredDifficulty,
  }: FilterOptions): RecipeDto[] {
    let filtered = [...allRecipes];
    
    console.log(`🔍 Starting filter: ${filter}`);
    console.log(`📊 Initial recipes: ${filtered.length}`);
    console.log(`🏷️ Preferred tags: ${preferredTags.join(', ')}`);

    if (filter === "Available") {
      filtered = filtered.filter(recipe => this._hasAllIngredientsWithQuantity(recipe, userIngredients));
      console.log(`✅ After Available filter: ${filtered.length} recipes`);
    } else if (filter === "Missing Ingredients") {
      filtered = filtered.filter(recipe => this._hasMissingIngredients(recipe, userIngredients));
      console.log(`✅ After Missing Ingredients filter: ${filtered.length} recipes`);
    } else if (filter === "Recommended") {
      filtered = filtered.filter(recipe => this._hasRecommendedIngredients(recipe, userIngredients));
      console.log(`✅ After Recommended filter: ${filtered.length} recipes`);
    }

    if (preferredTags.length > 0) {
      const beforeTags = filtered.length;
      filtered = filtered.filter(recipe => {
        const recipeTags = recipe.tags?.map(tag => tag.name) || [];
        const hasMatchingTag = recipeTags.some(tag => preferredTags.includes(tag));
        console.log(`🍳 Recipe "${recipe.name}" tags: [${recipeTags.join(', ')}] - Match: ${hasMatchingTag}`);
        return hasMatchingTag;
      });
      console.log(`🏷️ After tags filter: ${beforeTags} -> ${filtered.length} recipes`);
    }

    if (preferredDifficulty) {
      const beforeDifficulty = filtered.length;
      filtered = filtered.filter(recipe =>
        recipe.difficulty?.toLowerCase() === preferredDifficulty.toLowerCase(),
      );
      console.log(`📊 After difficulty filter: ${beforeDifficulty} -> ${filtered.length} recipes`);
    }

    if (maxCookingTimeMinutes !== undefined) {
      const beforeTime = filtered.length;
      filtered = filtered.filter(recipe => {
        if (!recipe.cookingTime) return false;
        const cookingTime = this._extractCookingTime(recipe.cookingTime);
        const matches = cookingTime <= maxCookingTimeMinutes;
        console.log(`⏰ Recipe "${recipe.name}" cooking time: ${recipe.cookingTime} (${cookingTime}min) - Match: ${matches}`);
        return matches;
      });
      console.log(`⏰ After time filter: ${beforeTime} -> ${filtered.length} recipes`);
    }

    console.log(`🎯 Final result: ${filtered.length} recipes`);
    return filtered;
  },

  // Nueva función que verifica ingredientes, cantidades y unidades (como en Flutter)
  _hasAllIngredientsWithQuantity(recipe: RecipeDto, userIngredients: UserIngredientDto[]): boolean {
    return recipe.ingredients.every(ri => {
      // Verificar que el ingrediente de la receta existe
      if (!ri.ingredient) return false;
      
      // Buscar si el usuario tiene este ingrediente
      const userIng = userIngredients.find(ui => {
        // Verificar que el ingrediente del usuario existe
        if (!ui.ingredient) return false;
        return ui.ingredient.id === ri.ingredient.id;
      });

      if (!userIng) return false;

      // Verificar que tenga cantidad y unidad definida
      if (!userIng.unit || !ri.unit) return false;

      // Verificar compatibilidad de unidades
      if (!this._areUnitsCompatible(userIng.unit, ri.unit)) return false;

      // Verificar que tenga suficiente cantidad
      try {
        const userAmountBase = this._convertToBase(userIng.quantity, userIng.unit);
        const recipeAmountBase = this._convertToBase(ri.quantity, ri.unit);
        return userAmountBase >= recipeAmountBase;
      } catch (_) {
        return false; // Si falla la conversión, asumir que no alcanza
      }
    });
  },

  // Función para "Recommended" que verifica ratio y cantidades (como en Flutter)
  _hasRecommendedIngredients(recipe: RecipeDto, userIngredients: UserIngredientDto[]): boolean {
    // Paso 1: Verificar ratio de ingredientes (mínimo 60% como en Flutter)
    const matchedCount = recipe.ingredients.filter(ri => {
      if (!ri.ingredient) return false;
      return userIngredients.some(ui => ui.ingredient?.id === ri.ingredient.id);
    }).length;

    const validIngredients = recipe.ingredients.filter(ri => ri.ingredient !== null);
    const ratio = matchedCount / validIngredients.length;
    
    if (ratio < 0.6) return false; // 60% como en Flutter

    // Paso 2: Verificar que tenga suficiente cantidad para todos los ingredientes que tiene
    const hasEnoughAll = recipe.ingredients.every(ri => {
      if (!ri.ingredient) return true; // Ignorar ingredientes inválidos
      
      const userIng = userIngredients.find(ui => ui.ingredient?.id === ri.ingredient.id);
      if (!userIng) return true; // Si no lo tiene, no es problema para "Recommended"

      // Si no tiene cantidad o unit definida, rechazar
      if (!userIng.unit || !ri.unit) return false;

      // Verificar compatibilidad de unidades
      if (!this._areUnitsCompatible(userIng.unit, ri.unit)) return false;

      try {
        const userAmountBase = this._convertToBase(userIng.quantity, userIng.unit);
        const recipeAmountBase = this._convertToBase(ri.quantity, ri.unit);
        return userAmountBase >= recipeAmountBase;
      } catch (_) {
        return false;
      }
    });

    return hasEnoughAll;
  },

  _hasAllIngredients(recipe: RecipeDto, userIngredients: UserIngredientDto[]): boolean {
    return recipe.ingredients.every(ri => {
      // Verificar que el ingrediente de la receta existe
      if (!ri.ingredient) return false;
      
      // Buscar si el usuario tiene este ingrediente
      return userIngredients.some(ui => {
        // Verificar que el ingrediente del usuario existe
        if (!ui.ingredient) return false;
        return ui.ingredient.id === ri.ingredient.id;
      });
    });
  },

  _hasMissingIngredients(recipe: RecipeDto, userIngredients: UserIngredientDto[]): boolean {
    return recipe.ingredients.some(ri => {
      // Verificar que el ingrediente de la receta existe
      if (!ri.ingredient) return false;
      
      // Verificar si el usuario NO tiene este ingrediente
      return !userIngredients.some(ui => {
        // Verificar que el ingrediente del usuario existe
        if (!ui.ingredient) return false;
        return ui.ingredient.id === ri.ingredient.id;
      });
    });
  },

  _hasSomeIngredients(recipe: RecipeDto, userIngredients: UserIngredientDto[]): boolean {
    // Para RECOMMENDED, mostramos recetas que tienen al menos 50% de los ingredientes
    const availableIngredients = recipe.ingredients.filter(ri => {
      // Verificar que el ingrediente de la receta existe
      if (!ri.ingredient) return false;
      
      // Verificar si el usuario tiene este ingrediente
      return userIngredients.some(ui => {
        // Verificar que el ingrediente del usuario existe
        if (!ui.ingredient) return false;
        return ui.ingredient.id === ri.ingredient.id;
      });
    });
    
    // Solo contar ingredientes válidos
    const validIngredients = recipe.ingredients.filter(ri => ri.ingredient !== null);
    return availableIngredients.length >= validIngredients.length * 0.5;
  },

  // Funciones auxiliares para conversión de unidades
  _areUnitsCompatible(unit1: any, unit2: any): boolean {
    const weightUnits = ['gr', 'g', 'kg'];
    const volumeUnits = ['ml', 'l', 'tsp', 'tbsp', 'cup'];
    const unitUnits = ['u', 'unit', 'pcs'];

    const unit1Abbr = unit1.abbreviation?.toLowerCase();
    const unit2Abbr = unit2.abbreviation?.toLowerCase();

    if (weightUnits.includes(unit1Abbr) && weightUnits.includes(unit2Abbr)) {
      return true;
    }
    if (volumeUnits.includes(unit1Abbr) && volumeUnits.includes(unit2Abbr)) {
      return true;
    }
    if (unitUnits.includes(unit1Abbr) && unitUnits.includes(unit2Abbr)) {
      return true;
    }
    return false;
  },

  _convertToBase(quantity: number, unit: any): number {
    const conversionFactors: { [key: string]: number } = {
      'gr': 1,
      'g': 1,
      'kg': 1000,
      'ml': 1,
      'l': 1000,
      'tsp': 5,
      'tbsp': 15,
      'cup': 240,
      'unit': 1,
      'u': 1,
      'pcs': 1,
    };

    const factor = conversionFactors[unit.abbreviation?.toLowerCase()];
    if (factor !== undefined) {
      return quantity * factor;
    }
    throw new Error(`No conversion factor found for ${unit.abbreviation}`);
  },

  _extractCookingTime(cookingTime: string): number {
    const regex = /(\d+)\s*(h|hour|hours|m|min|minutes)?/gi;
    let totalMinutes = 0;
    let match;

    while ((match = regex.exec(cookingTime)) !== null) {
      const value = parseInt(match[1]);
      const unit = match[2]?.toLowerCase() ?? "";

      if (unit.includes("h")) {
        totalMinutes += value * 60;
      } else {
        totalMinutes += value;
      }
    }
    return totalMinutes;
  },
};