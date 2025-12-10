//einfacher CRUD-Base-Controller
//soll in jedem controller verwendet werden, beschreibt die CRUD-Operationen
import { Request } from "express";
import { ClassConstructor } from "class-transformer";
import { controllerWrapper } from "../../helpers/controllerWrapper";
import { ICrudService } from "../../services/base/crud.base.service";
import { BadRequestError } from "../../types/AppError";

interface CrudControllerOptions {
  dto: ClassConstructor<any>;
  toSnakeCase?: boolean;
  idParam?: string; // Default: 'id', kann 'uid' sein
}

export function createCrudController<T>(
  service: ICrudService<T>,
  options: CrudControllerOptions
) {
  const { dto, toSnakeCase = false, idParam = "id" } = options;

  return {
    getById: controllerWrapper(
      async (req: Request) => {
        const id = req.params[idParam];
        if (!id) throw new BadRequestError(`${idParam} is required`);
        return service.findById(id);
      },
      { dto, toSnakeCase }
    ),

    getAll: controllerWrapper(async (req: Request) => service.findAll(), {
      dto,
      toSnakeCase,
    }),

    create: controllerWrapper(
      async (req: Request) => {
        if (!req.body) throw new BadRequestError("Request body is required");
        return service.create(req.body);
      },
      { dto, statusCode: 201, toSnakeCase }
    ),

    update: controllerWrapper(
      async (req: Request) => {
        const id = req.params[idParam];
        if (!id) throw new BadRequestError(`${idParam} is required`);
        return service.update(id, req.body);
      },
      { dto, toSnakeCase }
    ),

    delete: controllerWrapper(
      async (req: Request) => {
        const id = req.params[idParam];
        if (!id) throw new BadRequestError(`${idParam} is required`);
        return service.delete(id);
      },
      { dto, toSnakeCase }
    ),

    softDelete: controllerWrapper(
      async (req: Request) => {
        const id = req.params[idParam];
        if (!id) throw new BadRequestError(`${idParam} is required`);
        return (service as any).softDelete(id);
      },
      { dto, toSnakeCase }
    ),
  };
}
