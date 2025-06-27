import { ExternalRecipePreviewDto } from "./ext_recipe_prev.dto";

export interface ExternalRecipeFullDto extends ExternalRecipePreviewDto {
    id: number;
    steps: {
      number: number;
      step: string;
    }[];
  
}