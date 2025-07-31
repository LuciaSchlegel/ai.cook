#!/usr/bin/env node

/**
 * Script to validate all recipes data and collect validation errors
 * This helps identify data quality issues that need to be fixed
 */

import * as fs from 'fs';
import * as path from 'path';

interface RecipeJsonIngredient {
    name: string;
    quantity: string;
    unit?: string;
    additionalInfo?: string;
    relativeQuantity?: string;
}

interface RecipeJsonFormat {
    name: string;
    description: string;
    steps: string[];
    cookingTime: string;
    difficulty: string;
    servings: string;
    image?: string;
    ingredients: RecipeJsonIngredient[];
    tags: string[];
}

interface RecipeJsonFile {
    recipes: RecipeJsonFormat[];
}

interface ValidationError {
    recipeIndex: number;
    recipeName: string;
    errorType: string;
    field?: string;
    ingredientIndex?: number;
    ingredientName?: string;
    value?: any;
    message: string;
}

function validateRecipeData(recipes: RecipeJsonFormat[]): ValidationError[] {
    const errors: ValidationError[] = [];

    recipes.forEach((recipe, recipeIndex) => {
        // Validate recipe basic fields
        if (!recipe.name || typeof recipe.name !== 'string' || recipe.name.trim() === '') {
            errors.push({
                recipeIndex,
                recipeName: recipe.name || `Recipe #${recipeIndex + 1}`,
                errorType: 'MISSING_RECIPE_NAME',
                field: 'name',
                value: recipe.name,
                message: 'Recipe name is missing or empty'
            });
        }

        if (!recipe.description || typeof recipe.description !== 'string' || recipe.description.trim() === '') {
            errors.push({
                recipeIndex,
                recipeName: recipe.name,
                errorType: 'MISSING_DESCRIPTION',
                field: 'description',
                value: recipe.description,
                message: 'Recipe description is missing or empty'
            });
        }

        if (!Array.isArray(recipe.ingredients)) {
            errors.push({
                recipeIndex,
                recipeName: recipe.name,
                errorType: 'INVALID_INGREDIENTS',
                field: 'ingredients',
                value: recipe.ingredients,
                message: 'Ingredients must be an array'
            });
        } else if (recipe.ingredients.length === 0) {
            errors.push({
                recipeIndex,
                recipeName: recipe.name,
                errorType: 'NO_INGREDIENTS',
                field: 'ingredients',
                value: recipe.ingredients,
                message: 'Recipe must have at least one ingredient'
            });
        }

        if (!Array.isArray(recipe.tags)) {
            errors.push({
                recipeIndex,
                recipeName: recipe.name,
                errorType: 'INVALID_TAGS',
                field: 'tags',
                value: recipe.tags,
                message: 'Tags must be an array'
            });
        }

        if (!Array.isArray(recipe.steps)) {
            errors.push({
                recipeIndex,
                recipeName: recipe.name,
                errorType: 'INVALID_STEPS',
                field: 'steps',
                value: recipe.steps,
                message: 'Steps must be an array'
            });
        }

        // Validate ingredients
        if (Array.isArray(recipe.ingredients)) {
            recipe.ingredients.forEach((ingredient, ingredientIndex) => {
                // Check ingredient name
                if (!ingredient.name || typeof ingredient.name !== 'string' || ingredient.name.trim() === '') {
                    errors.push({
                        recipeIndex,
                        recipeName: recipe.name,
                        errorType: 'MISSING_INGREDIENT_NAME',
                        field: 'name',
                        ingredientIndex,
                        ingredientName: ingredient.name || `Ingredient #${ingredientIndex + 1}`,
                        value: ingredient.name,
                        message: `Ingredient #${ingredientIndex + 1} name is missing or empty`
                    });
                }

                // Check ingredient quantity
                if (ingredient.quantity === undefined || ingredient.quantity === null) {
                    errors.push({
                        recipeIndex,
                        recipeName: recipe.name,
                        errorType: 'UNDEFINED_QUANTITY',
                        field: 'quantity',
                        ingredientIndex,
                        ingredientName: ingredient.name,
                        value: ingredient.quantity,
                        message: `Ingredient "${ingredient.name}" has undefined/null quantity`
                    });
                } else if (typeof ingredient.quantity !== 'string') {
                    errors.push({
                        recipeIndex,
                        recipeName: recipe.name,
                        errorType: 'INVALID_QUANTITY_TYPE',
                        field: 'quantity',
                        ingredientIndex,
                        ingredientName: ingredient.name,
                        value: ingredient.quantity,
                        message: `Ingredient "${ingredient.name}" quantity must be a string, got ${typeof ingredient.quantity}`
                    });
                } else if (ingredient.quantity.trim() === '') {
                    errors.push({
                        recipeIndex,
                        recipeName: recipe.name,
                        errorType: 'EMPTY_QUANTITY',
                        field: 'quantity',
                        ingredientIndex,
                        ingredientName: ingredient.name,
                        value: ingredient.quantity,
                        message: `Ingredient "${ingredient.name}" has empty quantity`
                    });
                }

                // Check for problematic quantity values
                if (typeof ingredient.quantity === 'string') {
                    const qty = ingredient.quantity.toLowerCase().trim();
                    if (qty === 'as needed' || qty === 'as desired' || qty === 'optional') {
                        errors.push({
                            recipeIndex,
                            recipeName: recipe.name,
                            errorType: 'PROBLEMATIC_QUANTITY',
                            field: 'quantity',
                            ingredientIndex,
                            ingredientName: ingredient.name,
                            value: ingredient.quantity,
                            message: `Ingredient "${ingredient.name}" has problematic quantity: "${ingredient.quantity}" - should use "to taste" or a numeric value`
                        });
                    }
                }

                // Check unit format (if present)
                if (ingredient.unit !== undefined && (typeof ingredient.unit !== 'string' || ingredient.unit.trim() === '')) {
                    errors.push({
                        recipeIndex,
                        recipeName: recipe.name,
                        errorType: 'INVALID_UNIT',
                        field: 'unit',
                        ingredientIndex,
                        ingredientName: ingredient.name,
                        value: ingredient.unit,
                        message: `Ingredient "${ingredient.name}" has invalid unit`
                    });
                }
            });
        }

        // Validate optional fields format
        if (recipe.cookingTime !== undefined && (typeof recipe.cookingTime !== 'string' || recipe.cookingTime.trim() === '')) {
            errors.push({
                recipeIndex,
                recipeName: recipe.name,
                errorType: 'INVALID_COOKING_TIME',
                field: 'cookingTime',
                value: recipe.cookingTime,
                message: 'Cooking time must be a non-empty string'
            });
        }

        if (recipe.difficulty !== undefined && (typeof recipe.difficulty !== 'string' || recipe.difficulty.trim() === '')) {
            errors.push({
                recipeIndex,
                recipeName: recipe.name,
                errorType: 'INVALID_DIFFICULTY',
                field: 'difficulty',
                value: recipe.difficulty,
                message: 'Difficulty must be a non-empty string'
            });
        }

        if (recipe.servings !== undefined && (typeof recipe.servings !== 'string' || recipe.servings.trim() === '')) {
            errors.push({
                recipeIndex,
                recipeName: recipe.name,
                errorType: 'INVALID_SERVINGS',
                field: 'servings',
                value: recipe.servings,
                message: 'Servings must be a non-empty string'
            });
        }
    });

    return errors;
}

