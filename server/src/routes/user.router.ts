import { Router, Request, Response, NextFunction } from "express";
import { createUserController, getUserByIdController, softDeleteUserController, updateUserController } from "../controllers/user.controller";
import { addUserIngredientController, deleteUserIngredientController, getUserIngredientsController, updateUserIngredientController } from "../controllers/user_ingredients.controller";

const userRouter = Router();

// routes

userRouter.post('/sign_up', async (req: Request, res: Response, next: NextFunction) => {
    // Handle user creation
    await createUserController(req, res, next);
});

userRouter.put('/:uid', async (req: Request, res: Response, next: NextFunction) => {
    // Handle user update
    await updateUserController(req, res, next);
});

userRouter.get('/:uid', async (req: Request, res: Response, next: NextFunction) => {
	await getUserByIdController(req, res, next);
});

userRouter.delete('/:uid', async (req: Request, res: Response, next: NextFunction) => {
    // Handle user soft deletion
    await softDeleteUserController(req, res, next);
});

//ingredients routes

userRouter.get('/:uid/ingredients', async (req: Request, res: Response, next: NextFunction) => {
    // get user ingredients (custom and global)
    await getUserIngredientsController(req, res, next);
});

userRouter.post('/:uid/ingredients', async (req: Request, res: Response, next: NextFunction) => {
    // add global or custom ingredient to user
    await addUserIngredientController(req, res, next);
});

userRouter.put('/:uid/ingredients', async (req: Request, res: Response, next: NextFunction) => {
    // update user ingredient (quantity, unit, id on body)
    await updateUserIngredientController(req, res, next);
});

userRouter.delete('/:uid/ingredients', async (req: Request, res: Response, next: NextFunction) => {
    // delete user ingredient (id on body)
    await deleteUserIngredientController(req, res, next);
});

export default userRouter;
