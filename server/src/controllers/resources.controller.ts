
import { getCategoriesService, getDietaryTagsService, getRecipeTagsService, getUnitsService } from "../services/resources.service";
import { controllerWrapper } from "../helpers/controllerWrapper";
import { UnitDto } from "../dtos/unit.dto";
import { CategoryDto } from "../dtos/category.dto";
import { RecipeTagDto } from "../dtos/recipe_tag.dto";
import { DietaryTagDto } from "../dtos/dietary_tag.dto";

export const getUnitsController = controllerWrapper(getUnitsService, UnitDto);

export const getCategoriesController = controllerWrapper(getCategoriesService, CategoryDto);

export const getRecipeTagsController = controllerWrapper(getRecipeTagsService, RecipeTagDto);

export const getDietaryTagsController = controllerWrapper(getDietaryTagsService, DietaryTagDto);
