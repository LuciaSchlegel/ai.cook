import axios from "axios";
import { getRecipeStepsService } from "../src/services/api.service";
import { ExternalRecipeStepsDto } from "../src/dtos/ext_recipe_steps";

jest.mock("axios");
const mockedAxios = axios as jest.Mocked<typeof axios>;

const mockResponse = {
  data: {
    id: 12345,
    title: "Mock Recipe",
    image: "mock.jpg",
    readyInMinutes: 30,
    servings: 2,
    cuisines: ["Italian"],
    dishTypes: ["main course"],
    diets: ["vegetarian"],
    extendedIngredients: [
      {
        id: 1,
        name: "Pasta",
        original: "200g pasta",
        measures: {
          metric: {
            amount: 200,
            unitShort: "g"
          }
        }
      }
    ],
    analyzedInstructions: [
      {
        steps: [
          { number: 1, step: "Boil water" },
          { number: 2, step: "Add pasta" }
        ]
      }
    ]
  }
};

describe("getRecipeStepsService caching", () => {
  beforeEach(() => {
    mockedAxios.get.mockClear();
  });

  it("fetches and caches recipe steps", async () => {
    mockedAxios.get.mockResolvedValueOnce(mockResponse);

    // First call: triggers Axios request
    const first = await getRecipeStepsService({ recipeId: 12345 });
    expect(mockedAxios.get).toHaveBeenCalledTimes(1);
    expect(first).toEqual<ExternalRecipeStepsDto>({
      id: 12345,
      steps: [
        { number: 1, step: "Boil water" },
        { number: 2, step: "Add pasta" },
      ],
    });

    // Second call: should hit cache
    const second = await getRecipeStepsService({ recipeId: 12345 });
    expect(mockedAxios.get).toHaveBeenCalledTimes(1); // no new call
    expect(second).toEqual(first);
  });
});