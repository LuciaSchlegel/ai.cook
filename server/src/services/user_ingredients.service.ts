import { UserIngredient } from "../entities/UserIngredient";
import { Unit } from "../entities/Unit";
import { UserRepository } from "../repositories/user.repository";
import { IngredientRepository } from "../repositories/ingredient.repository";
import { CustomIngredientRepository } from "../repositories/custom_ingredient.repository";
import { UserIngredientRepository } from "../repositories/user_ingredient.repository";
import { BadRequestError, ConflictError, NotFoundError } from "../types/AppError";
import { UnitRepository } from "../repositories/unit.repository";

// AGREGAR INGREDIENTE A LA LISTA DEL USUARIO
export async function addUserIngredientService({ 
    uid, ingredientId, customIngredientId, quantity, unit }: {
    uid: string;
    ingredientId?: number;
    customIngredientId?: number;
    quantity?: number;
    unit?: number;
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
  if (exists) throw new ConflictError(`${exists} is already in user's list.`)

  const unitEntity = unit
    ? await UnitRepository.findOne({
        where: { id: unit },
      })
    : undefined;

  if (unit && !unitEntity) {
    throw new NotFoundError(`Unit '${unit}' not found.`);
  }
  const userIngredient = UserIngredientRepository.create({
    user,
    ingredient,
    customIngredient,
    quantity: quantity || 1,
    unit: unitEntity as Unit
  });

  return await UserIngredientRepository.save(userIngredient);
}

// LISTAR INGREDIENTES DE LA ALACENA DEL USUARIO
export async function getUserIngredientsService(uid: string) {
  return await UserIngredientRepository.find({
    where: { user: { uid } },
    relations: {
      user: true,
      ingredient: {
        category: true,
      },
      customIngredient: {
        category: true,
      },
      unit: true
    }
  });
}

// ACTUALIZAR INGREDIENTE DEL USUARIO (opcional)
export async function updateUserIngredientService(
  uid: string,
  id: number,
  data: Partial<UserIngredient> & { customIngredient?: Partial<any> }
) {
  const userIngredient = await UserIngredientRepository.findOne({
    where: { id, user: { uid } },
    relations: ['ingredient', 'customIngredient', 'unit'],
  });

  if (!userIngredient) {
    throw new NotFoundError("UserIngredient not found.");
  }

  // Si vienen datos para un customIngredient, actualizarlo primero
  if (data.customIngredient && userIngredient.customIngredient) {
    const customIngredient = await CustomIngredientRepository.findOneBy({ id: userIngredient.customIngredient.id });
    if (!customIngredient) {
      throw new NotFoundError("Associated CustomIngredient not found.");
    }

    // Actualizar campos del CustomIngredient
    Object.assign(customIngredient, data.customIngredient);
    await CustomIngredientRepository.save(customIngredient);
    
    // Quitar del objeto `data` para que no lo procese Object.assign en UserIngredient
    delete data.customIngredient;
  }
  
  // Actualizar Unit si se provee
  if (data.unit) {
    const unitEntity = await UnitRepository.findOneBy({ id: data.unit.id });
    if (!unitEntity) throw new NotFoundError(`Unit '${data.unit.id}' not found.`);
    userIngredient.unit = unitEntity;
    delete data.unit; // Quitar para el Object.assign
  }

  // Actualizar los campos restantes de UserIngredient (ej. quantity)
  Object.assign(userIngredient, data);
  
  const savedUserIngredient = await UserIngredientRepository.save(userIngredient);

  // Volver a cargar la entidad para devolverla con todas las relaciones actualizadas
  return await UserIngredientRepository.findOne({
    where: { id: savedUserIngredient.id },
    relations: {
      user: true,
      ingredient: {
        category: true,
      },
      customIngredient: {
        category: true,
      },
      unit: true
    }
  });
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