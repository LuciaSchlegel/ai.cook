import { UserRole } from "../entities/User";
import { CategoryRepository } from "../repositories/category.repository";
import { IngredientRepository } from "../repositories/ingredient.repository";
import { RecipeTagRepository } from "../repositories/recipe_tag.repository";
import { TagRepository } from "../repositories/tag.repository";
import { UserRepository } from "../repositories/user.repository";
import { BadRequestError, NotFoundError } from "../types/AppError";
import { QueryFailedError } from "typeorm";
import { RecipeRepository } from "../repositories/recipe.repository";
import { RecipeIngredientRepository } from "../repositories/recipe_ingredient.repository";
import { UnitRepository } from "../repositories/unit.repository";
import { ILike } from "typeorm";

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
    tags: string[];
    isVegan?: boolean;
    isVegetarian?: boolean;
    isGlutenFree?: boolean;
    isLactoseFree?: boolean;
}

export interface RecipeIngredientInput {
    name: string;
    quantity: number;
    unit?: string;
}

export interface RecipeSeedInput {
    name: string;
    description: string;
    steps?: string[];
    cookingTime?: string;
    difficulty?: string;
    servings?: string;
    image?: string;
    ingredients: RecipeIngredientInput[];
    tags: string[];
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
        else if (resourceType === "tags") {
            results.push(await handleEntitySave(
                () => TagRepository.save({ name }),
                "Tag"
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

    // Collect all unique tag names
    const uniqueTags = new Set(ingredientArray.flatMap(i => i.tags));
    const existingTags = await TagRepository.find({
        where: Array.from(uniqueTags).map(name => ({ name }))
    });
    const tagMap = new Map(existingTags.map(t => [t.name, t]));

    // Create missing tags
    for (const tagName of uniqueTags) {
        if (!tagMap.has(tagName)) {
            const newTag = await TagRepository.save({ name: tagName });
            tagMap.set(tagName, newTag);
        }
    }

    const results = [];

    for (const ingredientInput of ingredientArray) {
        // Get category
        const category = categoryMap.get(ingredientInput.category);
        if (!category) {
            throw new NotFoundError(`Category '${ingredientInput.category}' not found`);
        }

        // Get tags
        const ingredientTags = ingredientInput.tags.map(tagName => {
            const tag = tagMap.get(tagName);
            if (!tag) {
                throw new Error(`Tag '${tagName}' not found in map. This should never happen.`);
            }
            return tag;
        });

        // Create ingredient
        const result = await handleEntitySave(
            () => IngredientRepository.save({
                name: ingredientInput.name,
                category: category,
                tags: ingredientTags,
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

    // Collect all unique values needed for validation
    const uniqueIngredientNames = new Set(
        recipeArray.flatMap(recipe => recipe.ingredients.map(ing => ing.name.toLowerCase()))
    );
    const uniqueUnits = new Set(
        recipeArray.flatMap(recipe => 
            recipe.ingredients
                .map(ing => ing.unit?.toLowerCase())
                .filter((unit): unit is string => unit !== undefined)
        )
    );
    const uniqueTagNames = new Set(
        recipeArray.flatMap(recipe => recipe.tags.map(tag => tag.toLowerCase()))
    );

    // Fetch all existing entities for validation
    const [existingIngredients, existingUnits, existingTags] = await Promise.all([
        IngredientRepository.find({
            where: Array.from(uniqueIngredientNames).map(name => ({ 
                name: ILike(`%${name}%`) 
            }))
        }),
        UnitRepository.find(),
        RecipeTagRepository.find({
            where: Array.from(uniqueTagNames).map(tagName => ({
                name: ILike(`%${tagName}%`)
            }))
        })
    ]);

    // Create maps for quick lookup
    const ingredientMap = new Map(
        existingIngredients.map(i => [i.name.toLowerCase(), i])
    );
    const unitMap = new Map(
        existingUnits.flatMap(u => [
            [u.name.toLowerCase(), u],
            [u.abbreviation.toLowerCase(), u]
        ])
    );
    const tagMap = new Map(
        existingTags.map(t => [t.name.toLowerCase(), t])
    );

    // Validate all required entities exist
    const missingIngredients = Array.from(uniqueIngredientNames)
        .filter(name => !existingIngredients.some(i => i.name.toLowerCase() === name))
        .map(name => name.charAt(0).toUpperCase() + name.slice(1));
    
    const missingUnits = Array.from(uniqueUnits)
        .filter(unit => !unitMap.has(unit))
        .map(unit => unit.charAt(0).toUpperCase() + unit.slice(1));
    
    const missingTags = Array.from(uniqueTagNames)
        .filter(tag => !existingTags.some(t => t.name.toLowerCase() === tag))
        .map(tag => tag.charAt(0).toUpperCase() + tag.slice(1));

    // If any required entities are missing, throw an error with details
    const missingEntities = [];
    if (missingIngredients.length > 0) {
        missingEntities.push(`Ingredients: ${missingIngredients.join(', ')}`);
    }
    if (missingUnits.length > 0) {
        missingEntities.push(`Units: ${missingUnits.join(', ')}`);
    }
    if (missingTags.length > 0) {
        missingEntities.push(`Tags: ${missingTags.join(', ')}`);
    }
    
    if (missingEntities.length > 0) {
        throw new NotFoundError(
            `The following entities must be created first:\n${missingEntities.join('\n')}`
        );
    }

    const results = [];

    // Process recipes sequentially to avoid deadlocks
    for (const recipeInput of recipeArray) {
        try {
            // Create the recipe first
            const recipe = await RecipeRepository.save({
                name: recipeInput.name,
                description: recipeInput.description,
                steps: recipeInput.steps,
                cookingTime: recipeInput.cookingTime,
                difficulty: recipeInput.difficulty,
                servings: recipeInput.servings,
                image: recipeInput.image
            });

            // Create recipe ingredients
            await Promise.all(recipeInput.ingredients.map(ingInput => {
                const ingredient = ingredientMap.get(ingInput.name.toLowerCase());
                if (!ingredient) {
                    throw new Error(`Ingredient '${ingInput.name}' not found in map. This should never happen.`);
                }
                
                let unit = undefined;
                if (ingInput.unit) {
                    unit = unitMap.get(ingInput.unit.toLowerCase());
                    if (!unit) {
                        throw new Error(`Unit '${ingInput.unit}' not found in map. This should never happen.`);
                    }
                }

                return RecipeIngredientRepository.save({
                    recipe,
                    ingredient,
                    quantity: ingInput.quantity,
                    unit
                });
            }));

            // Add tags
            const recipeTags = recipeInput.tags.map(tag => {
                const foundTag = tagMap.get(tag.toLowerCase());
                if (!foundTag) {
                    throw new Error(`Tag '${tag}' not found in map. This should never happen.`);
                }
                return foundTag;
            });

            recipe.tags = recipeTags;
            await RecipeRepository.save(recipe);

            // Fetch the complete recipe without circular references
            const savedRecipe = await RecipeRepository.findOne({
                where: { id: recipe.id },
                relations: ['ingredients', 'ingredients.ingredient', 'ingredients.unit', 'tags'],
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
                    tags: {
                        id: true,
                        name: true
                    }
                }
            });

            if (!savedRecipe) {
                throw new Error('Failed to fetch saved recipe');
            }

            results.push(savedRecipe);
        } catch (error: any) {
            throw new BadRequestError(`Error creating recipe '${recipeInput.name}': ${error.message}`);
        }
    }

    return results;
}