// dto/ExternalRecipeFullDto.ts

export interface ExternalRecipeStepsDto {
  id: number;
  steps: {
    number: number;
    step: string;
  }[];
}
