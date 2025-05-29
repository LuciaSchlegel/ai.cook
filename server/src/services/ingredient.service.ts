import { Ingredient } from "../entities/Ingredient";
import { CustomIngredient } from "../entities/Custom_Ingredient";
import { BadRequestError, ConflictError } from "../types/AppError";
import { IngredientRepository } from "../repositories/ingredient.repository";
import { CustomIngredientRepository } from "../repositories/custom_ingredient.repository";
import { MealDBIngredient } from "../types/ingredients.types";
import fs from 'fs';
import path from 'path';

// --- INGREDIENTES GLOBALES ---
// global ingredients - standard ingredients - here getting from an api and saving them in the db
// the load ingredients is called on client startup -> gets basic ingredients 
// calls parseAndSaveIngredients to parse the JSON to Objects and save them in the db

// Hauptfunktion
export async function loadIngredientsFromLocalFile() {
  const count = await IngredientRepository.count();
  if (count > 0) {
    console.log("🔁 Zutaten bereits in DB, Initialisierung übersprungen.");
    return;
  }
  const filePath = path.join(__dirname, '../../src/data/enriched_ingredients_from_meals.json');

  let raw;
  try {
    raw = fs.readFileSync(filePath, 'utf-8');
  } catch (err) {
    console.error('❌ Datei nicht gefunden oder lesbar:', err);
    return;
  }

  let ingredientsJson;
  try {
    ingredientsJson = JSON.parse(raw);
  } catch (err) {
    console.error('❌ JSON-Parsing fehlgeschlagen:', err);
    return;
  }

  const ingredients: Ingredient[] = ingredientsJson.map((item: any) => {
    const ingredient = new Ingredient();
    ingredient.name = item.strIngredient;
    ingredient.description = item.strDescription || null;
    ingredient.category = item.strType || null;
    ingredient.image = `https://www.themealdb.com/images/ingredients/${encodeURIComponent(item.strIngredient)}.png`;
    ingredient.isVegan = item.isVegan ?? false;
    ingredient.isVegetarian = item.isVegetarian ?? false;
    ingredient.isGlutenFree = item.isGlutenFree ?? false;
    ingredient.isLactoseFree = item.isLactoseFree ?? false;
    return ingredient;
  });

  try {
    await IngredientRepository.save(ingredients);
    console.log(`✅ ${ingredients.length} Zutaten wurden erfolgreich gespeichert.`);
  } catch (err) {
    console.error('❌ Fehler beim Speichern in die DB:', err);
  }
}


export async function listGlobalIngredientsService() {
  return await IngredientRepository.find();
}

export async function createGlobalIngredientService(data: Partial<Ingredient>) {
  if (!data.name) throw new BadRequestError('Name is required.');
  const exists = await IngredientRepository.findOneBy({ name: data.name });
  if (exists) throw new ConflictError('Ingredient already exists.');
  const ingredient = IngredientRepository.create(data);
  return await IngredientRepository.save(ingredient);
}

export async function suggestGlobalIngredientsService(search: string) {
  return await IngredientRepository.createQueryBuilder('ingredient')
    .where('LOWER(ingredient.name) LIKE :search', { search: `%${search.toLowerCase()}%` })
    .getMany();
}

// --- INGREDIENTES CUSTOM DEL USUARIO ---

export async function listCustomIngredientsService(userId?: number) {
  if (userId) {
    return await CustomIngredientRepository.find({ where: { createdBy: { id: userId } }, relations: ['createdBy'] });
  }
  // Si es admin o global, listar todos
  return await CustomIngredientRepository.find({ relations: ['createdBy'] });
}

export async function createCustomIngredientService(data: Partial<CustomIngredient>) {
  if (!data.name || !data.createdBy) throw new BadRequestError('Name and createdBy (user) required.');
  // Evitar duplicados en el mismo user (opcional: check global también)
  const exists = await CustomIngredientRepository.findOne({
    where: { name: data.name, createdBy: { id: (data.createdBy as any).id } },
    relations: ['createdBy']
  });
  if (exists) throw new ConflictError('Custom ingredient already exists for this user.');
  const customIngredient = CustomIngredientRepository.create(data);
  return await CustomIngredientRepository.save(customIngredient);
}

export async function suggestCustomIngredientsService(search: string, userId?: number) {
  const qb = CustomIngredientRepository.createQueryBuilder('ingredient')
    .where('LOWER(ingredient.name) LIKE :search', { search: `%${search.toLowerCase()}%` })
    .andWhere('ingredient.isApproved = :isApproved', { isApproved: true });
  if (userId) qb.andWhere('ingredient.createdById = :userId', { userId });
  return await qb.getMany();
}