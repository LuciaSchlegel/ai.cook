import { UserRole } from "../entities/User";
import { CategoryRepository } from "../repositories/category.repository";
import { IngredientRepository } from "../repositories/ingredient.repository";
import { RecipeTagRepository } from "../repositories/recipe_tag.repository";
import { UserRepository } from "../repositories/user.repository";
import { BadRequestError, NotFoundError } from "../types/AppError";
import { QueryFailedError } from "typeorm";
import { RecipeRepository } from "../repositories/recipe.repository";
import { RecipeIngredientRepository } from "../repositories/recipe_ingredient.repository";
import { UnitRepository } from "../repositories/unit.repository";
import { ILike } from "typeorm";

// Ingredient categorization mapping
const INGREDIENT_CATEGORIES: Record<string, string> = {
    // Grains & Cereals
    'flour': 'Grains & Cereals',
    'oats': 'Grains & Cereals',
    'rice': 'Grains & Cereals',
    'pasta': 'Grains & Cereals',
    'noodles': 'Grains & Cereals',
    'bread': 'Grains & Cereals',
    'pappardelle': 'Grains & Cereals',
    'spaghetti': 'Grains & Cereals',
    
    // Dairy & Eggs
    'milk': 'Dairy & Eggs',
    'cream': 'Dairy & Eggs',
    'butter': 'Dairy & Eggs',
    'cheese': 'Dairy & Eggs',
    'eggs': 'Dairy & Eggs',
    'yogurt': 'Dairy & Eggs',
    'ricotta': 'Dairy & Eggs',
    'mozzarella': 'Dairy & Eggs',
    'pecorino': 'Dairy & Eggs',
    'parmigiano': 'Dairy & Eggs',
    'buttermilk': 'Dairy & Eggs',
    'sour cream': 'Dairy & Eggs',
    
    // Vegetables
    'tomatoes': 'Vegetables',
    'onion': 'Vegetables',
    'garlic': 'Vegetables',
    'basil': 'Vegetables',
    'parsley': 'Vegetables',
    'celery': 'Vegetables',
    'carrot': 'Vegetables',
    'eggplant': 'Vegetables',
    'spinach': 'Vegetables',
    'scallions': 'Vegetables',
    'shallots': 'Vegetables',
    'ginger': 'Vegetables',
    'cilantro': 'Vegetables',
    'sage': 'Vegetables',
    'rosemary': 'Vegetables',
    'chives': 'Vegetables',
    'potatoes': 'Vegetables',
    
    // Fruits
    'lemon': 'Fruits',
    'lime': 'Fruits',
    'berries': 'Fruits',
    'blueberries': 'Fruits',
    
    // Meat & Seafood
    'beef': 'Meat & Seafood',
    'pork': 'Meat & Seafood',
    'chicken': 'Meat & Seafood',
    'lamb': 'Meat & Seafood',
    'turkey': 'Meat & Seafood',
    'clams': 'Meat & Seafood',
    'mussels': 'Meat & Seafood',
    'shrimp': 'Meat & Seafood',
    'squid': 'Meat & Seafood',
    
    // Pantry & Spices
    'salt': 'Pantry & Spices',
    'pepper': 'Pantry & Spices',
    'sugar': 'Pantry & Spices',
    'honey': 'Pantry & Spices',
    'oil': 'Pantry & Spices',
    'vinegar': 'Pantry & Spices',
    'vanilla': 'Pantry & Spices',
    'cinnamon': 'Pantry & Spices',
    'baking': 'Pantry & Spices',
    'soy sauce': 'Pantry & Spices',
    'wine': 'Pantry & Spices',
    'coffee': 'Pantry & Spices',
    'cocoa': 'Pantry & Spices',
    'mustard': 'Pantry & Spices',
    'anchovy': 'Pantry & Spices',
    'anchovy paste': 'Pantry & Spices',
    'capers': 'Pantry & Spices',
    'mayonnaise': 'Pantry & Spices',
    'breadcrumbs': 'Pantry & Spices',
    'cornstarch': 'Pantry & Spices',
    'espresso': 'Pantry & Spices',
    
    // Nuts & Seeds
    'sesame': 'Nuts & Seeds',
    
    // Others
    'tofu': 'Plant-Based Proteins',
    'bamboo shoots': 'Vegetables',
    'mushrooms': 'Vegetables',
    'galangal': 'Vegetables',
    'lemongrass': 'Vegetables',
    'makrut lime leaves': 'Vegetables',
    'thai chiles': 'Vegetables',
    'chiles': 'Vegetables',
    'coconut': 'Pantry & Spices',
    'fish sauce': 'Pantry & Spices',
    'rice wine': 'Pantry & Spices',
    'sesame oil': 'Pantry & Spices',
    'chili oil': 'Pantry & Spices',
    'sichuan peppercorns': 'Pantry & Spices',
    'star anise': 'Pantry & Spices',
    'cardamom': 'Pantry & Spices',
    'cloves': 'Pantry & Spices',
    'bay leaves': 'Pantry & Spices',
    'garam masala': 'Pantry & Spices',
    'turmeric': 'Pantry & Spices',
    'cumin': 'Pantry & Spices',
    'saffron': 'Pantry & Spices',
    'rosewater': 'Pantry & Spices',
    'pandan water': 'Pantry & Spices',
    'juniper berries': 'Pantry & Spices',
    'tomato paste': 'Pantry & Spices',
    'stock': 'Pantry & Spices',
    'broth': 'Pantry & Spices',
    'yeast': 'Pantry & Spices'
};

