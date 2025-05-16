import { NextFunction, Request, Response } from "express";
import { BadRequestError } from "../types/AppError";
import { addUserIngredientService, getUserIngredientsService, removeUserIngredientService, updateUserIngredientService } from "../services/user_ingredients.service";

export async function getUserIngredientsController(req: Request, res: Response, next: NextFunction) {
  const { uid } = req.params;
  if (!uid) {
    return next(new BadRequestError("User ID is required"));
  }
  try {
    const ingredients = await getUserIngredientsService(uid);
    return res.status(200).json(ingredients);
  } catch (error) {
    next(error);
  }
}

export async function addUserIngredientController(req: Request, res: Response, next: NextFunction) {
    try {
        const { uid } = req.params;
        const { ingredientId, customIngredientId, quantity, unit } = req.body;
        if (!ingredientId && !customIngredientId) {
            return next(new BadRequestError("Ingredient ID and custom ingredient ID are required"));
        }
        if (!uid) {
            return next(new BadRequestError("User ID is required"));
        }
        if (!quantity) {
            return next(new BadRequestError("Quantity is required"));
        }
        const userIngredient = await addUserIngredientService({
            uid, 
            ingredientId, 
            customIngredientId, 
            quantity, 
            unit
        });
        return res.status(201).json(userIngredient);
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