import { Request, Response, NextFunction } from "express";
import {
    listGlobalIngredientsService,
    createGlobalIngredientService,
    suggestGlobalIngredientsService,
    listCustomIngredientsService,
    createCustomIngredientService,
    suggestCustomIngredientsService,
    loadIngredientsFromLocalFile,
} from "../services/ingredient.service";

import { IngredientEnrichmentService } from "../services/enrich_ingredients_service";
import { BadRequestError } from "../types/AppError";

export async function enrichIngredientsController(req: Request, res: Response, next: NextFunction) {
    try {
        // Aquí podrías implementar la lógica para enriquecer ingredientes
        // Por ejemplo, llamar a un servicio externo o procesar datos
        IngredientEnrichmentService.enrichMissingIngredientInfo();

        res.status(200).json({ message: "Ingredients enriched successfully." });
    } catch (error) {
        next(error);
    }
}

export async function initializeIngredientsController(req: Request, res: Response, next: NextFunction) {
    try {
        const response = await loadIngredientsFromLocalFile();
        res.status(200).json({
            message: "Global ingredients initialized successfully.",
        });
    }
    catch (error) {
        if (error instanceof BadRequestError) {
            res.status(400).json({ error: error.message });
        } else {
            next(error);
        }
    }
}

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
        const ingredient = await createCustomIngredientService(req.body);
        res.status(201).json(ingredient);
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