// Dietary flags mapping
const DIETARY_FLAGS: Record<string, Partial<IngredientSeedInput>> = {
    'milk': { isVegetarian: true, isLactoseFree: false },
    'cream': { isVegetarian: true, isLactoseFree: false },
    'butter': { isVegetarian: true, isLactoseFree: false },
    'cheese': { isVegetarian: true, isLactoseFree: false },
    'eggs': { isVegetarian: true },
    'yogurt': { isVegetarian: true, isLactoseFree: false },
    'ricotta': { isVegetarian: true, isLactoseFree: false },
    'mozzarella': { isVegetarian: true, isLactoseFree: false },
    'pecorino': { isVegetarian: true, isLactoseFree: false },
    'parmigiano': { isVegetarian: true, isLactoseFree: false },
    'buttermilk': { isVegetarian: true, isLactoseFree: false },
    'sour cream': { isVegetarian: true, isLactoseFree: false },
    
    'beef': { isVegan: false, isVegetarian: false },
    'pork': { isVegan: false, isVegetarian: false },
    'chicken': { isVegan: false, isVegetarian: false },
    'lamb': { isVegan: false, isVegetarian: false },
    'turkey': { isVegan: false, isVegetarian: false },
    'clams': { isVegan: false, isVegetarian: false },
    'mussels': { isVegan: false, isVegetarian: false },
    'shrimp': { isVegan: false, isVegetarian: false },
    'squid': { isVegan: false, isVegetarian: false },
    'fish sauce': { isVegan: false, isVegetarian: false },
    'anchovy': { isVegan: false, isVegetarian: false },
    
    'flour': { isVegan: true, isVegetarian: true, isGlutenFree: false },
    'oats': { isVegan: true, isVegetarian: true, isGlutenFree: false },
    'pasta': { isVegan: true, isVegetarian: true, isGlutenFree: false },
    'bread': { isVegan: true, isVegetarian: true, isGlutenFree: false },
    'spaghetti': { isVegan: true, isVegetarian: true, isGlutenFree: false },
    'pappardelle': { isVegan: true, isVegetarian: true, isGlutenFree: false },
    'noodles': { isVegan: true, isVegetarian: true, isGlutenFree: false },
    
    'tofu': { isVegan: true, isVegetarian: true, isGlutenFree: true, isLactoseFree: true }
};

export interface UnitSeedInput {
    name: string;
    abbreviation: string;
    type: string;
}

