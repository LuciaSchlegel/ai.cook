#!/usr/bin/env node

/**
 * Script to seed basic entities (categories, units, tags) required for recipe seeding
 * Run this before seeding recipes to ensure all dependencies exist
 */

import { AppDataSource } from '../config/data_source';
import { seedResourcesService } from '../services/admin.service';

const BASIC_CATEGORIES = [
    { name: 'Grains & Cereals' },
    { name: 'Dairy & Eggs' },
    { name: 'Vegetables' },
    { name: 'Fruits' },
    { name: 'Meat & Seafood' },
    { name: 'Pantry & Spices' },
    { name: 'Nuts & Seeds' },
    { name: 'Plant-Based Proteins' },
    { name: 'Others' }
];

const BASIC_UNITS = [
    { name: 'gram', abbreviation: 'g', type: 'weight' },
    { name: 'kilogram', abbreviation: 'kg', type: 'weight' },
    { name: 'ounce', abbreviation: 'oz', type: 'weight' },
    { name: 'pound', abbreviation: 'lb', type: 'weight' },
    { name: 'milliliter', abbreviation: 'ml', type: 'volume' },
    { name: 'liter', abbreviation: 'l', type: 'volume' },
    { name: 'cup', abbreviation: 'cup', type: 'volume' },
    { name: 'tablespoon', abbreviation: 'tbsp', type: 'volume' },
    { name: 'teaspoon', abbreviation: 'tsp', type: 'volume' },
    { name: 'fluid ounce', abbreviation: 'fl oz', type: 'volume' },
    { name: 'pint', abbreviation: 'pt', type: 'volume' },
    { name: 'quart', abbreviation: 'qt', type: 'volume' },
    { name: 'unit', abbreviation: 'u', type: 'count' },
    { name: 'piece', abbreviation: 'pc', type: 'count' },
    { name: 'dozen', abbreviation: 'doz', type: 'count' },
    { name: 'pinch', abbreviation: 'pinch', type: 'measure' },
    { name: 'dash', abbreviation: 'dash', type: 'measure' },
    { name: 'to taste', abbreviation: 'to taste', type: 'measure' },
    { name: 'clove', abbreviation: 'clove', type: 'count' },
    { name: 'stalk', abbreviation: 'stalk', type: 'count' },
    { name: 'sprig', abbreviation: 'sprig', type: 'count' },
    { name: 'bunch', abbreviation: 'bunch', type: 'count' },
    { name: 'slice', abbreviation: 'slice', type: 'count' },
    { name: 'can', abbreviation: 'can', type: 'container' },
    { name: 'bottle', abbreviation: 'bottle', type: 'container' },
    { name: 'jar', abbreviation: 'jar', type: 'container' },
    { name: 'package', abbreviation: 'pkg', type: 'container' }
];

const BASIC_DIETARY_TAGS = [
    { name: 'Vegan' },
    { name: 'Vegetarian' },
    { name: 'Gluten-Free' },
    { name: 'Lactose-Free' },
];

const BASIC_RECIPE_TAGS = [
    { name: 'Italian' },
    { name: 'American' },
    { name: 'Asian' },
    { name: 'Chinese' },
    { name: 'Taiwanese' },
    { name: 'Thai' },
    { name: 'Indian' },
    { name: 'Pakistani' },
    { name: 'Austrian' },
    { name: 'French' },
    { name: 'British' },
    { name: 'Latin American' },
    { name: 'Baking' },
    { name: 'Dessert' },
    { name: 'Breakfast' },
    { name: 'Lunch' },
    { name: 'Dinner' },
    { name: 'Snack' },
    { name: 'Vegetarian' },
    { name: 'Vegan' },
    { name: 'Gluten Free' },
    { name: 'Dairy Free' },
    { name: 'Healthy' },
    { name: 'Quick' },
    { name: 'Easy' },
    { name: 'Pasta' },
    { name: 'Soup' },
    { name: 'Salad' },
    { name: 'Cake' },
    { name: 'Muffins' },
    { name: 'Chocolate' },
    { name: 'Seafood' },
    { name: 'Chicken' },
    { name: 'Beef' },
    { name: 'Pork' },
    { name: 'Rice' },
    { name: 'Noodles' },
    { name: 'Spicy' },
    { name: 'Sweet' },
    { name: 'Savory' },
    { name: 'Oven' },
    { name: 'Stovetop' },
    { name: 'No Cook' },
    { name: 'One Pot' },
    { name: 'Sheet Pan' },
    { name: 'Grilling' },
    { name: 'Frying' },
    { name: 'Steaming' },
    { name: 'Layer Cake' },
    { name: 'Pound Cake' },
    { name: 'Cream Cheese' },
    { name: 'No Refined Sugar' },
    { name: 'Overnight' },
    { name: 'Proteic' }
];

async function seedBasicEntities() {
    try {
        console.log('🚀 Initializing database connection...');
        await AppDataSource.initialize();
        console.log('✅ Database connection established');

        console.log('📁 Seeding categories...');
        await seedResourcesService('categories', BASIC_CATEGORIES);
        console.log(`✅ Created ${BASIC_CATEGORIES.length} categories`);

        console.log('📏 Seeding units...');
        await seedResourcesService('units', BASIC_UNITS);
        console.log(`✅ Created ${BASIC_UNITS.length} units`);

        console.log('🥗 Seeding dietary tags...');
        await seedResourcesService('dietary_tags', BASIC_DIETARY_TAGS);
        console.log(`✅ Created ${BASIC_DIETARY_TAGS.length} dietary tags`);

        console.log('🏷️ Seeding recipe tags...');
        await seedResourcesService('recipe_tags', BASIC_RECIPE_TAGS);
        console.log(`✅ Created ${BASIC_RECIPE_TAGS.length} recipe tags`);

        console.log('\n🎉 Basic entities seeding completed successfully!');
        console.log('\n📋 Summary:');
        console.log(`   • Categories: ${BASIC_CATEGORIES.length}`);
        console.log(`   • Units: ${BASIC_UNITS.length}`);
        console.log(`   • Dietary Tags: ${BASIC_DIETARY_TAGS.length}`);
        console.log(`   • Recipe Tags: ${BASIC_RECIPE_TAGS.length}`);
        console.log('\nℹ️ You can now proceed to seed recipes using the recipe seeding script.');

    } catch (error: any) {
        console.error('❌ Error during basic entities seeding:', error.message);
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

// Run the seeding process
seedBasicEntities();