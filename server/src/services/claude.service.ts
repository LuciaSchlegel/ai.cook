import Anthropic from '@anthropic-ai/sdk';

const MODEL = 'claude-haiku-4-5-20251001';

// Singleton client
let client: Anthropic | null = null;

function getClient(): Anthropic {
  if (!client) {
    client = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY });
  }
  return client;
}

// ===== SYSTEM PROMPTS (minimal for token efficiency) =====

const SYSTEM_PROMPTS = {
  substitutions:
    'Concise culinary expert. Suggest practical ingredient substitutes. Use the provided tool.',
  diet_adaptation:
    'Concise dietary expert. Modify recipes for dietary needs. Use the provided tool.',
  recipe_enrichment:
    'Concise culinary advisor. For each recipe, explain WHY it matches and give 2-3 cooking tips. Use the provided tool.',
} as const;

// ===== TOOL SCHEMAS =====

const TOOLS: Record<string, Anthropic.Tool> = {
  substitutions: {
    name: 'respond_substitutions',
    description: 'Return ingredient substitution suggestions',
    input_schema: {
      type: 'object' as const,
      properties: {
        substitutes: {
          type: 'array',
          items: {
            type: 'object',
            properties: {
              name: { type: 'string' },
              ratio: { type: 'string', description: 'e.g. "1:1" or "1 cup = 3/4 cup"' },
              notes: { type: 'string', description: 'Brief flavor/texture note' },
            },
            required: ['name', 'ratio', 'notes'],
          },
        },
        tip: { type: 'string', description: 'One brief substitution tip' },
      },
      required: ['substitutes', 'tip'],
    },
  },

  diet_adaptation: {
    name: 'respond_diet_adaptation',
    description: 'Return dietary adaptation for a recipe',
    input_schema: {
      type: 'object' as const,
      properties: {
        modifications: {
          type: 'array',
          items: {
            type: 'object',
            properties: {
              original: { type: 'string' },
              replacement: { type: 'string' },
              notes: { type: 'string' },
            },
            required: ['original', 'replacement', 'notes'],
          },
        },
        tip: { type: 'string' },
      },
      required: ['modifications', 'tip'],
    },
  },

  recipe_enrichment: {
    name: 'respond_enrichment',
    description: 'Return enriched recipe recommendations',
    input_schema: {
      type: 'object' as const,
      properties: {
        ready_to_cook: {
          type: 'array',
          items: {
            type: 'object',
            properties: {
              recipe_id: { type: 'integer' },
              reasoning: { type: 'string' },
              cooking_tips: { type: 'array', items: { type: 'string' } },
              substitutions: {
                type: 'array',
                items: {
                  type: 'object',
                  properties: {
                    original: { type: 'string' },
                    alternatives: { type: 'array', items: { type: 'string' } },
                  },
                  required: ['original', 'alternatives'],
                },
              },
            },
            required: ['recipe_id', 'reasoning', 'cooking_tips', 'substitutions'],
          },
        },
        almost_ready: {
          type: 'array',
          items: {
            type: 'object',
            properties: {
              recipe_id: { type: 'integer' },
              reasoning: { type: 'string' },
              cooking_tips: { type: 'array', items: { type: 'string' } },
              substitutions: {
                type: 'array',
                items: {
                  type: 'object',
                  properties: {
                    original: { type: 'string' },
                    alternatives: { type: 'array', items: { type: 'string' } },
                  },
                  required: ['original', 'alternatives'],
                },
              },
            },
            required: ['recipe_id', 'reasoning', 'cooking_tips', 'substitutions'],
          },
        },
      },
      required: ['ready_to_cook', 'almost_ready'],
    },
  },
};

// ===== MAX TOKENS PER TASK =====

const MAX_TOKENS: Record<string, number> = {
  substitutions: 400,
  diet_adaptation: 500,
  recipe_enrichment: 1024,
};

// ===== PUBLIC INTERFACES =====

export interface SubstitutionInput {
  ingredient: string;
  recipeName?: string;
  dietaryRestrictions?: string[];
}

export interface DietAdaptationInput {
  recipeName: string;
  ingredients: string[];
  dietaryNeeds: string[];
}

export interface RecipeForEnrichment {
  id: number;
  name: string;
  cookingTime: string;
  difficulty: string;
  matchScore: number;
  missingIngredients: string[];
}