export interface Resource {
    name: string;
    abbreviation?: string;
    type?: string;
}

export interface IngredientSeedInput {
    name: string;
    category: string;
    isVegan?: boolean;
    isVegetarian?: boolean;
    isGlutenFree?: boolean;
    isLactoseFree?: boolean;
}

export interface RecipeIngredientInput {
    name: string;
    quantity: string;
    unit?: string;
    additionalInfo?: string;
    relativeQuantity?: string;
}

export interface RecipeSeedInput {
    name: string;
    description: string;
    steps?: string[];
    cookingTime?: string;
    tags?: string[];
    difficulty?: string;
    servings?: string;
    image?: string;
    ingredients: RecipeIngredientInput[];
}


async function handleEntitySave<T>(
    saveOperation: () => Promise<T>,
    entityName: string
): Promise<T> {
    try {
        return await saveOperation();
    } catch (error: any) {
        if (error instanceof QueryFailedError) {
            if (error.message.includes('duplicate key value violates unique constraint')) {
                throw new BadRequestError(`${entityName} with this name already exists`);
            }
        }
        throw new BadRequestError(`Error creating ${entityName.toLowerCase()}: ${error.message}`);
    }
}

async function validateResource(resource: Resource | undefined): Promise<void> {
    if (!resource) {
        throw new BadRequestError("Resource is required");
    }

    if (typeof resource.name !== 'string' || !resource.name.trim()) {
        throw new BadRequestError("Resource name is required and must be a non-empty string");
    }

    // Additional validation for units
    if (resource.abbreviation !== undefined || resource.type !== undefined) {
        if (typeof resource.abbreviation !== 'string' || !resource.abbreviation.trim()) {
            throw new BadRequestError("Unit abbreviation is required and must be a non-empty string");
        }
        if (typeof resource.type !== 'string' || !resource.type.trim()) {
            throw new BadRequestError("Unit type is required and must be a non-empty string");
        }
    }
}

async function validateRecipe(recipe: RecipeSeedInput): Promise<void> {
    if (!recipe.name || !recipe.description) {
        throw new BadRequestError("Recipe must have a name and description");
    }
    if (!Array.isArray(recipe.ingredients) || recipe.ingredients.length === 0) {
        throw new BadRequestError("Recipe must have at least one ingredient");
    }
    if (!Array.isArray(recipe.tags)) {
        throw new BadRequestError("Recipe tags must be an array");
    }
    
    // Validate each ingredient
    for (let i = 0; i < recipe.ingredients.length; i++) {
        const ingredient = recipe.ingredients[i];
        if (!ingredient.name || typeof ingredient.name !== 'string' || ingredient.name.trim() === '') {
            throw new BadRequestError(`Recipe "${recipe.name}" ingredient #${i + 1} must have a valid name. Got: ${JSON.stringify(ingredient)}`);
        }
        // Handle missing or invalid quantities more gracefully
        if (ingredient.quantity === undefined || ingredient.quantity === null) {
            console.warn(`⚠️ Recipe "${recipe.name}" ingredient "${ingredient.name}" has undefined quantity, defaulting to "to taste"`);
            ingredient.quantity = "to taste"; // Fix it on the fly
        } else if (typeof ingredient.quantity !== 'string') {
            throw new BadRequestError(`Recipe "${recipe.name}" ingredient "${ingredient.name}" (#${i + 1}) quantity must be a string. Got: ${JSON.stringify(ingredient.quantity)}`);
        } else {
            const trimmedQuantity = ingredient.quantity.trim();
            if (trimmedQuantity === '') {
                console.warn(`⚠️ Recipe "${recipe.name}" ingredient "${ingredient.name}" has empty quantity, defaulting to "to taste"`);
                ingredient.quantity = "to taste"; // Fix it on the fly
            }
        }
    }
}

