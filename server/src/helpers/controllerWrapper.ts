import { ClassConstructor } from "class-transformer";
import { Request, Response, NextFunction, RequestHandler } from "express";
import { serialize } from "./serialize";
import { toSnakeCaseDeep } from "./toSnakeCase";

type ControllerFunction<T> = (req: Request) => Promise<T>;

interface WrapperOptions {
  dto?: ClassConstructor<any>;
  statusCode?: number;
  toSnakeCase?: boolean;
}

export function controllerWrapper<T>(
  handler: ControllerFunction<T>,
  options: WrapperOptions | ClassConstructor<any> = {}
): RequestHandler {
  const opts: WrapperOptions =
    typeof options === "function" ? { dto: options } : options;

  const { dto, statusCode = 200, toSnakeCase = false } = opts;

  return async (req: Request, res: Response, next: NextFunction) => {
    try {
      const result = await handler(req);

      let data = dto ? serialize(dto, result) : result;

      if (toSnakeCase) {
        data = toSnakeCaseDeep(data);
      }

      res.status(statusCode).json(data);
    } catch (error: any) {
      if (error.status) {
        res.status(error.status).json({
          message: error.message,
          errors: error.errors,
          error: error.error,
        });
      } else {
        // Für AppError-basierte Fehler: an Express Error-Handler weiterleiten
        next(error);
      }
    }
  };
}
