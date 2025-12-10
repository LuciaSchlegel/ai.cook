import { Repository, FindOptionsWhere, DeepPartial } from "typeorm";
import { NotFoundError } from "../../types/AppError";

export interface ICrudService<T> {
  findById(id: string | number): Promise<T>;
  findAll(): Promise<T[]>;
  create(data: DeepPartial<T>): Promise<T>;
  update(id: string | number, data: DeepPartial<T>): Promise<T>;
  delete(id: string | number): Promise<T | { success: boolean }>;
  softDelete?(id: string | number): Promise<T>;
}

export abstract class BaseCrudService<T extends { id?: number }>
  implements ICrudService<T>
{
  protected abstract repository: Repository<T>;
  protected abstract entityName: string;

  // Optional: Relations die bei find geladen werden sollen
  protected relations: string[] = [];

  // Optional: Feld für ID (default: 'id', kann 'uid' sein)
  protected idField: string = "id";

  async findById(id: string | number): Promise<T> {
    const where = { [this.idField]: id } as FindOptionsWhere<T>;
    const entity = await this.repository.findOne({
      where,
      relations: this.relations,
    });
    if (!entity) {
      throw new NotFoundError(
        `${this.entityName} with ${this.idField} "${id}" not found`
      );
    }
    return entity;
  }

  async findAll(): Promise<T[]> {
    return this.repository.find({ relations: this.relations });
  }

  async create(data: DeepPartial<T>): Promise<T> {
    const entity = this.repository.create(data);
    return this.repository.save(entity);
  }

  async update(id: string | number, data: DeepPartial<T>): Promise<T> {
    const entity = await this.findById(id);
    Object.assign(entity, data);
    return this.repository.save(entity);
  }

  async delete(id: string | number): Promise<T> {
    const entity = await this.findById(id);
    await this.repository.remove(entity);
    return entity;
  }

  // Für Soft Delete (optional override)
  async softDelete(id: string | number): Promise<T> {
    const entity = (await this.findById(id)) as T & { isDeleted?: boolean };
    if ("isDeleted" in entity) {
      entity.isDeleted = true;
      return this.repository.save(entity);
    }
    throw new Error(`${this.entityName} does not support soft delete`);
  }
}
