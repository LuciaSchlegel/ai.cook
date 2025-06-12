import { ClassConstructor } from "class-transformer";
import { Request, Response, NextFunction, RequestHandler } from "express";
import { serialize } from "./serialize";

type ControllerFunction<T> = (req: Request) => Promise<T>;

export function controllerWrapper<T>(
  handler: ControllerFunction<T>,
  dto?: ClassConstructor<any>,
  statusCode = 200
): RequestHandler {
  return async (req: Request, res: Response, next: NextFunction) => {
    try {
      const result = await handler(req);
      const data = dto ? serialize(dto, result) : result;
      res.status(statusCode).json(data);
    } catch (error) {
      next(error);
    }
  };
}