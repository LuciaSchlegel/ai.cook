import { User } from "../entities/User";
import { UserRepository } from "../repositories/user.repository";

export async function getUserByIdService(uid: string) {
    const user = await UserRepository.findOneBy({ uid });
    if (!user) {
        throw new Error("User not found");
    }
    return user;
}

export async function createUserService(userData: User) {
    const newUser = await UserRepository.save(userData);
    return newUser;
}

export async function updateUserService(uid: string, userData: User) {
    const userToUpdate = await UserRepository.findOneBy({ uid });
    if (!userToUpdate) {
        throw new Error("User not found");
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
        throw new Error("User not found");
    }
    userToSoftDelete.isDeleted = true;
    const updatedUser = await UserRepository.save(userToSoftDelete);
    return updatedUser;
}