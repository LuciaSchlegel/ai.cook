import { Ingredient } from "../entities/Ingredient";
import { CustomIngredient } from "../entities/Custom_Ingredient";
import { BadRequestError, ConflictError } from "../types/AppError";
import { IngredientRepository } from "../repositories/ingredient.repository";
import { CustomIngredientRepository } from "../repositories/custom_ingredient.repository";

// --- INGREDIENTES GLOBALES ---

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