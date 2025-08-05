import { Ingredient } from "../entities/Ingredient";
import { CustomIngredient } from "../entities/Custom_Ingredient";
import { BadRequestError, ConflictError } from "../types/AppError";
import { IngredientRepository } from "../repositories/ingredient.repository";
import { CustomIngredientRepository } from "../repositories/custom_ingredient.repository";
import { UserRepository } from "../repositories/user.repository";
import { CustomIngredientDto } from "../dtos/custom_ing.dto";


export async function listGlobalIngredientsService() {
  return await IngredientRepository.find({ relations: ['category'] });
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

export const createCustomIngredientService = async (
  customIngredientData: CustomIngredientDto,
  uid: string
): Promise<CustomIngredient> => {
  try {
    // Validate required fields
    if (!customIngredientData.name) {
      throw new BadRequestError('Name is required');
    }

    // Find the user
    const user = await UserRepository.findOne({
      where: { uid }
    });

    if (!user) {
      throw new BadRequestError('User not found');
    }

    console.log('Creating custom ingredient with data:', customIngredientData);

    // Auto-derive dietary flags from tags if tags are provided in the future
    // For now, use the boolean flags directly from the DTO
    const isVegan = customIngredientData.isVegan || false;
    const isVegetarian = customIngredientData.isVegetarian || false;
    const isGlutenFree = customIngredientData.isGlutenFree || false;
    const isLactoseFree = customIngredientData.isLactoseFree || false;

    // Create the custom ingredient with the user reference
    const customIngredient = CustomIngredientRepository.create({
      name: customIngredientData.name,
      category: customIngredientData.category,
      isVegan,
      isVegetarian,
      isGlutenFree,
      isLactoseFree,
      createdBy: user
    });

    console.log('Created custom ingredient object:', customIngredient);

    // Save the custom ingredient
    const savedCustomIngredient = await CustomIngredientRepository.save(customIngredient);

    console.log('Saved custom ingredient:', savedCustomIngredient);

    // Reload the custom ingredient with all relations
    const reloadedCustomIngredient = await CustomIngredientRepository.findOne({
      where: { id: savedCustomIngredient.id },
      relations: ['category', 'createdBy']
    });

    if (!reloadedCustomIngredient) {
      throw new Error('Failed to reload custom ingredient after save');
    }

    console.log('Reloaded custom ingredient:', reloadedCustomIngredient);

    return reloadedCustomIngredient;
  } catch (error) {
    console.error('Error in createCustomIngredientService:', error);
    throw error;
  }
};

export async function suggestCustomIngredientsService(search: string, userId?: number) {
  const qb = CustomIngredientRepository.createQueryBuilder('ingredient')
    .where('LOWER(ingredient.name) LIKE :search', { search: `%${search.toLowerCase()}%` })
  if (userId) qb.andWhere('ingredient.createdById = :userId', { userId });
  return await qb.getMany();
}