export interface RecipeEnrichmentInput {
  readyToCook: RecipeForEnrichment[];
  almostReady: RecipeForEnrichment[];
  userIngredients: string[];
  preferences: {
    tags: string[];
    maxCookingTimeMinutes?: number;
    preferredDifficulty?: string;
  };
}

export interface ClaudeResult<T = unknown> {
  data: T;
  usage: {
    input_tokens: number;
    output_tokens: number;
    cache_read_tokens: number;
    cache_creation_tokens: number;
  };
}

// ===== PUBLIC FUNCTIONS =====

export async function generateSubstitutions(
  input: SubstitutionInput
): Promise<ClaudeResult> {
  let msg = `Substitutes for ${input.ingredient}.`;
  if (input.recipeName) msg += ` Recipe: ${input.recipeName}.`;
  if (input.dietaryRestrictions?.length) {
    msg += ` Diet: ${input.dietaryRestrictions.join(', ')}.`;
  }
  msg += ' 3-4 options.';

  return callClaude('substitutions', msg);
}

export async function generateDietAdaptation(
  input: DietAdaptationInput
): Promise<ClaudeResult> {
  const msg = `Adapt "${input.recipeName}" for ${input.dietaryNeeds.join(', ')}. Ingredients: ${input.ingredients.join(', ')}. Only modify what needs changing.`;
  return callClaude('diet_adaptation', msg);
}

export async function generateRecipeEnrichment(
  input: RecipeEnrichmentInput
): Promise<ClaudeResult> {
  const ingredients = input.userIngredients.slice(0, 15).join(', ');

  const prefs = [
    input.preferences.tags.length ? `cuisines: ${input.preferences.tags.join(', ')}` : null,
    input.preferences.maxCookingTimeMinutes ? `max ${input.preferences.maxCookingTimeMinutes}min` : null,
    input.preferences.preferredDifficulty ? `difficulty: ${input.preferences.preferredDifficulty}` : null,
  ].filter(Boolean).join(', ');

  const fmt = (recipes: RecipeForEnrichment[]) =>
    recipes.map(r => {
      const missing = r.missingIngredients.length ? r.missingIngredients.join(', ') : 'none';
      return `#${r.id}: ${r.name} (${r.cookingTime}, ${r.difficulty}, missing: ${missing})`;
    }).join('\n') || 'none';

  const msg = `User has: ${ingredients}
Prefs: ${prefs || 'none'}

READY:
${fmt(input.readyToCook)}

ALMOST READY:
${fmt(input.almostReady)}

Enrich ONLY these recipes. Use their exact IDs.`;

  return callClaude('recipe_enrichment', msg);
}

// ===== CORE =====

async function callClaude(
  taskType: 'substitutions' | 'diet_adaptation' | 'recipe_enrichment',
  userMessage: string
): Promise<ClaudeResult> {
  const anthropic = getClient();
  const tool = TOOLS[taskType];
  const maxTokens = MAX_TOKENS[taskType];

  const response = await anthropic.messages.create({
    model: MODEL,
    max_tokens: maxTokens,
    system: [
      {
        type: 'text',
        text: SYSTEM_PROMPTS[taskType],
        cache_control: { type: 'ephemeral' },
      },
    ],
    tools: [tool],
    tool_choice: { type: 'tool', name: tool.name },
    messages: [{ role: 'user', content: userMessage }],
  });

  const toolBlock = response.content.find(b => b.type === 'tool_use');
  if (!toolBlock || toolBlock.type !== 'tool_use') {
    throw new Error(`Claude did not return tool_use for task: ${taskType}`);
  }

  return {
    data: toolBlock.input,
    usage: {
      input_tokens: response.usage.input_tokens,
      output_tokens: response.usage.output_tokens,
      cache_read_tokens: (response.usage as any).cache_read_input_tokens || 0,
      cache_creation_tokens: (response.usage as any).cache_creation_input_tokens || 0,
    },
  };
}

export async function healthCheck(): Promise<boolean> {
  try {
    const anthropic = getClient();
    await anthropic.messages.create({
      model: MODEL,
      max_tokens: 10,
      messages: [{ role: 'user', content: 'OK' }],
    });
    return true;
  } catch {
    return false;
  }
}
