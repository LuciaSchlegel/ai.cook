import { NextFunction, Request, Response } from "express";
import { BadRequestError, ForbiddenError, NotFoundError } from "../types/AppError";
import { UserRole } from "../entities/User";
import { UserRepository } from "../repositories/user.repository";

export async function adminAuthMiddleware(req: Request, res: Response, next: NextFunction) {
  const uid = req.headers.uid as string;
  if (!uid) {
    return next(new BadRequestError("User ID is required"));
  }
  const user = await UserRepository.findOne({ where: { uid: uid } });
  if (!user) {
    return next(new NotFoundError("User not found"));
  }
  if (user.role !== UserRole.ADMIN) {
    return next(new ForbiddenError(`Unauthorized: ${user.name} is not an admin`));
  }
  next();
}