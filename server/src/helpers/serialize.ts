import { plainToInstance } from "class-transformer";

/**
 * Serializa cualquier objeto o arreglo de objetos basado en un DTO.
 *
 * @param cls - El DTO a usar para transformar.
 * @param data - Objeto o arreglo de objetos a transformar.
 * @returns - Objeto serializado con claves transformadas y solo campos expuestos.
 */
export function serialize<T>(cls: new (...args: any[]) => T, data: any): T | T[] {
  return plainToInstance(cls, data, {
    excludeExtraneousValues: true,
  });
}