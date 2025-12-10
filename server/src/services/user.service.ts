import { User } from "../entities/User";
import { UserRepository } from "../repositories/user.repository";
import {
  NotFoundError,
  ConflictError,
  BadRequestError,
} from "../types/AppError";
import { BaseCrudService } from "./base/crud.base.service";

class UserService extends BaseCrudService<User> {
  protected repository = UserRepository;
  protected entityName = "User";
  protected idField = "uid";

  // Override findById für isDeleted Check
  async findById(uid: string): Promise<User> {
    const user = await this.repository.findOne({
      where: { uid, isDeleted: false },
    });
    if (!user) {
      throw new NotFoundError(`User with uid "${uid}" not found`);
    }
    return user;
  }

  // Override create für Duplikat-Check
  async create(userData: Partial<User>): Promise<User> {
    if (!userData.email) {
      throw new BadRequestError("Email is required.");
    }
    const existing = await this.repository.findOne({
      where: [{ email: userData.email }, { uid: userData.uid }],
    });
    if (existing) {
      throw new ConflictError("A user with that email or uid already exists.");
    }
    return super.create(userData);
  }

  async update(uid: string, userData: Partial<User>): Promise<User> {
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

  async softDelete(uid: string): Promise<User> {
    const userToSoftDelete = await UserRepository.findOneBy({ uid });
    if (!userToSoftDelete) {
      throw new NotFoundError(`User with uid "${uid}" not found`);
    }
    userToSoftDelete.isDeleted = true;
    const updatedUser = await UserRepository.save(userToSoftDelete);
    return updatedUser;
  }
}

// Singleton Export
export const userService = new UserService();

// Backward Compatibility (damit bestehende Imports weiter funktionieren)
export const getUserByIdService = (uid: string) => userService.findById(uid);
export const createUserService = (data: Partial<User>) =>
  userService.create(data);
export const updateUserService = (uid: string, data: Partial<User>) =>
  userService.update(uid, data);
export const softDeleteUserService = (uid: string) =>
  userService.softDelete(uid);