function generateFixSuggestions(errors: ValidationError[]): string[] {
    const suggestions: string[] = [];
    const errorsByType = new Map<string, ValidationError[]>();

    // Group errors by type
    errors.forEach(error => {
        if (!errorsByType.has(error.errorType)) {
            errorsByType.set(error.errorType, []);
        }
        errorsByType.get(error.errorType)!.push(error);
    });

    // Generate suggestions for each error type
    errorsByType.forEach((errorList, errorType) => {
        switch (errorType) {
            case 'UNDEFINED_QUANTITY':
                suggestions.push(`\n🔧 UNDEFINED_QUANTITY (${errorList.length} issues):`);
                suggestions.push('   Fix: Add "quantity": "to taste" or appropriate numeric value');
                errorList.forEach(error => {
                    suggestions.push(`   - Recipe: "${error.recipeName}" → Ingredient: "${error.ingredientName}"`);
                });
                break;

            case 'PROBLEMATIC_QUANTITY':
                suggestions.push(`\n🔧 PROBLEMATIC_QUANTITY (${errorList.length} issues):`);
                suggestions.push('   Fix: Replace "as needed"/"as desired"/"optional" with "to taste" or numeric value');
                errorList.forEach(error => {
                    suggestions.push(`   - Recipe: "${error.recipeName}" → Ingredient: "${error.ingredientName}" → Current: "${error.value}"`);
                });
                break;

            case 'EMPTY_QUANTITY':
                suggestions.push(`\n🔧 EMPTY_QUANTITY (${errorList.length} issues):`);
                suggestions.push('   Fix: Add proper quantity value');
                errorList.forEach(error => {
                    suggestions.push(`   - Recipe: "${error.recipeName}" → Ingredient: "${error.ingredientName}"`);
                });
                break;

            case 'MISSING_INGREDIENT_NAME':
                suggestions.push(`\n🔧 MISSING_INGREDIENT_NAME (${errorList.length} issues):`);
                suggestions.push('   Fix: Add proper ingredient name');
                errorList.forEach(error => {
                    suggestions.push(`   - Recipe: "${error.recipeName}" → Ingredient #${error.ingredientIndex! + 1}`);
                });
                break;

            default:
                suggestions.push(`\n🔧 ${errorType} (${errorList.length} issues):`);
                errorList.forEach(error => {
                    suggestions.push(`   - ${error.message}`);
                });
        }
    });

    return suggestions;
}

