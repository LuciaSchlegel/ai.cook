import { NextFunction, Request, Response } from "express";
import { BadRequestError } from "../types/AppError";
import { addUserIngredientService, getUserIngredientsService, removeUserIngredientService, updateUserIngredientService } from "../services/user_ingredients.service";
import { UserIngredientDto } from "../dtos/user_ing.dto";
import { serialize } from "../helpers/serialize";
import { toSnakeCaseDeep } from "../helpers/toSnakeCase";
import { toCamelCaseDeep } from "../helpers/toCamelCase";

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
      console.log('Request body:', JSON.stringify(req.body, null, 2));
      const { uid } = req.params;
      const camelBody = toCamelCaseDeep(req.body);
      const { ingredient, customIngredient, quantity, unit } = camelBody;
  
      console.log('Destructured values:', {
        ingredient,
        customIngredient,
        quantity,
        unit
      });
  
      if (!uid) return next(new BadRequestError("User ID is required"));
      if (!ingredient?.id && !customIngredient?.id) {
        console.log('Missing ingredient IDs:', { ingredientId: ingredient?.id, customIngredientId: customIngredient?.id });
        return next(new BadRequestError("Either ingredient ID or custom ingredient ID is required"));
      }
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
        const { quantity, unit, id, custom_ingredient } = req.body;
        if (!id) {
            return next(new BadRequestError("User ingredient ID is required"));
        }

        const updateData: any = {};
        if (quantity) updateData.quantity = quantity;
        if (unit) updateData.unit = unit;
        if (custom_ingredient) updateData.customIngredient = toCamelCaseDeep(custom_ingredient);

        if (Object.keys(updateData).length === 0) {
            return next(new BadRequestError("No update data provided"));
        }

        const userIngredient = await updateUserIngredientService(uid, id, updateData);
        
        const serialized = serialize(UserIngredientDto, userIngredient);
        const response = toSnakeCaseDeep(serialized);
        
        return res.status(200).json(response);
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