// dto/ExternalRecipePreviewDto.ts

export interface ExternalRecipePreviewDto {
  id: number;
  title: string;
  image: string;
  readyInMinutes: number;
  servings: number;

  cuisines: string[];
  dishTypes: string[];
  diets: string[];

  extendedIngredients: {
    id: number;
    name: string;
    original: string;
    amount: number;
    unit: string;
  }[];
}