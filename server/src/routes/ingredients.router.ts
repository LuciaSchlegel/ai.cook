import { Router } from "express";
import {
    listGlobalIngredientsController,
    createGlobalIngredientController,
    suggestGlobalIngredientsController,
    listCustomIngredientsController,
    createCustomIngredientController,
    suggestCustomIngredientsController,
    getIngredientByIdController,
} from "../controllers/ingredient.controller";

const ingredientsRouter = Router();

ingredientsRouter.get("/global", listGlobalIngredientsController);
ingredientsRouter.post("/global", createGlobalIngredientController);

ingredientsRouter.get("/custom", listCustomIngredientsController);
ingredientsRouter.post("/custom", createCustomIngredientController);

ingredientsRouter.get("/suggest", async (req, res, next) => {
    // search term: /ingredients/suggest?search=tomate
    await suggestGlobalIngredientsController(req, res, next);
    // Podés combinar sugerencia global+custom aquí si querés, según tu estrategia
});

ingredientsRouter.get("/:id", getIngredientByIdController);

export default ingredientsRouter;