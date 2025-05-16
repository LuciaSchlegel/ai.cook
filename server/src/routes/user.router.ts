import { Router, Request, Response, NextFunction } from "express";
import { createUserController, getUserByIdController, softDeleteUserController, updateUserController } from "../controllers/user.controller";

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

export default userRouter;
