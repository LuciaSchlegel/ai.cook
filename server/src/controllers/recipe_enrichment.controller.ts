import { Request, Response, NextFunction, RequestHandler } from 'express';
import { generateRecipeEnrichment } from '../services/claude.service';

export const enrichRecipesController: RequestHandler = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const { uid } = req.params;
    if (!uid) {
      res.status(401).json({ error: 'Unauthorized' });
      return;
    }

    const { readyToCook, almostReady, userContext } = req.body;

    if ((!readyToCook || readyToCook.length === 0) && (!almostReady || almostReady.length === 0)) {
      res.json({
        ready_to_cook: [],
        almost_ready: [],
        shopping_suggestions: [],
        possible_substitutions: [],
      });
      return;
    }

    const result = await generateRecipeEnrichment({
      readyToCook: readyToCook || [],
      almostReady: almostReady || [],
      userIngredients: userContext?.availableIngredients || [],
      preferences: userContext?.preferences || { tags: [] },
    });

    const enrichment = result.data as any;

    const enrichmentMap = (arr: any[]) =>
      new Map(arr.map((e: any) => [e.recipe_id, e]));

    const readyMap = enrichmentMap(enrichment.ready_to_cook || []);
    const almostMap = enrichmentMap(enrichment.almost_ready || []);

    const mergeRecipe = (recipe: any, enrichMap: Map<number, any>) => {
      const e = enrichMap.get(recipe.id);
      return {
        id: recipe.id,
        title: recipe.name,
        time_minutes: extractTimeMinutes(recipe.cookingTime || ''),
        difficulty: recipe.difficulty,
        tags: recipe.tags || [],
        match_score: recipe.matchScore,
        description: e?.reasoning || 'Great recipe match!',
        ingredients: (recipe.matchingIngredients || []).map((name: string) => ({ name, quantity: '' })),
        steps: e?.cooking_tips || [],
        missing_ingredients: recipe.missingIngredients || [],
        recipe_substitutions: (e?.substitutions || []).map((s: any) => ({
          original: s.original,
          alternatives: s.alternatives,
        })),
      };
    };

    res.json({
      ready_to_cook: (readyToCook || []).map((r: any) => mergeRecipe(r, readyMap)),
      almost_ready: (almostReady || []).map((r: any) => mergeRecipe(r, almostMap)),
      shopping_suggestions: [],
      possible_substitutions: [],
    });
  } catch (error) {
    console.error('Enrichment error:', error);

    // Graceful degradation: return recipes without AI enrichment
    try {
      const { readyToCook, almostReady } = req.body;
      const fallback = (recipe: any) => ({
        id: recipe.id,
        title: recipe.name,
        time_minutes: extractTimeMinutes(recipe.cookingTime || ''),
        difficulty: recipe.difficulty,
        tags: recipe.tags || [],
        match_score: recipe.matchScore,
        description: 'Great recipe match!',
        ingredients: (recipe.matchingIngredients || []).map((name: string) => ({ name, quantity: '' })),
        steps: [],
        missing_ingredients: recipe.missingIngredients || [],
        recipe_substitutions: [],
      });

      res.json({
        ready_to_cook: (readyToCook || []).map(fallback),
        almost_ready: (almostReady || []).map(fallback),
        shopping_suggestions: [],
        possible_substitutions: [],
      });
    } catch {
      res.status(500).json({ error: 'Failed to enrich recipes' });
    }
  }
};

function extractTimeMinutes(timeString: string): number {
  if (!timeString) return 0;
  const m = timeString.match(/(\d+)\s*(?:min|m)/i);
  if (m) return parseInt(m[1]);
  const h = timeString.match(/(\d+)\s*(?:h|hour)/i);
  if (h) return parseInt(h[1]) * 60;
  const n = timeString.match(/(\d+)/);
  if (n) return parseInt(n[1]);
  return 0;
}