function normalizeIngredientName(name: string): string {
    return name.toLowerCase().trim()
        .replace(/^(fresh|dried|ground|whole|chopped|minced|grated|sliced|diced)\s+/i, '') // Remove preparation words
        .replace(/\s+(extract|powder|sauce|paste|oil|juice|leaves)$/i, ' $1') // Normalize endings
        .replace(/\s+/g, ' '); // Normalize whitespace
}

function findIngredientCategory(ingredientName: string): string {
    const normalized = normalizeIngredientName(ingredientName);
    
    // Try exact match first
    if (INGREDIENT_CATEGORIES[normalized]) {
        return INGREDIENT_CATEGORIES[normalized];
    }
    
    // Try partial matches
    for (const [key, category] of Object.entries(INGREDIENT_CATEGORIES)) {
        if (normalized.includes(key) || key.includes(normalized)) {
            return category;
        }
    }
    
    // Default category
    return 'Others';
}

function getIngredientDietaryFlags(ingredientName: string): Partial<IngredientSeedInput> {
    const normalized = normalizeIngredientName(ingredientName);
    
    // Try exact match first
    if (DIETARY_FLAGS[normalized]) {
        return DIETARY_FLAGS[normalized];
    }
    
    // Try partial matches
    for (const [key, flags] of Object.entries(DIETARY_FLAGS)) {
        if (normalized.includes(key) || key.includes(normalized)) {
            return flags;
        }
    }
    
    // Default: assume vegan and vegetarian unless proven otherwise
    return {
        isVegan: true,
        isVegetarian: true,
        isGlutenFree: true,
        isLactoseFree: true
    };
}

function parseQuantity(quantityStr: string): number {
    if (!quantityStr || typeof quantityStr !== 'string') {
        console.warn(`⚠️ Invalid quantity string: ${quantityStr}, defaulting to 1`);
        return 1;
    }

    const trimmed = quantityStr.trim();
    const lowerTrimmed = trimmed.toLowerCase();
    
    // Handle various non-numeric quantity expressions
    if (trimmed === '' || 
        lowerTrimmed === 'to taste' || 
        lowerTrimmed === 'as desired' || 
        lowerTrimmed === 'as needed' ||
        lowerTrimmed === 'optional' ||
        lowerTrimmed === 'for garnish' ||
        lowerTrimmed === 'for serving') {
        return 1; // Default for non-numeric quantities
    }

    // Handle various quantity formats from recipes.json
    const cleanStr = trimmed.replace(/[^\d.,\/\-]/g, '').trim();
    
    if (cleanStr === '') {
        console.warn(`⚠️ No numeric content in quantity: "${quantityStr}", defaulting to 1`);
        return 1;
    }
    
    // Handle ranges like "45-75"
    if (cleanStr.includes('-')) {
        const parts = cleanStr.split('-');
        if (parts.length === 2) {
            const min = parseFloat(parts[0]);
            const max = parseFloat(parts[1]);
            if (!isNaN(min) && !isNaN(max)) {
                return (min + max) / 2; // Use average for ranges
            }
        }
    }
    
    // Handle fractions like "1/2"
    if (cleanStr.includes('/')) {
        const parts = cleanStr.split('/');
        if (parts.length === 2) {
            const numerator = parseFloat(parts[0]);
            const denominator = parseFloat(parts[1]);
            if (!isNaN(numerator) && !isNaN(denominator) && denominator !== 0) {
                return numerator / denominator;
            }
        }
    }
    
    // Handle decimal values
    const parsed = parseFloat(cleanStr);
    if (isNaN(parsed)) {
        console.warn(`⚠️ Could not parse quantity: "${quantityStr}", defaulting to 1`);
        return 1;
    }
    
    return parsed;
}


