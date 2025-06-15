import { NextFunction, Request, Response } from "express";
import { BadRequestError } from "../types/AppError";
import { addUserIngredientService, getUserIngredientsService, removeUserIngredientService, updateUserIngredientService } from "../services/user_ingredients.service";
import { UserIngredientDto } from "../dtos/user_ing.dto";
import { serialize } from "../helpers/serialize";
import { toSnakeCaseDeep } from "../helpers/toSnakeCase";

export async function getUserIngredientsController(req: Request, res: Response, next: NextFunction) {
  const { uid } = req.params;
  if (!uid) {
    return next(new BadRequestError("User ID is required"));
  }
  try {
    const ingredients = await getUserIngredientsService(uid);
    const serialized = serialize(UserIngredientDto, ingredients);
    const response = toSnakeCaseDeep(serialized);
    return res.status(200).json(response);
  } catch (error) {
    next(error);
  }
}
export async function addUserIngredientController(req: Request, res: Response, next: NextFunction) {
    try {
      const { uid } = req.params;
      const { ingredient, customIngredient, quantity, unit } = req.body;
  
      if (!uid) return next(new BadRequestError("User ID is required"));
      if (!ingredient?.id && !customIngredient?.id)
        return next(new BadRequestError("Either ingredient ID or custom ingredient ID is required"));
      if (!quantity) return next(new BadRequestError("Quantity is required"));
      if (!unit?.id) return next(new BadRequestError("Unit ID is required"));
  
      const newUserIngredient = await addUserIngredientService({
        uid,
        ingredientId: ingredient?.id,
        customIngredientId: customIngredient?.id,
        quantity,
        unit: unit.id,  
      });
  
      const serialized = serialize(UserIngredientDto, newUserIngredient);
      const response = toSnakeCaseDeep(serialized);
  
      return res.status(201).json(response);
    } catch (error) {
      next(error);
    }
  }

export async function updateUserIngredientController(req: Request, res: Response, next: NextFunction) {
    try {
        const { uid } = req.params;
        const { quantity, unit, id } = req.body;
        if (!id) {
            return next(new BadRequestError("User ingredient ID is required"));
        }
        if (!quantity) {
            return next(new BadRequestError("Quantity is required"));
        }
        const userIngredient = await updateUserIngredientService(uid, id, {
            quantity,
            unit
        });
        return res.status(200).json(userIngredient);
    } catch (error) {
        next(error);
    }
}

export async function deleteUserIngredientController(req: Request, res: Response, next: NextFunction) {
    try {
        const { uid } = req.params;
        const { id } = req.body;
        if (!uid) {
            return next(new BadRequestError("User ID is required"));
        }
        if (!id) {
            return next(new BadRequestError("User ingredient ID is required"));
        }
        const userIngredient = await removeUserIngredientService(uid, id);
        return res.status(200).json(userIngredient);
    } catch (error) {
        next(error);
    }
}