export type AIAssistRequest = SubstitutionsRequest | DietAdaptationRequest;

export interface SubstitutionsRequest {
  type: 'substitutions';
  ingredient: string;
  recipeName?: string;
  dietaryRestrictions?: string[];
}

export interface DietAdaptationRequest {
  type: 'diet_adaptation';
  recipeName: string;
  ingredients: string[];
  dietaryNeeds: string[];
}

export interface AIAssistResponse<T = unknown> {
  success: boolean;
  type: string;
  data: T;
  usage?: {
    input_tokens: number;
    output_tokens: number;
  };
}

export interface AIAssistErrorResponse {
  success: false;
  type: string;
  error: string;
  code: 'VALIDATION_ERROR' | 'AI_SERVICE_ERROR' | 'INVALID_TYPE';
}
