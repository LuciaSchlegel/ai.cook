import { NextFunction, Request, RequestHandler, Response } from "express";
import { getCategoriesService, getRecipeTagsService, getTagsService, getUnitsService } from "../services/resources.service";
import { controllerWrapper } from "../helpers/controllerWrapper";
import { UnitDto } from "../dtos/unit.dto";
import { CategoryDto } from "../dtos/category.dto";
import { TagDto } from "../dtos/tag.dto";
import { RecipeTagDto } from "../dtos/recipe_tag.dto";

export const getUnitsController = controllerWrapper(getUnitsService, UnitDto);

export const getCategoriesController = controllerWrapper(getCategoriesService, CategoryDto);

export const getTagsController = controllerWrapper(getTagsService, TagDto);

export const getRecipeTagsController = controllerWrapper(getRecipeTagsService, RecipeTagDto);
