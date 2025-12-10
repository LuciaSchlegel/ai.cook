import { Request, Response, NextFunction } from "express";
import { userService } from "../services/user.service";
import { UserDto } from "../dtos/user.dto";
import { createCrudController } from "../controllers/base/crud.base.controller";

const crud = createCrudController(userService, {
  dto: UserDto,
  toSnakeCase: true,
  idParam: "uid",
});

export const getUserByIdController = crud.getById;
export const createUserController = crud.create;
export const updateUserController = crud.update;
export const softDeleteUserController = crud.softDelete;
