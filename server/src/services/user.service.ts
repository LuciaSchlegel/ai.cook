import { User } from "../entities/User";
import { UserRepository } from "../repositories/user.repository";
import {
  NotFoundError,
  ConflictError,
  BadRequestError
} from "../types/AppError";

export async function getUserByIdService(uid: string) {
  const user = await UserRepository.findOne({
    where: { uid, isDeleted: false }
  });
  if (!user) {
    throw new NotFoundError(`User with uid "${uid}" not found`);
  }
  return user;
}

export async function createUserService(userData: User) {
  // Validación básica, agregá más según tu modelo
  if (!userData.email || !userData.password) {
    throw new BadRequestError("Email and password are required.");
  }
  // Evitar usuarios duplicados (email/uid)
  const existing = await UserRepository.findOne({
    where: [
      { email: userData.email },
      { uid: userData.uid }
    ]
  });
  if (existing) {
    throw new ConflictError("A user with that email or uid already exists.");
  }
  const newUser = await UserRepository.save(userData);
  return newUser;
}

export async function updateUserService(uid: string, userData: User) {
  const userToUpdate = await UserRepository.findOneBy({ uid });
  if (!userToUpdate) {
    throw new NotFoundError(`User with uid "${uid}" not found`);
  }
  const updatedUser = await UserRepository.save({
    ...userToUpdate,
    ...userData,
  });
  return updatedUser;
}

export async function softDeleteUserService(uid: string) {
  const userToSoftDelete = await UserRepository.findOneBy({ uid });
  if (!userToSoftDelete) {
    throw new NotFoundError(`User with uid "${uid}" not found`);
  }
  userToSoftDelete.isDeleted = true;
  const updatedUser = await UserRepository.save(userToSoftDelete);
  return updatedUser;
}