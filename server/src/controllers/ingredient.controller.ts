import { Request } from "express";
import {
  listGlobalIngredientsService,
  createGlobalIngredientService,
  suggestGlobalIngredientsService,
  listCustomIngredientsService,
  createCustomIngredientService,
  suggestCustomIngredientsService,
} from "../services/ingredient.service";
import { controllerWrapper } from "../helpers/controllerWrapper";
import { CustomIngredientDto } from "../dtos/custom_ing.dto";

// Global Ingredients
export const listGlobalIngredientsController = controllerWrapper(
  async () => listGlobalIngredientsService(),
  {}
);

export const createGlobalIngredientController = controllerWrapper(
  async (req: Request) => createGlobalIngredientService(req.body),
  { statusCode: 201 }
);

export const suggestGlobalIngredientsController = controllerWrapper(
  async (req: Request) => {
    const search = (req.query.search as string) || "";
    return suggestGlobalIngredientsService(search);
  },
  {}
);

// Custom Ingredients
export const listCustomIngredientsController = controllerWrapper(
  async (req: Request) => {
    const userId = req.query.userId ? Number(req.query.userId) : undefined;
    return listCustomIngredientsService(userId);
  },
  {}
);

export const createCustomIngredientController = controllerWrapper(
  async (req: Request) => {
    const { uid, ...customIng } = req.body;
    return createCustomIngredientService(customIng, uid);
  },
  { dto: CustomIngredientDto, statusCode: 201 }
);

export const suggestCustomIngredientsController = controllerWrapper(
  async (req: Request) => {
    const search = (req.query.search as string) || "";
    const userId = req.query.userId ? Number(req.query.userId) : undefined;
    return suggestCustomIngredientsService(search, userId);
  },
  {}
);

export const getIngredientByIdController = controllerWrapper(async () => {
  throw new Error("Not implemented yet");
}, {});