async function createMissingIngredient(
    ingredientName: string,
    categoryMap: Map<string, any>
): Promise<any> {
    const normalizedName = ingredientName.trim();
    const category = findIngredientCategory(normalizedName);
    const dietaryFlags = getIngredientDietaryFlags(normalizedName);
    
    // Get or create category
    let categoryEntity = categoryMap.get(category);
    if (!categoryEntity) {
        try {
            categoryEntity = await CategoryRepository.save({ name: category });
            categoryMap.set(category, categoryEntity);
        } catch (error: any) {
            // Category might already exist due to concurrent creation
            categoryEntity = await CategoryRepository.findOne({ where: { name: category } });
            if (categoryEntity) {
                categoryMap.set(category, categoryEntity);
            }
        }
    }
    
    // Create ingredient with inferred properties and dietary tags
    const ingredientData: IngredientSeedInput = {
        name: normalizedName,
        category: category,
        isVegan: dietaryFlags.isVegan ?? true,
        isVegetarian: dietaryFlags.isVegetarian ?? true,
        isGlutenFree: dietaryFlags.isGlutenFree ?? true,
        isLactoseFree: dietaryFlags.isLactoseFree ?? true,
    };
    
    return await handleEntitySave(
        () => IngredientRepository.save({
            name: ingredientData.name,
            category: categoryEntity,
            isVegan: ingredientData.isVegan,
            isVegetarian: ingredientData.isVegetarian,
            isGlutenFree: ingredientData.isGlutenFree,
            isLactoseFree: ingredientData.isLactoseFree,
        }),
        "Ingredient"
    );
}

export async function setAdminRoleService(uid: string) {
    const admin = await UserRepository.findOne({ where: { uid: uid } });
    if (!admin) {
        throw new NotFoundError("Admin not found");
    }
    admin.role = UserRole.ADMIN;
    await UserRepository.save(admin);
    return admin;
}

export async function seedResourcesService(resourceType: string, resources: Resource | Resource[]) {
    // Convert single resource to array for uniform handling
    const resourceArray = Array.isArray(resources) ? resources : [resources];
    console.log("resourceArray", resourceArray);
    if (resourceArray.length === 0) {
        throw new BadRequestError("At least one resource is required");
    }

    // Validate all resources before saving any
    for (const resource of resourceArray) {
        await validateResource(resource);
    }

    const results = [];

    for (const resource of resourceArray) {
        const name = resource.name.trim();
        const abbreviation = resource.abbreviation?.trim() || "";
        const type = resource.type?.trim() || "";

        if (resourceType === "categories") {
            results.push(await handleEntitySave(
                () => CategoryRepository.save({ name }),
                "Category"
            ));
        }
        else if (resourceType === "recipe_tags") {
            results.push(await handleEntitySave(
                () => RecipeTagRepository.save({ name }),
                "Recipe tag"
            ));
        }
        else if (resourceType === "units") {
            results.push(await handleEntitySave(
                () => UnitRepository.save({ name, abbreviation, type }),
                "Unit"
            ));
        }
        else {
            throw new NotFoundError("Resource type not found");
        }
    }

    return results;
}

export async function seedIngredientsService(ingredients: IngredientSeedInput | IngredientSeedInput[]) {
    // Convert single ingredient to array for uniform handling
    const ingredientArray = Array.isArray(ingredients) ? ingredients : [ingredients];

    if (ingredientArray.length === 0) {
        throw new BadRequestError("At least one ingredient is required");
    }

    // Validate all ingredients before processing
    for (const ingredient of ingredientArray) {
        await validateResource(ingredient);
    }

    // Pre-fetch all categories and tags to minimize database queries
    const uniqueCategories = new Set(ingredientArray.map(i => i.category));
    const categories = await CategoryRepository.find({
        where: Array.from(uniqueCategories).map(name => ({ name }))
    });
    const categoryMap = new Map(categories.map(c => [c.name, c]));



    const results = [];

    for (const ingredientInput of ingredientArray) {
        // Get category
        const category = categoryMap.get(ingredientInput.category);
        if (!category) {
            throw new NotFoundError(`Category '${ingredientInput.category}' not found`);
        }
        

        // Create ingredient
        const result = await handleEntitySave(
            () => IngredientRepository.save({
                name: ingredientInput.name,
                category: category,
                isVegan: ingredientInput.isVegan,
                isVegetarian: ingredientInput.isVegetarian || false,
                isGlutenFree: ingredientInput.isGlutenFree,
                isLactoseFree: ingredientInput.isLactoseFree,
            }),
            "Ingredient"
        );

        results.push(result);
    }

    return results;
}

