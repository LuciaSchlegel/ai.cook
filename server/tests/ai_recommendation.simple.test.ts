import axios from 'axios';

// @ts-ignore - Jest types are available in test environment
describe('AI Recommendation Service Integration Test', () => {
  const BASE_URL = 'http://localhost:3000';
  
  // Configure axios for tests to prevent hanging
  const axiosInstance = axios.create({
    timeout: 15000,
    headers: {
      'Connection': 'close'
    }
  });
  
  // @ts-ignore - Jest types are available in test environment
  beforeEach(() => {
    // Setup test data before each test
  });

  // @ts-ignore - Jest types are available in test environment  
  afterAll(() => {
    // Clean up any open handles
    return new Promise(resolve => setTimeout(resolve, 100));
  });

  // Mock user ingredients data
  const testUserIngredients = [
    {
      id: 1,
      user: { uid: "test-user-123" },
      quantity: 1,
      ingredient: {
        id: 1,
        name: "chicken",
        category: { id: 1, name: "Meat" },
        tags: []
      },
      unit: {
        id: 1,
        name: "kilogram",
        abbreviation: "kg",
        type: "weight"
      }
    },
    {
      id: 2,
      user: { uid: "test-user-123" },
      quantity: 3,
      ingredient: {
        id: 2,
        name: "garlic",
        category: { id: 2, name: "Vegetables" },
        tags: []
      },
      unit: {
        id: 2,
        name: "cloves",
        abbreviation: "cloves",
        type: "count"
      }
    },
    {
      id: 3,
      user: { uid: "test-user-123" },
      quantity: 2,
      ingredient: {
        id: 3,
        name: "lemon",
        category: { id: 3, name: "Fruits" },
        tags: []
      },
      unit: {
        id: 3,
        name: "pieces",
        abbreviation: "pcs",
        type: "count"
      }
    }
  ];

  // @ts-ignore - Jest types are available in test environment
  describe('Recipe Filtering and AI Integration', () => {
    
    // @ts-ignore - Jest types are available in test environment
    test('should generate AI recommendations with user ingredients', async () => {
      const requestData = {
        userIngredients: testUserIngredients,
        preferredTags: ["quick", "healthy"],
        maxCookingTimeMinutes: 30,
        preferredDifficulty: "Easy",
        userPreferences: "I like Mediterranean cuisine",
        numberOfRecipes: 5
      };

      try {
        // Test the AI recommendations endpoint
        const response = await axiosInstance.post(
          `${BASE_URL}/ai-recommendations/recommendations`,
          requestData,
          {
            headers: { 'Content-Type': 'application/json' },
            timeout: 30000
          }
        );

        // @ts-ignore - Jest types are available in test environment
        expect(response.status).toBe(200);
        // @ts-ignore - Jest types are available in test environment
        expect(response.data).toBeDefined();
        // @ts-ignore - Jest types are available in test environment
        expect(response.data.recommendations).toBeDefined();
        // @ts-ignore - Jest types are available in test environment
        expect(response.data.filteredRecipes).toBeDefined();
        // @ts-ignore - Jest types are available in test environment
        expect(response.data.totalRecipesConsidered).toBeDefined();

        // Verify the response contains expected elements
        // @ts-ignore - Jest types are available in test environment
        expect(typeof response.data.recommendations).toBe('string');
        // @ts-ignore - Jest types are available in test environment
        expect(Array.isArray(response.data.filteredRecipes)).toBe(true);
        // @ts-ignore - Jest types are available in test environment
        expect(typeof response.data.totalRecipesConsidered).toBe('number');

        console.log('✅ AI Recommendations Response:', {
          recommendationsLength: response.data.recommendations.length,
          filteredRecipesCount: response.data.filteredRecipes.length,
          totalRecipesConsidered: response.data.totalRecipesConsidered
        });

      } catch (error) {
        console.error('❌ AI Recommendations test failed:', error);
        throw error;
      }
    }, 20000); // Reduced timeout

    // @ts-ignore - Jest types are available in test environment
    test('should handle cooking time limits in filtering', async () => {
      const requestData = {
        userIngredients: testUserIngredients,
        maxCookingTimeMinutes: 15, // Very strict time limit
        numberOfRecipes: 3
      };

      try {
        const response = await axiosInstance.post(
          `${BASE_URL}/ai-recommendations/recommendations`,
          requestData,
          {
            headers: { 'Content-Type': 'application/json' },
            timeout: 30000
          }
        );

        // @ts-ignore - Jest types are available in test environment
        expect(response.status).toBe(200);
        // @ts-ignore - Jest types are available in test environment
        expect(response.data.filteredRecipes).toBeDefined();

        // Verify that all recipes respect the time limit
        const filteredRecipes = response.data.filteredRecipes;
        filteredRecipes.forEach((recipe: any) => {
          if (recipe.cookingTime) {
            const timeInMinutes = parseInt(recipe.cookingTime);
            // @ts-ignore - Jest types are available in test environment
            expect(timeInMinutes).toBeLessThanOrEqual(15);
          }
        });

        console.log('✅ Time-filtered recipes:', filteredRecipes.length);

      } catch (error) {
        console.error('❌ Time filtering test failed:', error);
        throw error;
      }
    }, 15000);

    // @ts-ignore - Jest types are available in test environment
    test('should handle minimal user input gracefully', async () => {
      const requestData = {
        userIngredients: [testUserIngredients[0]], // Only chicken
        numberOfRecipes: 2
      };

      try {
        const response = await axiosInstance.post(
          `${BASE_URL}/ai-recommendations/recommendations`,
          requestData,
          {
            headers: { 'Content-Type': 'application/json' },
            timeout: 30000
          }
        );

        // @ts-ignore - Jest types are available in test environment
        expect(response.status).toBe(200);
        // @ts-ignore - Jest types are available in test environment
        expect(response.data.recommendations).toBeDefined();
        // @ts-ignore - Jest types are available in test environment
        expect(response.data.filteredRecipes).toBeDefined();

        // Should still provide meaningful recommendations
        // @ts-ignore - Jest types are available in test environment
        expect(response.data.recommendations.length).toBeGreaterThan(50);
        
        console.log('✅ Minimal input handled successfully');

      } catch (error) {
        console.error('❌ Minimal input test failed:', error);
        throw error;
      }
    }, 15000);
  });

  // @ts-ignore - Jest types are available in test environment
  describe('LLM Service Integration', () => {
    
    // @ts-ignore - Jest types are available in test environment
    test('should connect to Python LLM microservice for chat', async () => {
      const testPrompt = "Give me a quick cooking tip for chicken";

      try {
        // Test direct LLM service call
        const response = await axiosInstance.post(
          `${BASE_URL}/llm/talk`,
          { prompt: testPrompt },
          {
            headers: { 'Content-Type': 'application/json' },
            timeout: 30000
          }
        );

        // @ts-ignore - Jest types are available in test environment
        expect(response.status).toBe(200);
        // @ts-ignore - Jest types are available in test environment
        expect(response.data).toBeDefined();
        // @ts-ignore - Jest types are available in test environment
        expect(response.data.response).toBeDefined();
        // @ts-ignore - Jest types are available in test environment
        expect(typeof response.data.response).toBe('string');
        // @ts-ignore - Jest types are available in test environment
        expect(response.data.response.length).toBeGreaterThan(10);

        console.log('✅ LLM Service Response:', response.data.response.substring(0, 100) + '...');

      } catch (error) {
        console.error('❌ LLM service test failed:', error);
        throw error;
      }
    }, 15000);

    // @ts-ignore - Jest types are available in test environment
    test('should generate recipe from keywords', async () => {
      const keywords = ["chicken", "garlic", "lemon"];

      try {
        const response = await axiosInstance.post(
          `${BASE_URL}/llm/generate`,
          { keywords },
          {
            headers: { 'Content-Type': 'application/json' },
            timeout: 30000
          }
        );

        // @ts-ignore - Jest types are available in test environment
        expect(response.status).toBe(200);
        // @ts-ignore - Jest types are available in test environment
        expect(response.data).toBeDefined();
        // @ts-ignore - Jest types are available in test environment
        expect(response.data.recipe).toBeDefined();

        const recipe = typeof response.data.recipe === 'string' 
          ? JSON.parse(response.data.recipe) 
          : response.data.recipe;

        // @ts-ignore - Jest types are available in test environment
        expect(recipe.title).toBeDefined();
        // @ts-ignore - Jest types are available in test environment
        expect(recipe.ingredients).toBeDefined();
        // @ts-ignore - Jest types are available in test environment
        expect(recipe.instructions).toBeDefined();
        // @ts-ignore - Jest types are available in test environment
        expect(Array.isArray(recipe.ingredients)).toBe(true);
        // @ts-ignore - Jest types are available in test environment
        expect(Array.isArray(recipe.instructions)).toBe(true);

        console.log('✅ Generated Recipe:', recipe.title);

      } catch (error) {
        console.error('❌ Recipe generation test failed:', error);
        throw error;
      }
    }, 30000);

    // @ts-ignore - Jest types are available in test environment
    test('should respond to LLM health check', async () => {
      try {
        const response = await axiosInstance.get(
          `${BASE_URL}/llm/health`,
          {
            timeout: 10000
          }
        );

        // @ts-ignore - Jest types are available in test environment
        expect(response.status).toBe(200);
        // @ts-ignore - Jest types are available in test environment
        expect(response.data).toBeDefined();
        // @ts-ignore - Jest types are available in test environment
        expect(response.data.status).toBe('healthy');

        console.log('✅ LLM Health Check:', response.data);

      } catch (error) {
        console.error('❌ LLM health check failed:', error);
        throw error;
      }
    }, 15000);
  });

  // @ts-ignore - Jest types are available in test environment
  describe('Error Handling', () => {
    
    // @ts-ignore - Jest types are available in test environment
    test('should handle invalid user ingredients gracefully', async () => {
      const requestData = {
        userIngredients: [], // Empty ingredients
        numberOfRecipes: 5
      };

      try {
        const response = await axiosInstance.post(
          `${BASE_URL}/ai-recommendations/recommendations`,
          requestData,
          {
            headers: { 'Content-Type': 'application/json' },
            timeout: 30000
          }
        );

        // Should either return an error or handle gracefully
        if (response.status === 200) {
          // @ts-ignore - Jest types are available in test environment
          expect(response.data).toBeDefined();
          console.log('✅ Empty ingredients handled gracefully');
        }

      } catch (error) {
        // @ts-ignore - Jest types are available in test environment
        expect(error.response?.status).toBe(400);
        console.log('✅ Empty ingredients properly rejected');
      }
    }, 20000);

    // @ts-ignore - Jest types are available in test environment
    test('should handle invalid LLM prompts', async () => {
      try {
        const response = await axiosInstance.post(
          `${BASE_URL}/llm/talk`,
          { prompt: "" }, // Empty prompt
          {
            headers: { 'Content-Type': 'application/json' },
            timeout: 10000
          }
        );

        // Should return an error for empty prompt
        // @ts-ignore - Jest types are available in test environment
        expect(response.status).toBe(400);

      } catch (error) {
        // @ts-ignore - Jest types are available in test environment
        expect(error.response?.status).toBe(400);
        console.log('✅ Empty prompt properly rejected');
      }
    }, 15000);
  });
}); 