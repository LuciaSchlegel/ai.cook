//
//  Models.swift
//  Runner
//
//  Created by Lucia Schlegel on 02.11.25.
//

import Foundation
import FoundationModels

// MARK: - Input Models

struct RecipeForAI: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String
    let cookingTime: String
    let difficulty: String
    let servings: Int
    let tags: [String]
    let ingredients: [IngredientForAI]
}

struct IngredientForAI: Codable {
    let name: String
    let quantity: Double
    let unit: String
}

struct UserContextForAI: Codable {
    let availableIngredients: [String]
    let preferences: PreferencesForAI
    let dietaryRestrictions: DietaryRestrictionsForAI
}

struct PreferencesForAI: Codable {
    let tags: [String]
    let maxCookingTimeMinutes: Int?
    let preferredDifficulty: String?
    let notes: String?
    let numberOfRecipes: Int?
}

struct DietaryRestrictionsForAI: Codable {
    let isVegan: Bool
    let isVegetarian: Bool
    let isGlutenFree: Bool
    let isLactoseFree: Bool
}

struct AIRecommendationData: Codable {
    let recipes: [RecipeForAI]
    let userContext: UserContextForAI
    let metadata: MetadataForAI
}

struct MetadataForAI: Codable {
    let totalRecipes: Int
    let totalUserIngredients: Int
    let timestamp: String
}

// MARK: - Output Models

@Generable(description: "AI-generated recipe recommendations based on user context and available ingredients")
struct AIRecommendations: Codable {
    @Guide(description: "Recipes the user can cook immediately with their available ingredients")
    let readyToCook: [RecommendedRecipe]

    @Guide(description: "Recipes the user can cook with minimal additional ingredients")
    let almostReady: [RecommendedRecipe]

    @Guide(description: "Suggested ingredients to purchase for more cooking options")
    let shoppingList: [ShoppingItem]

    @Guide(description: "General ingredient substitution suggestions for the user")
    let possibleSubstitutions: [Substitution]

    // Custom coding keys to match Flutter's expected snake_case format
    enum CodingKeys: String, CodingKey {
        case readyToCook = "ready_to_cook"
        case almostReady = "almost_ready"
        case shoppingList = "shopping_suggestions"
        case possibleSubstitutions = "possible_substitutions"
    }

    // Standard init for manual creation
    init(readyToCook: [RecommendedRecipe], almostReady: [RecommendedRecipe], shoppingList: [ShoppingItem], possibleSubstitutions: [Substitution]) {
        self.readyToCook = readyToCook
        self.almostReady = almostReady
        self.shoppingList = shoppingList
        self.possibleSubstitutions = possibleSubstitutions
    }
    
    @Generable(description: "A recommended recipe with match details and cooking information")
    struct RecommendedRecipe: Codable, Identifiable {
        let id = UUID()

        @Guide(description: "The unique ID of the recipe from the input data")
        let recipeId: Int

        @Guide(description: "The name of the recommended recipe")
        let recipeName: String

        @Guide(description: "Match score from 0-100 indicating how well this recipe fits the user's context", .range(0...100))
        let matchScore: Int

        @Guide(description: "Clear explanation of why this recipe is recommended for the user")
        let reasoning: String

        @Guide(description: "List of ingredients the user doesn't have but needs for this recipe")
        let missingIngredients: [String]

        @Guide(description: "Suggested ingredient substitutions using what the user has available")
        let suggestedSubstitutions: [Substitution]

        @Guide(description: "Helpful cooking tips specific to this recipe")
        let cookingTips: [String]

        enum CodingKeys: String, CodingKey {
            case recipeId, recipeName, matchScore, reasoning
            case missingIngredients, suggestedSubstitutions, cookingTips
        }
    }
    
    @Generable(description: "An ingredient substitution suggestion")
    struct Substitution: Codable, Identifiable {
        let id = UUID()

        @Guide(description: "The original ingredient that needs to be substituted")
        let original: String

        @Guide(description: "List of suggested substitute ingredients")
        let alternatives: [String]

        enum CodingKeys: String, CodingKey {
            case original, alternatives
        }

        // Custom decoding for backward compatibility (AI might send single substitute)
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.original = try container.decode(String.self, forKey: .original)

            // Try to decode as array, fallback to single string
            if let alts = try? container.decode([String].self, forKey: .alternatives) {
                self.alternatives = alts
            } else {
                self.alternatives = []
            }
        }

        init(original: String, alternatives: [String]) {
            self.original = original
            self.alternatives = alternatives
        }
    }

    @Generable(description: "A shopping list item")
    struct ShoppingItem: Codable, Identifiable {
        let id = UUID()

        @Guide(description: "The ingredient name to purchase")
        let name: String

        @Guide(description: "Explanation of why this ingredient is valuable")
        let reason: String

        enum CodingKeys: String, CodingKey {
            case name, reason
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.name = try container.decode(String.self, forKey: .name)
            self.reason = try container.decode(String.self, forKey: .reason)
        }

        init(name: String, reason: String) {
            self.name = name
            self.reason = reason
        }
    }
}

struct ProcessingMetadata: Codable {
    let totalRecipesAnalyzed: Int
    let processingTimeMs: Int
    let modelVersion: String
}

// Wrapper that combines AI-generated recommendations with processing metadata
struct AIRecommendationsWithMetadata: Codable {
    let recommendations: AIRecommendations
    let processingMetadata: ProcessingMetadata?
    
    var hasAnyRecommendations: Bool {
        !recommendations.readyToCook.isEmpty || !recommendations.almostReady.isEmpty
    }
    
    var totalRecommendations: Int {
        recommendations.readyToCook.count + recommendations.almostReady.count
    }
    
    static var exampleOutputRecipe: AIRecommendationsWithMetadata {
        AIRecommendationsWithMetadata(
            recommendations: AIRecommendations(
                readyToCook: [],
                almostReady: [],
                shoppingList: [],
                possibleSubstitutions: []
            ),
            processingMetadata: ProcessingMetadata(
                totalRecipesAnalyzed: 150,
                processingTimeMs: 1200,
                modelVersion: "claude-sonnet-4.5"
            )
        )
    }
}
