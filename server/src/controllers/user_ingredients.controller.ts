import { Request } from "express";
import { BadRequestError } from "../types/AppError";
import {
  addUserIngredientService,
  getUserIngredientsService,
  removeUserIngredientService,
  updateUserIngredientService,
} from "../services/user_ingredients.service";
import { UserIngredientOptimizedDto } from "../dtos/user_ing_optimized.dto";
import { controllerWrapper } from "../helpers/controllerWrapper";
import { toCamelCaseDeep } from "../helpers/toCamelCase";

export const getUserIngredientsController = controllerWrapper(
  async (req: Request) => {
    const { uid } = req.params;
    if (!uid) throw new BadRequestError("User ID is required");
    return getUserIngredientsService(uid);
  },
  { dto: UserIngredientOptimizedDto, toSnakeCase: true }
);

export const addUserIngredientController = controllerWrapper(
  async (req: Request) => {
    const { uid } = req.params;
    const camelBody = toCamelCaseDeep(req.body);
    const { ingredient, customIngredient, quantity, unit } = camelBody;

    if (!uid) throw new BadRequestError("User ID is required");
    if (!ingredient?.id && !customIngredient?.id) {
      throw new BadRequestError(
        "Either ingredient ID or custom ingredient ID is required"
      );
    }
    if (!quantity) throw new BadRequestError("Quantity is required");
    if (!unit?.id) throw new BadRequestError("Unit ID is required");

    return addUserIngredientService({
      uid,
      ingredientId: ingredient?.id,
      customIngredientId: customIngredient?.id,
      quantity,
      unit: unit.id,
    });
  },
  { dto: UserIngredientOptimizedDto, statusCode: 201, toSnakeCase: true }
);

export const updateUserIngredientController = controllerWrapper(
  async (req: Request) => {
    const { uid } = req.params;
    const { quantity, unit, id, custom_ingredient } = req.body;

    if (!id) throw new BadRequestError("User ingredient ID is required");

    const updateData: any = {};
    if (quantity) updateData.quantity = quantity;
    if (unit) updateData.unit = unit;
    if (custom_ingredient)
      updateData.customIngredient = toCamelCaseDeep(custom_ingredient);

    if (Object.keys(updateData).length === 0) {
      throw new BadRequestError("No update data provided");
    }

    return updateUserIngredientService(uid, id, updateData);
  },
  { dto: UserIngredientOptimizedDto, toSnakeCase: true }
);

export const deleteUserIngredientController = controllerWrapper(
  async (req: Request) => {
    const { uid } = req.params;
    const { id } = req.body;

    if (!uid) throw new BadRequestError("User ID is required");
    if (!id) throw new BadRequestError("User ingredient ID is required");

    return removeUserIngredientService(uid, id);
  },
  { toSnakeCase: false } // gibt { success: true } zurück, kein DTO nötig
);
