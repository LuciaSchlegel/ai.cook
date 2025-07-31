#!/usr/bin/env node

/**
 * Script to seed recipes from the recipes.json file
 * This script converts the recipes.json format to the expected database format
 * and automatically creates missing ingredients with proper categorization
 */

import { AppDataSource } from '../config/data_source';
import { seedRecipesService, RecipeSeedInput } from '../services/admin.service';
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

function convertRecipeFormat(jsonRecipe: RecipeJsonFormat): RecipeSeedInput {
    return {
        name: jsonRecipe.name,
        description: jsonRecipe.description,
        steps: jsonRecipe.steps,
        cookingTime: jsonRecipe.cookingTime,
        difficulty: jsonRecipe.difficulty,
        servings: jsonRecipe.servings,
        image: jsonRecipe.image || '',
        ingredients: jsonRecipe.ingredients.map(ing => ({
            name: ing.name,
            quantity: ing.quantity,
            unit: ing.unit,
            additionalInfo: ing.additionalInfo,
            relativeQuantity: ing.relativeQuantity
        })),
        tags: jsonRecipe.tags
    };
}

async function seedRecipesFromJson(limit?: number) {
    try {
        console.log('🚀 Initializing database connection...');
        await AppDataSource.initialize();
        console.log('✅ Database connection established');

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

        const recipesToSeed = limit ? recipesData.recipes.slice(0, limit) : recipesData.recipes;
        console.log(`📋 Found ${recipesData.recipes.length} recipes, seeding ${recipesToSeed.length}...`);

        // Convert to the expected format
        const convertedRecipes = recipesToSeed.map(convertRecipeFormat);

        // Validate conversion
        console.log('🔍 Validating converted recipes...');
        for (const recipe of convertedRecipes) {
            if (!recipe.name || !recipe.description || !recipe.ingredients?.length) {
                throw new Error(`Invalid recipe data for: ${recipe.name}`);
            }
        }

        console.log('✅ Recipe validation completed');

        // Seed the recipes (this will automatically create missing ingredients)
        console.log('🌱 Starting recipe seeding process...');
        const results = await seedRecipesService(convertedRecipes);

        console.log(`🎉 Successfully seeded ${results.length} recipes!`);
        
        // Summary of what was created
        const summary = {
            totalRecipes: results.length,
            recipeNames: results.map(r => r.name),
            totalIngredients: results.reduce((sum, r) => sum + r.ingredients.length, 0)
        };

        console.log('\n📊 SEEDING SUMMARY:');
        console.log(`   • Total recipes created: ${summary.totalRecipes}`);
        console.log(`   • Total recipe ingredients: ${summary.totalIngredients}`);
        console.log(`   • Recipe names: ${summary.recipeNames.slice(0, 5).join(', ')}${summary.recipeNames.length > 5 ? '...' : ''}`);

    } catch (error: any) {
        console.error('❌ Error during recipe seeding:', error.message);
        if (error.stack) {
            console.error('Stack trace:', error.stack);
        }
        process.exit(1);
    } finally {
        if (AppDataSource.isInitialized) {
            await AppDataSource.destroy();
            console.log('🔌 Database connection closed');
        }
    }
}

// Parse command line arguments
const args = process.argv.slice(2);
const limitFlag = args.find(arg => arg.startsWith('--limit='));
const limit = limitFlag ? parseInt(limitFlag.split('=')[1]) : undefined;

if (limit && (isNaN(limit) || limit <= 0)) {
    console.error('❌ Invalid limit value. Please use --limit=NUMBER (positive integer)');
    process.exit(1);
}

// Run the seeding process
seedRecipesFromJson(limit);

// Usage examples:
// npm run seed-recipes                    # Seed all recipes
// npm run seed-recipes -- --limit=5      # Seed only first 5 recipes
// npx ts-node src/scripts/seed-recipes-from-json.ts --limit=3