import { UserIngredient } from "../entities/UserIngredient";
import { UserRepository } from "../repositories/user.repository";
import { IngredientRepository } from "../repositories/ingredient.repository";
import { CustomIngredientRepository } from "../repositories/custom_ingredient.repository";
import { UserIngredientRepository } from "../repositories/user_ingredient.repository";
import { BadRequestError, ConflictError, NotFoundError } from "../types/AppError";

// AGREGAR INGREDIENTE A LA LISTA DEL USUARIO
export async function addUserIngredientService({ 
    uid, ingredientId, customIngredientId, quantity, unit }: {
    uid: string;
    ingredientId?: number;
    customIngredientId?: number;
    quantity?: number;
    unit?: string;
}) {
  const user = await UserRepository.findOneBy({ uid });
  if (!user) throw new NotFoundError("User not found.");

  let ingredient = undefined;
  let customIngredient = undefined;

  if (ingredientId) {
    ingredient = await IngredientRepository.findOneBy({ id: ingredientId });
    if (!ingredient) throw new NotFoundError("Global ingredient not found.");
  }
  if (customIngredientId) {
    customIngredient = await CustomIngredientRepository.findOneBy({ id: customIngredientId });
    if (!customIngredient) throw new NotFoundError("Custom ingredient not found.");
  }

  if (!ingredient && !customIngredient) {
    throw new BadRequestError("You must provide either a global or custom ingredient.");
  }

  // Evitar duplicados
  const exists = await UserIngredientRepository.findOne({
    where: {
      user: { id: user.id },
      ingredient: ingredient ? { id: ingredient.id } : undefined,
      customIngredient: customIngredient ? { id: customIngredient.id } : undefined
    },
    relations: ['ingredient', 'customIngredient']
  });
  if (exists) throw new ConflictError("This ingredient is already in user's list.");

  const userIngredient = UserIngredientRepository.create({
    user,
    ingredient,
    customIngredient,
    quantity: quantity || 1,
    unit
  });

  return await UserIngredientRepository.save(userIngredient);
}

// LISTAR INGREDIENTES DE LA ALACENA DEL USUARIO
export async function getUserIngredientsService(uid: string) {
  return await UserIngredientRepository.find({
    where: { user: { uid } },
    relations: ['ingredient', 'customIngredient']
  });
}

// ACTUALIZAR INGREDIENTE DEL USUARIO (opcional)
export async function updateUserIngredientService(uid: string, id: number, data: Partial<UserIngredient>) {
  const userIngredient = await UserIngredientRepository.findOne({
    where: { id, user: { uid } },
    relations: ['ingredient', 'customIngredient']
});
  if (!userIngredient) throw new NotFoundError("UserIngredient not found.");
  Object.assign(userIngredient, data);
  return await UserIngredientRepository.save(userIngredient);
}

// BORRAR INGREDIENTE DEL USUARIO (opcional)
export async function removeUserIngredientService(uid: string, id: number) {
  const userIngredient = await UserIngredientRepository.findOne({
    where: { id, user: { uid } },
    relations: ['ingredient', 'customIngredient']
  });
    if (!userIngredient) throw new NotFoundError("UserIngredient not found.");
    // Si el ingrediente es global, no se puede borrar
      await UserIngredientRepository.remove(userIngredient);
      return { success: true };
}