export async function seedRecipesService(recipes: RecipeSeedInput | RecipeSeedInput[]) {
    const recipeArray = Array.isArray(recipes) ? recipes : [recipes];

    if (recipeArray.length === 0) {
        throw new BadRequestError("At least one recipe is required");
    }

    // Validate all recipes before processing
    await Promise.all(recipeArray.map(validateRecipe));

    console.log(`🍳 Processing ${recipeArray.length} recipe(s) for seeding...`);

    // Collect all unique values needed for processing
    const uniqueIngredientNames = new Set(
        recipeArray.flatMap(recipe => 
            recipe.ingredients.map(ing => ing.name.trim())
        )
    );
    const uniqueUnits = new Set(
        recipeArray.flatMap(recipe =>
            recipe.ingredients
                .map(ing => ing.unit?.toLowerCase().trim())
                .filter((unit): unit is string => unit !== undefined && unit !== '')
        )
    );
    const uniqueTagNames = new Set(
        recipeArray.flatMap(recipe => (recipe.tags || []).map(tag => tag.trim()))
    );

    console.log(`📊 Found ${uniqueIngredientNames.size} unique ingredients, ${uniqueUnits.size} units, ${uniqueTagNames.size} tags`);

    // Fetch all existing entities
    const [existingIngredients, existingUnits, existingTags, existingCategories] = await Promise.all([
        IngredientRepository.find({
            where: Array.from(uniqueIngredientNames).map(name => ({
                name: ILike(`%${name}%`)
            })),
            relations: ['category']
        }),
        UnitRepository.find(),
        RecipeTagRepository.find({
            where: Array.from(uniqueTagNames).map(tagName => ({
                name: ILike(`%${tagName}%`)
            }))
        }),
        CategoryRepository.find(),
    ]);

    // Create maps for quick lookup
    const ingredientMap = new Map(
        existingIngredients.map(i => [i.name.toLowerCase().trim(), i])
    );
    const unitMap = new Map(
        existingUnits.flatMap(u => [
            [u.name.toLowerCase().trim(), u],
            [u.abbreviation.toLowerCase().trim(), u]
        ])
    );
    const recipeTagMap = new Map(
        existingTags.map(t => [t.name.toLowerCase().trim(), t])
    );
    const categoryMap = new Map(
        existingCategories.map(c => [c.name, c])
    );

    // Create missing recipe tags first
    for (const tagName of uniqueTagNames) {
        const normalizedTagName = tagName.toLowerCase().trim();
        if (!recipeTagMap.has(normalizedTagName)) {
            console.log(`🏷️ Creating missing recipe tag: ${tagName}`);
            try {
                const newTag = await RecipeTagRepository.save({ name: tagName });
                recipeTagMap.set(normalizedTagName, newTag);
            } catch (error: any) {
                // Tag might already exist due to concurrent creation
                const existingTag = await RecipeTagRepository.findOne({ 
                    where: { name: ILike(`%${tagName}%`) } 
                });
                if (existingTag) {
                    recipeTagMap.set(normalizedTagName, existingTag);
                }
            }
        }
    }

    // Create missing ingredients
    const createdIngredients = [];
    for (const ingredientName of uniqueIngredientNames) {
        const normalizedName = ingredientName.toLowerCase().trim();
        if (!ingredientMap.has(normalizedName)) {
            console.log(`🥬 Creating missing ingredient: ${ingredientName}`);
            try {
                const newIngredient = await createMissingIngredient(ingredientName, categoryMap);
                ingredientMap.set(normalizedName, newIngredient);
                createdIngredients.push(ingredientName);
            } catch (error: any) {
                // Ingredient might already exist due to concurrent creation
                const existingIngredient = await IngredientRepository.findOne({ 
                    where: { name: ILike(`%${ingredientName}%`) },
                    relations: ['category']
                });
                if (existingIngredient) {
                    ingredientMap.set(normalizedName, existingIngredient);
                } else {
                    console.error(`❌ Failed to create ingredient '${ingredientName}':`, error.message);
                    throw new BadRequestError(`Failed to create ingredient '${ingredientName}': ${error.message}`);
                }
            }
        }
    }

    // Validate units exist (these should be pre-seeded)
    const missingUnits = Array.from(uniqueUnits).filter(unit => !unitMap.has(unit));
    if (missingUnits.length > 0) {
        console.warn(`⚠️ Missing units (these should be pre-seeded):`, missingUnits);
        // For now, we'll just log a warning and continue without the units
        // In a production system, you might want to create basic units or throw an error
    }

    console.log(`✅ Created ${createdIngredients.length} new ingredients: ${createdIngredients.join(', ')}`);

    const results = [];

    // Process recipes sequentially to avoid deadlocks
    for (const recipeInput of recipeArray) {
        try {
            console.log(`🍽️ Creating recipe: ${recipeInput.name}`);
            
            // Get recipe tags for this recipe
            const recipeTags = (recipeInput.tags || []).map(tagName => {
                const tag = recipeTagMap.get(tagName.toLowerCase().trim());
                if (!tag) {
                    console.warn(`⚠️ Recipe tag '${tagName}' not found, skipping`);
                    return null;
                }
                return tag;
            }).filter(tag => tag !== null);

            // Create the recipe first
            const recipe = await RecipeRepository.save({
                name: recipeInput.name,
                description: recipeInput.description,
                steps: recipeInput.steps,
                cookingTime: recipeInput.cookingTime,
                difficulty: recipeInput.difficulty,
                servings: recipeInput.servings,
                image: recipeInput.image,
                tags: recipeTags
            });

            // Create recipe ingredients
            await Promise.all(recipeInput.ingredients.map(async (ingInput) => {
                const ingredient = ingredientMap.get(ingInput.name.toLowerCase().trim());
                if (!ingredient) {
                    throw new Error(`Ingredient '${ingInput.name}' not found in map after creation. This should never happen.`);
                }

                let unit = undefined;
                if (ingInput.unit) {
                    unit = unitMap.get(ingInput.unit.toLowerCase().trim());
                    // If unit is not found, we'll continue without it (null)
                    if (!unit) {
                        console.warn(`⚠️ Unit '${ingInput.unit}' not found, recipe ingredient will have no unit`);
                    }
                }

                const quantity = parseQuantity(ingInput.quantity);

                return RecipeIngredientRepository.save({
                    recipe,
                    ingredient,
                    quantity,
                    unit
                });
            }));


            await RecipeRepository.save(recipe);

            // Fetch the complete recipe without circular references
            const savedRecipe = await RecipeRepository.findOne({
                where: { id: recipe.id },
                relations: ['ingredients', 'ingredients.ingredient', 'ingredients.unit'],
                select: {
                    id: true,
                    name: true,
                    description: true,
                    steps: true,
                    cookingTime: true,
                    difficulty: true,
                    servings: true,
                    image: true,
                    ingredients: {
                        id: true,
                        quantity: true,
                        ingredient: {
                            id: true,
                            name: true
                        },
                        unit: {
                            id: true,
                            name: true,
                            abbreviation: true
                        }
                    },
                }
            });

            if (!savedRecipe) {
                throw new Error('Failed to fetch saved recipe');
            }

            console.log(`✅ Successfully created recipe: ${recipeInput.name} with ${savedRecipe.ingredients.length} ingredients`);
            results.push(savedRecipe);
        } catch (error: any) {
            console.error(`❌ Error creating recipe '${recipeInput.name}':`, error.message);
            throw new BadRequestError(`Error creating recipe '${recipeInput.name}': ${error.message}`);
        }
    }

    console.log(`🎉 Successfully processed ${results.length} recipe(s)`);
    return results;
}