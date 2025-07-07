import { Category } from "../entities/Category";
import { RecipeTag } from "../entities/RecipeTag";
import { Tag } from "../entities/Tag";
import { Unit } from "../entities/Unit";
import { CategoryRepository } from "../repositories/category.repository";
import { RecipeTagRepository } from "../repositories/recipe_tag.repository";
import { TagRepository } from "../repositories/tag.repository";
import { UnitRepository } from "../repositories/unit.repository";

export const getUnitsService = async (): Promise<Unit[]> => {
  return await UnitRepository.find({});
};

export const getCategoriesService = async (): Promise<Category[]> => {
  return await CategoryRepository.find({});
};

export const getTagsService = async (): Promise<Tag[]> => {
  return await TagRepository.find({});
};

export const getRecipeTagsService = async (): Promise<RecipeTag[]> => {
  return await RecipeTagRepository.find({});
};