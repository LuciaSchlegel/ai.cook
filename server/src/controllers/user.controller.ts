import { Request, Response, NextFunction } from "express";
import {
  createUserService,
  getUserByIdService,
  softDeleteUserService,
  updateUserService
} from "../services/user.service";
import { BadRequestError } from "../types/AppError";
import { UserDto } from "../dtos/user.dto";
import { serialize } from "../helpers/serialize";

export async function getUserByIdController(req: Request, res: Response, next: NextFunction) {
  const { uid } = req.params;
  if (!uid) {
    return next(new BadRequestError("User ID is required"));
  }
  try {
    const user = await getUserByIdService(uid);
    res.status(200).json(serialize(UserDto, user));
  } catch (error) {
    next(error);
  }
}

export async function createUserController(req: Request, res: Response, next: NextFunction) {
  const userData = req.body;
  if (!userData) {
    return next(new BadRequestError("User data is required"));
  }
  try {
    const newUser = await createUserService(userData);
    res.status(201).json(serialize(UserDto, newUser)); // 201 para creación
  } catch (error) {
    next(error);
  }
}

export async function updateUserController(req: Request, res: Response, next: NextFunction) {
  const { uid } = req.params;
  const userData = req.body;
  if (!uid || !userData) {
    return next(new BadRequestError("User ID and data are required"));
  }
  try {
    const updatedUser = await updateUserService(uid, userData);
    res.status(200).json(serialize(UserDto, updatedUser));
  } catch (error) {
    next(error);
  }
}

export async function softDeleteUserController(req: Request, res: Response, next: NextFunction) {
  const { uid } = req.params;
  if (!uid) {
    return next(new BadRequestError("User ID is required"));
  }
  try {
    const updatedUser = await softDeleteUserService(uid);
    res.status(200).json(serialize(UserDto, updatedUser));
  } catch (error) {
    next(error);
  }
}