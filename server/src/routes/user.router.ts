import { Router, Request, Response } from "express";
import { createUserController, getUserByIdController, softDeleteUserController, updateUserController } from "../controllers/user.controller";

const userRouter = Router();

// routes

userRouter.post('/sign_up', async (req: Request, res: Response) => {
    // Handle user creation
    await createUserController(req, res);
});

userRouter.put('/:uid', async (req: Request, res: Response) => {
    // Handle user update
    await updateUserController(req, res);
});

userRouter.get('/:uid', async (req: Request, res: Response) => {
	await getUserByIdController(req, res);
});

userRouter.delete('/:uid', async (req: Request, res: Response) => {
    // Handle user sodeletion
    await softDeleteUserController(req, res);
});

export default userRouter;
