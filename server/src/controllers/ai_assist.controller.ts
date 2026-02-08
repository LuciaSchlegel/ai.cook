import { Request, Response, NextFunction, RequestHandler } from 'express';
import { AIAssistRequest } from '../types/ai_assist.types';
import {
  generateSubstitutions,
  generateDietAdaptation,
} from '../services/claude.service';

export const aiAssistController: RequestHandler = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  const body = req.body as AIAssistRequest;

  if (!body?.type) {
    res.status(400).json({
      success: false,
      error: 'Missing "type" field',
      code: 'VALIDATION_ERROR',
    });
    return;
  }

  try {
    switch (body.type) {
      case 'substitutions': {
        if (!body.ingredient?.trim()) {
          res.status(400).json({
            success: false,
            type: 'substitutions',
            error: 'ingredient is required',
            code: 'VALIDATION_ERROR',
          });
          return;
        }
        const result = await generateSubstitutions({
          ingredient: body.ingredient.trim(),
          recipeName: body.recipeName?.trim(),
          dietaryRestrictions: body.dietaryRestrictions,
        });
        res.json({ success: true, type: 'substitutions', data: result.data });
        return;
      }

      case 'diet_adaptation': {
        if (!body.recipeName?.trim() || !body.ingredients?.length || !body.dietaryNeeds?.length) {
          res.status(400).json({
            success: false,
            type: 'diet_adaptation',
            error: 'recipeName, ingredients, and dietaryNeeds are required',
            code: 'VALIDATION_ERROR',
          });
          return;
        }
        const result = await generateDietAdaptation({
          recipeName: body.recipeName.trim(),
          ingredients: body.ingredients,
          dietaryNeeds: body.dietaryNeeds,
        });
        res.json({ success: true, type: 'diet_adaptation', data: result.data });
        return;
      }

      default:
        res.status(400).json({
          success: false,
          error: `Unknown type: ${(body as any).type}`,
          code: 'INVALID_TYPE',
        });
        return;
    }
  } catch (error) {
    console.error(`AI assist error [${body.type}]:`, error);
    res.status(500).json({
      success: false,
      type: body.type,
      error: error instanceof Error ? error.message : 'AI service error',
      code: 'AI_SERVICE_ERROR',
    });
  }
};