async function validateRecipesData() {
    try {
        console.log('🔍 Starting recipe data validation...');
        
        // Read the recipes.json file
        const recipesJsonPath = path.join(__dirname, '../utils/recipes.json');
        if (!fs.existsSync(recipesJsonPath)) {
            throw new Error(`Recipes file not found at: ${recipesJsonPath}`);
        }

        console.log('📖 Reading recipes.json file...');
        const fileContent = fs.readFileSync(recipesJsonPath, 'utf-8');
        const recipesData: RecipeJsonFile = JSON.parse(fileContent);

        if (!recipesData.recipes || !Array.isArray(recipesData.recipes)) {
            throw new Error('Invalid recipes.json format: missing recipes array');
        }

        console.log(`📋 Found ${recipesData.recipes.length} recipes to validate...`);

        // Validate all recipes
        const errors = validateRecipeData(recipesData.recipes);

        console.log(`\n📊 VALIDATION RESULTS:`);
        console.log(`   Total recipes: ${recipesData.recipes.length}`);
        console.log(`   Total errors found: ${errors.length}`);

        if (errors.length === 0) {
            console.log(`\n✅ All recipes are valid! No issues found.`);
            return;
        }

        // Group errors by recipe
        const errorsByRecipe = new Map<string, ValidationError[]>();
        errors.forEach(error => {
            const key = `${error.recipeName} (#${error.recipeIndex + 1})`;
            if (!errorsByRecipe.has(key)) {
                errorsByRecipe.set(key, []);
            }
            errorsByRecipe.get(key)!.push(error);
        });

        console.log(`\n❌ ISSUES FOUND IN ${errorsByRecipe.size} RECIPES:\n`);

        // Display errors by recipe
        errorsByRecipe.forEach((recipeErrors, recipeKey) => {
            console.log(`📝 ${recipeKey} (${recipeErrors.length} issues):`);
            recipeErrors.forEach(error => {
                if (error.ingredientName) {
                    console.log(`   • ${error.errorType}: ${error.message}`);
                    console.log(`     → Ingredient: "${error.ingredientName}" (${error.field}: ${JSON.stringify(error.value)})`);
                } else {
                    console.log(`   • ${error.errorType}: ${error.message}`);
                    console.log(`     → Field: ${error.field}, Value: ${JSON.stringify(error.value)}`);
                }
            });
            console.log('');
        });

        // Generate fix suggestions
        const suggestions = generateFixSuggestions(errors);
        console.log('\n🛠️ FIX SUGGESTIONS:');
        suggestions.forEach(suggestion => console.log(suggestion));

        // Generate a summary report
        const errorTypes = [...new Set(errors.map(e => e.errorType))];
        console.log('\n📈 ERROR SUMMARY:');
        errorTypes.forEach(type => {
            const count = errors.filter(e => e.errorType === type).length;
            console.log(`   • ${type}: ${count} issue${count > 1 ? 's' : ''}`);
        });

        console.log('\n💡 NEXT STEPS:');
        console.log('   1. Fix the issues listed above in your recipes.json file');
        console.log('   2. Re-run this validation script to confirm fixes');
        console.log('   3. Once all issues are resolved, run: npm run seed:recipes');

    } catch (error: any) {
        console.error('❌ Error during validation:', error.message);
        if (error.stack) {
            console.error('Stack trace:', error.stack);
        }
        process.exit(1);
    }
}

// Run the validation
validateRecipesData();