import { Request, Response } from "express";
import { createUserService, getUserByIdService, softDeleteUserService, updateUserService } from "../services/user.service";

export async function getUserByIdController(req: Request, res: Response) {
    const { uid } = req.params;
    if (!uid) {
        return res.status(400).json({ message: "User ID is required" });
    }
    try {
    const user = await getUserByIdService(uid);
    return user;
    } catch (error) {
        return res.status(500).json({ message: "Error getting user" });
    }
}

export async function createUserController(req: Request, res: Response) {
    const userData = req.body;
    if (!userData) {
        return res.status(400).json({ message: "User data is required" });
    }
    try {
        const newUser = await createUserService(userData);
        return res.status(201).json(newUser);
    } catch (error) {
        return res.status(500).json({ message: "Error creating user" });
    }
}
export async function updateUserController(req: Request, res: Response) {
    const { uid } = req.params;
    const userData = req.body;
    if (!uid || !userData) {
        return res.status(400).json({ message: "User ID and data are required" });
    }
    try {
        const updatedUser = await updateUserService(uid, userData);
        return res.status(200).json(updatedUser);
    } catch (error) {
        return res.status(500).json({ message: "Error updating user" });
    }
}
export async function softDeleteUserController(req: Request, res: Response) {
    const { uid } = req.params;
    if (!uid) {
        return res.status(400).json({ message: "User ID is required" });
    }
    try {
        const updatedUser = await softDeleteUserService(uid);
        return res.status(200).json(updatedUser);
    } catch (error) {
        return res.status(500).json({ message: "Error soft deleting user" });
    }
}