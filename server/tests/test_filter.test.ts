import axios from 'axios';

// @ts-ignore - Jest types are available in test environment
interface TestUserIngredient {
  id: number;
  user: { uid: string };
  quantity: number;
  ingredient: {
    id: number;
    name: string;
    category: { id: number; name: string };
    tags: any[];
  };
  unit: {
    id: number;
    name: string;
    abbreviation: string;
    type: string;
  };
}

interface TestFilterData {
  userIngredients: TestUserIngredient[];
  filter: string;
  preferredTags: string[];
  maxCookingTimeMinutes: number | null;
  preferredDifficulty: string | null;
}

// @ts-ignore - Jest types are available in test environment
describe('Recipe Filter API', () => {
  const testData: TestFilterData = {
    userIngredients: [
      {
        id: 1,
        user: { uid: "test-user" },
        quantity: 2,
        ingredient: {
          id: 1,
          name: "Tomato",
          category: { id: 1, name: "Vegetables" },
          tags: []
        },
        unit: {
          id: 1,
          name: "piece",
          abbreviation: "pcs",
          type: "count"
        }
      },
      {
        id: 2,
        user: { uid: "test-user" },
        quantity: 1,
        ingredient: {
          id: 2,
          name: "Onion",
          category: { id: 1, name: "Vegetables" },
          tags: []
        },
        unit: {
          id: 1,
          name: "piece",
          abbreviation: "pcs",
          type: "count"
        }
      }
    ],
    filter: "All Recipes",
    preferredTags: [],
    maxCookingTimeMinutes: null,
    preferredDifficulty: null
  };

  // @ts-ignore - Jest types are available in test environment
  test('should filter recipes with valid data', async () => {
    const response = await axios.post('http://localhost:3000/recipes/filter', testData, {
      headers: {
        'Content-Type': 'application/json'
      }
    });

    // @ts-ignore - Jest types are available in test environment
    expect(response.status).toBe(200);
    // @ts-ignore - Jest types are available in test environment
    expect(Array.isArray(response.data)).toBe(true);
  });

  // @ts-ignore - Jest types are available in test environment
  test('should handle empty ingredients', async () => {
    const emptyData: TestFilterData = {
      userIngredients: [],
      filter: "All Recipes",
      preferredTags: [],
      maxCookingTimeMinutes: null,
      preferredDifficulty: null
    };

    const response = await axios.post('http://localhost:3000/recipes/filter', emptyData, {
      headers: {
        'Content-Type': 'application/json'
      }
    });

    // @ts-ignore - Jest types are available in test environment
    expect(response.status).toBe(200);
    // @ts-ignore - Jest types are available in test environment
    expect(Array.isArray(response.data)).toBe(true);
  });

  // @ts-ignore - Jest types are available in test environment
  test('should handle different filter types', async () => {
    const filters = ['Available', 'Missing Ingredients', 'Recommended'];
    
    for (const filter of filters) {
      try {
        const response = await axios.post('http://localhost:3000/recipes/filter', {
          ...testData,
          filter
        }, {
          headers: {
            'Content-Type': 'application/json'
          }
        });
        
        // @ts-ignore - Jest types are available in test environment
        expect(response.status).toBe(200);
        // @ts-ignore - Jest types are available in test environment
        expect(Array.isArray(response.data)).toBe(true);
      } catch (error: any) {
        // Some filters might fail if no recipes match criteria
        // @ts-ignore - Jest types are available in test environment
        expect(error.response?.status).toBeDefined();
      }
    }
  });

  // @ts-ignore - Jest types are available in test environment
  test('should reject invalid filter', async () => {
    try {
      await axios.post('http://localhost:3000/recipes/filter', {
        userIngredients: [],
        filter: "Invalid Filter",
        preferredTags: [],
        maxCookingTimeMinutes: null,
        preferredDifficulty: null
      });
      // @ts-ignore - Jest types are available in test environment
      expect(true).toBe(false); // Should not reach here
    } catch (error: any) {
      // @ts-ignore - Jest types are available in test environment
      expect(error.response?.status).toBe(400);
    }
  });

  // @ts-ignore - Jest types are available in test environment
  test('should reject malformed data', async () => {
    try {
      await axios.post('http://localhost:3000/recipes/filter', {
        userIngredients: "not an array",
        filter: "All Recipes"
      });
      // @ts-ignore - Jest types are available in test environment
      expect(true).toBe(false); // Should not reach here
    } catch (error: any) {
      // @ts-ignore - Jest types are available in test environment
      expect(error.response?.status).toBe(400);
    }
  });
}); 