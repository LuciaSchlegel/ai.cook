import { Request, Response, NextFunction } from "express";
import {
    listGlobalIngredientsService,
    createGlobalIngredientService,
    suggestGlobalIngredientsService,
    listCustomIngredientsService,
    createCustomIngredientService,
    suggestCustomIngredientsService,
} from "../services/ingredient.service";
import { serialize } from "../helpers/serialize";
import { CustomIngredientDto } from "../dtos/custom_ing.dto";

export async function listGlobalIngredientsController(req: Request, res: Response, next: NextFunction) {
    try {
        const ingredients = await listGlobalIngredientsService();
        res.status(200).json(ingredients);
    } catch (error) {
        next(error);
    }
}

export async function createGlobalIngredientController(req: Request, res: Response, next: NextFunction) {
    try {
        const ingredient = await createGlobalIngredientService(req.body);
        res.status(201).json(ingredient);
    } catch (error) {
        next(error);
    }
}

export async function suggestGlobalIngredientsController(req: Request, res: Response, next: NextFunction) {
    try {
        const search = (req.query.search as string) || "";
        const ingredients = await suggestGlobalIngredientsService(search);
        res.status(200).json(ingredients);
    } catch (error) {
        next(error);
    }
}

export async function listCustomIngredientsController(req: Request, res: Response, next: NextFunction) {
    try {
        const userId = req.query.userId ? Number(req.query.userId) : undefined;
        const ingredients = await listCustomIngredientsService(userId);
        res.status(200).json(ingredients);
    } catch (error) {
        next(error);
    }
}

export async function createCustomIngredientController(req: Request, res: Response, next: NextFunction) {
    try {
        console.log('Creating custom ingredient with body:', req.body);
        const customIng : CustomIngredientDto = req.body;
        const { uid } = req.body;
        const ingredient = await createCustomIngredientService(customIng, uid);
        console.log('Created custom ingredient:', ingredient);
        const serialized = serialize(CustomIngredientDto, ingredient);
        res.status(201).json(serialized);
    } catch (error) {
        next(error);
    }
}

export async function suggestCustomIngredientsController(req: Request, res: Response, next: NextFunction) {
    try {
        const search = (req.query.search as string) || "";
        const userId = req.query.userId ? Number(req.query.userId) : undefined;
        const ingredients = await suggestCustomIngredientsService(search, userId);
        res.status(200).json(ingredients);
    } catch (error) {
        next(error);
    }
}

export async function getIngredientByIdController(req: Request, res: Response, next: NextFunction) {
    // Puedes implementarlo si lo necesitas, similar a global o custom
    res.send("Not implemented yet");
}