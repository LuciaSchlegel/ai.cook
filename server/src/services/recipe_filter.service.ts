import { RecipeDto } from "../dtos/recipe.dto";
import { UserIngredientDto } from "../dtos/user_ing.dto";

export type FilterOptions = {
  allRecipes: RecipeDto[];
  userIngredients: UserIngredientDto[];
  filter?: "All Recipes" | "With Available Ingredients" | "Recommended Recipes";
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
    
    // Si el filtro es "All Recipes", retornar todas las recetas sin aplicar ningún filtro
    if (filter === "All Recipes") {
      console.log(`🎯 Filter is "All Recipes" - returning all recipes without any filtering`);
      return filtered;
    }
    
    console.log(`🏷️ Preferred tags: ${preferredTags.join(', ')}`);

    if (filter === "With Available Ingredients") {
      filtered = filtered.filter(recipe => this._hasAllIngredientsWithQuantity(recipe, userIngredients));
      console.log(`✅ After Available filter: ${filtered.length} recipes`);
    } else if (filter === "Recommended Recipes") {
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

    // Apply personal preference filters ONLY for filters other than "With Available Ingredients"
    if (filter !== "With Available Ingredients") {
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
    } else {
      console.log(`🚫 Skipping personal preference filters for "With Available Ingredients" filter`);
    }

    console.log(`🎯 Final result: ${filtered.length} recipes`);
    return filtered;
  },

  // Nueva función que verifica ingredientes, cantidades y unidades (como en Flutter)
  _hasAllIngredientsWithQuantity(recipe: RecipeDto, userIngredients: UserIngredientDto[]): boolean {
    console.log(`🧪 Checking recipe "${recipe.name}" with ${recipe.ingredients.length} ingredients`);
    console.log(`👤 User has ${userIngredients.length} ingredients available`);
    
    const result = recipe.ingredients.every((ri, index) => {
      console.log(`\n  📋 Checking recipe ingredient ${index + 1}/${recipe.ingredients.length}:`);
      
      // Verificar que el ingrediente de la receta existe
      if (!ri.ingredient) {
        console.log(`    ❌ Recipe ingredient has no ingredient object`);
        return false;
      }
      
      console.log(`    🥬 Recipe needs: "${ri.ingredient.name}" (ID: ${ri.ingredient.id})`);
      console.log(`    📊 Recipe quantity: ${ri.quantity}`);
      console.log(`    🏷️ Recipe unit:`, ri.unit);
      
      // Buscar si el usuario tiene este ingrediente
      const userIng = userIngredients.find(ui => {
        // Verificar que el ingrediente del usuario existe (regular o custom)
        if (!ui.ingredient && !ui.customIngredient) {
          console.log(`    ⚠️ User ingredient has no ingredient or custom ingredient object`);
          return false;
        }
        
        // Si el usuario tiene un ingrediente regular, comparar con el ingrediente de la receta
        if (ui.ingredient) {
          return ui.ingredient.id === ri.ingredient.id;
        }
        
        // Si el usuario tiene un ingrediente custom, comparar por nombre (case insensitive)
        // ya que los custom ingredients no tienen el mismo ID que los ingredientes regulares
        if (ui.customIngredient) {
          const recipeName = ri.ingredient.name.toLowerCase().trim();
          const customName = ui.customIngredient.name.toLowerCase().trim();
          const matches = recipeName === customName;
          console.log(`    🔍 Custom ingredient match: "${customName}" vs "${recipeName}" = ${matches}`);
          return matches;
        }
        
        return false;
      });

      if (!userIng) {
        console.log(`    ❌ User doesn't have this ingredient`);
        return false;
      }
      
      console.log(`    ✅ User has ingredient: "${userIng.ingredient?.name || userIng.customIngredient?.name}"`);
      console.log(`    👤 User quantity: ${userIng.quantity}`);
      console.log(`    🏷️ User unit:`, userIng.unit);

      // Verificar que tenga cantidad y unidad definida
      if (!userIng.unit || !ri.unit) {
        console.log(`    ❌ Missing units - User unit: ${!!userIng.unit}, Recipe unit: ${!!ri.unit}`);
        return false;
      }

      // Verificar compatibilidad de unidades
      const compatible = this._areUnitsCompatible(userIng.unit, ri.unit);
      console.log(`    🔗 Units compatible: ${compatible} (user: "${userIng.unit.abbreviation}" vs recipe: "${ri.unit.abbreviation}")`);
      if (!compatible) {
        return false;
      }

      // Verificar que tenga suficiente cantidad
      try {
        const userAmountBase = this._convertToBase(userIng.quantity, userIng.unit);
        const recipeAmountBase = this._convertToBase(ri.quantity, ri.unit);
        const hasEnough = userAmountBase >= recipeAmountBase;
        
        console.log(`    📐 Conversion - User: ${userIng.quantity} ${userIng.unit.abbreviation} = ${userAmountBase} base units`);
        console.log(`    📐 Conversion - Recipe: ${ri.quantity} ${ri.unit.abbreviation} = ${recipeAmountBase} base units`);
        console.log(`    ✔️ Has enough quantity: ${hasEnough}`);
        
        return hasEnough;
      } catch (error) {
        console.log(`    ❌ Conversion failed:`, error);
        return false; // Si falla la conversión, asumir que no alcanza
      }
    });
    
    console.log(`🎯 Recipe "${recipe.name}" result: ${result ? 'PASSED' : 'FAILED'}\n`);
    return result;
  },

  // Función para "Recommended" que verifica ratio y cantidades (como en Flutter)
  _hasRecommendedIngredients(recipe: RecipeDto, userIngredients: UserIngredientDto[]): boolean {
    // Si no hay ingredientes del usuario, retornar todas las recetas como recomendadas
    if (!userIngredients || userIngredients.length === 0) {
      console.log(`  📝 No user ingredients provided - recommending all recipes`);
      return true;
    }

    // Paso 1: Verificar ratio de ingredientes (mínimo 60% como en Flutter)
    const matchedCount = recipe.ingredients.filter(ri => {
      if (!ri.ingredient) return false;
      return userIngredients.some(ui => {
        // Check regular ingredients
        if (ui.ingredient?.id === ri.ingredient.id) return true;
        
        // Check custom ingredients by name
        if (ui.customIngredient) {
          const recipeName = ri.ingredient.name.toLowerCase().trim();
          const customName = ui.customIngredient.name.toLowerCase().trim();
          return recipeName === customName;
        }
        
        return false;
      });
    }).length;

    const validIngredients = recipe.ingredients.filter(ri => ri.ingredient !== null);
    const ratio = matchedCount / validIngredients.length;
    
    console.log(`  📊 Recipe "${recipe.name}": ${matchedCount}/${validIngredients.length} ingredients matched (${(ratio * 100).toFixed(1)}%)`);
    
    if (ratio < 0.2) return false; // 20% threshold - more flexible for recommendations

    // Paso 2: Para "Recommended", ser más flexible con las cantidades
    // Solo verificar ingredientes que coinciden, pero no rechazar por incompatibilidad de unidades
    const hasEnoughMatched = recipe.ingredients.every(ri => {
      if (!ri.ingredient) return true; // Ignorar ingredientes inválidos
      
      const userIng = userIngredients.find(ui => {
        // Check regular ingredients
        if (ui.ingredient?.id === ri.ingredient.id) return true;
        
        // Check custom ingredients by name
        if (ui.customIngredient) {
          const recipeName = ri.ingredient.name.toLowerCase().trim();
          const customName = ui.customIngredient.name.toLowerCase().trim();
          return recipeName === customName;
        }
        
        return false;
      });
      
      if (!userIng) return true; // Si no lo tiene, no es problema para "Recommended"

      // Si no tiene cantidad o unit definida, asumir que está bien para "Recommended"
      if (!userIng.unit || !ri.unit) return true;

      // Para "Recommended", si las unidades no son compatibles, asumir que está bien
      if (!this._areUnitsCompatible(userIng.unit, ri.unit)) {
        console.log(`    🔄 Units not compatible for "${ri.ingredient.name}" - allowing for Recommended filter`);
        return true;
      }

      try {
        const userAmountBase = this._convertToBase(userIng.quantity, userIng.unit);
        const recipeAmountBase = this._convertToBase(ri.quantity, ri.unit);
        const hasEnough = userAmountBase >= recipeAmountBase;
        console.log(`    ✔️ Quantity check for "${ri.ingredient.name}": ${hasEnough}`);
        return hasEnough;
      } catch (error) {
        console.log(`    🔄 Conversion failed for "${ri.ingredient.name}" - allowing for Recommended filter`);
        return true; // Para "Recommended", ser permisivo con errores de conversión
      }
    });

    console.log(`  🎯 Recipe "${recipe.name}" final result: ${hasEnoughMatched} (ratio: ${(ratio * 100).toFixed(1)}%)`);
    return hasEnoughMatched;
  },

  _hasAllIngredients(recipe: RecipeDto, userIngredients: UserIngredientDto[]): boolean {
    return recipe.ingredients.every(ri => {
      // Verificar que el ingrediente de la receta existe
      if (!ri.ingredient) return false;
      
      // Buscar si el usuario tiene este ingrediente
      return userIngredients.some(ui => {
        // Check regular ingredients
        if (ui.ingredient?.id === ri.ingredient.id) return true;
        
        // Check custom ingredients by name
        if (ui.customIngredient) {
          const recipeName = ri.ingredient.name.toLowerCase().trim();
          const customName = ui.customIngredient.name.toLowerCase().trim();
          return recipeName === customName;
        }
        
        return false;
      });
    });
  },

  _hasMissingIngredients(recipe: RecipeDto, userIngredients: UserIngredientDto[]): boolean {
    return recipe.ingredients.some(ri => {
      // Verificar que el ingrediente de la receta existe
      if (!ri.ingredient) return false;
      
      // Verificar si el usuario NO tiene este ingrediente
      return !userIngredients.some(ui => {
        // Check regular ingredients
        if (ui.ingredient?.id === ri.ingredient.id) return true;
        
        // Check custom ingredients by name
        if (ui.customIngredient) {
          const recipeName = ri.ingredient.name.toLowerCase().trim();
          const customName = ui.customIngredient.name.toLowerCase().trim();
          return recipeName === customName;
        }
        
        return false;
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
        // Check regular ingredients
        if (ui.ingredient?.id === ri.ingredient.id) return true;
        
        // Check custom ingredients by name
        if (ui.customIngredient) {
          const recipeName = ri.ingredient.name.toLowerCase().trim();
          const customName = ui.customIngredient.name.toLowerCase().trim();
          return recipeName === customName;
        }
        
        return false;
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
    
    console.log(`      🔍 Checking compatibility: "${unit1Abbr}" vs "${unit2Abbr}"`);

    if (weightUnits.includes(unit1Abbr) && weightUnits.includes(unit2Abbr)) {
      console.log(`      ✅ Both are weight units`);
      return true;
    }
    if (volumeUnits.includes(unit1Abbr) && volumeUnits.includes(unit2Abbr)) {
      console.log(`      ✅ Both are volume units`);
      return true;
    }
    if (unitUnits.includes(unit1Abbr) && unitUnits.includes(unit2Abbr)) {
      console.log(`      ✅ Both are unit/count units`);
      return true;
    }
    
    console.log(`      ❌ Units are not compatible`);
    console.log(`      📝 Weight units: ${weightUnits.join(', ')}`);
    console.log(`      📝 Volume units: ${volumeUnits.join(', ')}`);
    console.log(`      📝 Unit/count units: ${unitUnits.join(', ')}`);
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

    const unitAbbr = unit.abbreviation?.toLowerCase();
    const factor = conversionFactors[unitAbbr];
    
    console.log(`      🔄 Converting ${quantity} ${unitAbbr} (factor: ${factor})`);
    
    if (factor !== undefined) {
      const result = quantity * factor;
      console.log(`      ➡️ Result: ${result} base units`);
      return result;
    }
    
    console.log(`      ❌ No conversion factor found for "${unitAbbr}"`);
    console.log(`      📝 Available factors:`, Object.keys(conversionFactors));
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