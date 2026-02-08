//
//  RecipesGeneratorClean.swift
//  Runner
//
//  CLEAN APPROACH: AI only generates language (reasoning, tips, substitutions)
//  Backend pre-computes ALL matching data and categorization
//

import Foundation
import FoundationModels
import Observation

// Simplified input model - recipes already categorized by backend
struct PreComputedRecipe: Codable {
    let id: Int
    let name: String
    let cookingTime: String
    let difficulty: String
    let tags: [String]
    let matchingIngredients: [String]
    let missingIngredients: [String]
    let matchScore: Int
    let ingredientMatchPercent: Int
}

struct PreComputedData: Codable {
    let readyToCook: [PreComputedRecipe]
    let almostReady: [PreComputedRecipe]
    let userContext: UserContext

    struct UserContext: Codable {
        let availableIngredients: [String]
        let preferences: Preferences

        struct Preferences: Codable {
            let tags: [String]
            let maxCookingTimeMinutes: Int?
            let preferredDifficulty: String?
        }
    }
}

// AI output - just language, no selection/scoring
@Generable
struct RecipeEnrichment {
    let recipeId: Int
    let reasoning: String  // WHY this matches the user
    let cookingTips: [String]  // 2-3 practical tips
    let substitutions: [Substitution]  // For missing ingredients

    @Generable
    struct Substitution {
        let original: String
        let alternatives: [String]
    }
}

@Generable
struct EnrichedRecommendations {
    let readyToCook: [RecipeEnrichment]
    let almostReady: [RecipeEnrichment]
}

@Observable
@MainActor
final class RecipesGeneratorClean {

    var error: Error?
    private var session: LanguageModelSession?

    private(set) var enrichedRecommendations: EnrichedRecommendations?
    var isGenerating: Bool = false

    /// Check if Apple Intelligence is available on this device
    static var isAvailable: Bool {
        if #available(iOS 26.0, *) {
            switch SystemLanguageModel.default.availability {
            case .available:
                return true
            case .unavailable(let reason):
                print("⚠️ Model unavailable: \(reason)")
                return false
            }
        }
        return false
    }

    init() {
        // Only initialize if available
        guard RecipesGeneratorClean.isAvailable else {
            print("⚠️ Apple Intelligence not available for RecipesGeneratorClean")
            return
        }

        if #available(iOS 26.0, *) {
            // MUCH SIMPLER INSTRUCTIONS - AI just generates language
            let instructions = Instructions {
                """
                You are a culinary advisor who provides personalized cooking advice.

                Your job is simple: explain WHY each recipe matches the user and give helpful tips.

                DO NOT select recipes, score recipes, or categorize them - that's already done.

                For each recipe, provide:
                1. reasoning: Explain WHY this recipe matches their situation (available ingredients, preferences, time)
                2. cookingTips: 2-3 practical, actionable tips for cooking this dish
                3. substitutions: Practical swaps for missing ingredients (if any)

                Be warm, encouraging, and specific to THIS user's situation.
                """
            }
            self.session = LanguageModelSession(instructions: instructions)
        }
    }

    func enrichRecipes(preComputedData: PreComputedData, isRetry: Bool = false) async {
        guard !preComputedData.readyToCook.isEmpty || !preComputedData.almostReady.isEmpty else {
            self.error = NSError(
                domain: "RecipesGeneratorClean",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "No recipes to enrich"]
            )
            return
        }

        guard #available(iOS 26.0, *) else {
            self.error = NSError(
                domain: "RecipesGeneratorClean",
                code: -2,
                userInfo: [NSLocalizedDescriptionKey: "iOS 26+ required for Apple Intelligence"]
            )
            return
        }

        // Check model availability before each request
        switch SystemLanguageModel.default.availability {
        case .available:
            break
        case .unavailable(.deviceNotEligible):
            self.error = NSError(
                domain: "RecipesGeneratorClean",
                code: -3,
                userInfo: [NSLocalizedDescriptionKey: "This device is not eligible for Apple Intelligence. Apple Intelligence requires iPhone 15 Pro, iPhone 16, or newer."]
            )
            return
        case .unavailable(.appleIntelligenceNotEnabled):
            self.error = NSError(
                domain: "RecipesGeneratorClean",
                code: -3,
                userInfo: [NSLocalizedDescriptionKey: "Apple Intelligence is not enabled. Please enable it in Settings > Apple Intelligence & Siri."]
            )
            return
        case .unavailable(.modelNotReady):
            self.error = NSError(
                domain: "RecipesGeneratorClean",
                code: -3,
                userInfo: [NSLocalizedDescriptionKey: "Apple Intelligence model is still downloading or not ready. Please try again later."]
            )
            return
        case .unavailable(let reason):
            self.error = NSError(
                domain: "RecipesGeneratorClean",
                code: -3,
                userInfo: [NSLocalizedDescriptionKey: "Apple Intelligence is unavailable: \(reason)"]
            )
            return
        }

        // Initialize or reinitialize session if needed
        if self.session == nil {
            let instructions = Instructions {
                """
                You are a culinary advisor who provides personalized cooking advice.

                Your job is simple: explain WHY each recipe matches the user and give helpful tips.

                DO NOT select recipes, score recipes, or categorize them - that's already done.

                For each recipe, provide:
                1. reasoning: Explain WHY this recipe matches their situation (available ingredients, preferences, time)
                2. cookingTips: 2-3 practical, actionable tips for cooking this dish
                3. substitutions: Practical swaps for missing ingredients (if any)

                Be warm, encouraging, and specific to THIS user's situation.
                """
            }
            self.session = LanguageModelSession(instructions: instructions)
            print("🔄 Session initialized for recipe enrichment")
        }

        guard let session = self.session else {
            self.error = NSError(
                domain: "RecipesGeneratorClean",
                code: -4,
                userInfo: [NSLocalizedDescriptionKey: "Failed to initialize AI session"]
            )
            return
        }

        // Check if session is already responding
        if session.isResponding {
            self.error = NSError(
                domain: "RecipesGeneratorClean",
                code: -6,
                userInfo: [NSLocalizedDescriptionKey: "A request is already in progress. Please wait."]
            )
            return
        }

        isGenerating = true
        error = nil

        do {
            let prompt = buildEnrichmentPrompt(preComputedData: preComputedData)

            print("🤖 Starting recipe enrichment...")
            print("📊 Ready to Cook: \(preComputedData.readyToCook.count)")
            print("📊 Almost Ready: \(preComputedData.almostReady.count)")
            if isRetry {
                print("🔄 This is a retry attempt with reduced recipes")
            }

            let startTime = Date()

            let response = try await session.respond(
                to: prompt,
                generating: EnrichedRecommendations.self,
                includeSchemaInPrompt: false,
                options: GenerationOptions(sampling: .greedy)
            )

            self.enrichedRecommendations = response.content

            let elapsed = Date().timeIntervalSince(startTime)
            print("✅ Enrichment completed in \(String(format: "%.2f", elapsed))s")

            // Validate and log results
            if let enriched = self.enrichedRecommendations {
                // Validate enrichments before using
                validateEnrichments(enriched: enriched, preComputedData: preComputedData)

                print("\n🔍 ENRICHMENT RESULTS:")
                print("==================================================")
                print("🍽️ READY TO COOK (\(enriched.readyToCook.count)):")
                for (index, recipe) in enriched.readyToCook.enumerated() {
                    print("  \(index + 1). Recipe ID: \(recipe.recipeId)")
                    print("     Reasoning: \(recipe.reasoning)")
                    print("     Tips: \(recipe.cookingTips.joined(separator: "; "))")
                    if !recipe.substitutions.isEmpty {
                        print("     Substitutions:")
                        for sub in recipe.substitutions {
                            print("       - \(sub.original) → \(sub.alternatives.joined(separator: ", "))")
                        }
                    }
                    print("")
                }

                print("🛒 ALMOST READY (\(enriched.almostReady.count)):")
                for (index, recipe) in enriched.almostReady.enumerated() {
                    print("  \(index + 1). Recipe ID: \(recipe.recipeId)")
                    print("     Reasoning: \(recipe.reasoning)")
                    print("     Tips: \(recipe.cookingTips.joined(separator: "; "))")
                    if !recipe.substitutions.isEmpty {
                        print("     Substitutions:")
                        for sub in recipe.substitutions {
                            print("       - \(sub.original) → \(sub.alternatives.joined(separator: ", "))")
                        }
                    }
                    print("")
                }
                print("==================================================")
            }

        } catch let error as LanguageModelSession.GenerationError {
            print("❌ Generation error: \(error)")

            // Provide specific error messages based on error description
            let errorDescription = error.localizedDescription.lowercased()
            
            // Check for context window errors
            if errorDescription.contains("context") || errorDescription.contains("window") || errorDescription.contains("size") {
                // Check if this is the first attempt and retry is possible
                if !isRetry {
                    print("⚠️ Context window exceeded - retrying with fewer recipes...")
                    
                    // Clean up session state
                    if #available(iOS 26.0, *) {
                        self.session = LanguageModelSession(instructions: Instructions {
                            """
                            You are a culinary advisor who provides personalized cooking advice.

                            Your job is simple: explain WHY each recipe matches the user and give helpful tips.

                            DO NOT select recipes, score recipes, or categorize them - that's already done.

                            For each recipe, provide:
                            1. reasoning: Explain WHY this recipe matches their situation (available ingredients, preferences, time)
                            2. cookingTips: 2-3 practical, actionable tips for cooking this dish
                            3. substitutions: Practical swaps for missing ingredients (if any)

                            Be warm, encouraging, and specific to THIS user's situation.
                            """
                        })
                    }

                    // Reduce recipes by 1
                    let reducedData = reduceRecipesByOne(preComputedData: preComputedData)

                    if !reducedData.readyToCook.isEmpty || !reducedData.almostReady.isEmpty {
                        print("🔄 Retrying with \(reducedData.readyToCook.count) ready + \(reducedData.almostReady.count) almost ready")

                        // Retry with reduced data
                        await enrichRecipes(preComputedData: reducedData, isRetry: true)
                        return
                    } else {
                        print("❌ Cannot retry - no recipes remaining")
                        let errorMessage = "Too many recipes to process at once."
                        self.error = NSError(
                            domain: "RecipesGeneratorClean",
                            code: -5,
                            userInfo: [NSLocalizedDescriptionKey: errorMessage]
                        )
                        isGenerating = false
                        return
                    }
                } else {
                    let errorMessage = "The request is too large. Try with fewer recipes."
                    self.error = NSError(
                        domain: "RecipesGeneratorClean",
                        code: -5,
                        userInfo: [NSLocalizedDescriptionKey: errorMessage]
                    )
                    isGenerating = false
                    return
                }
            }
            
            // Check for unavailable errors
            if errorDescription.contains("unavailable") || errorDescription.contains("not available") {
                let errorMessage = "Apple Intelligence model is unavailable. Please check Settings > Apple Intelligence & Siri."
                self.error = NSError(
                    domain: "RecipesGeneratorClean",
                    code: -5,
                    userInfo: [NSLocalizedDescriptionKey: errorMessage]
                )
                isGenerating = false
                return
            }
            
            // Check for ModelManagerError in underlying errors
            let nsError = error as NSError
            if let underlyingErrors = nsError.userInfo[NSMultipleUnderlyingErrorsKey] as? [NSError] {
                for underlyingError in underlyingErrors {
                    print("   Underlying error: \(underlyingError)")
                    if underlyingError.domain == "ModelManagerServices.ModelManagerError" {
                        let errorMessage = "The AI model failed to initialize. This may be temporary - please try again in a few moments. If the problem persists, restart your device."
                        self.error = NSError(
                            domain: "RecipesGeneratorClean",
                            code: -5,
                            userInfo: [NSLocalizedDescriptionKey: errorMessage]
                        )
                        isGenerating = false
                        return
                    }
                }
            }
            
            // Default error message
            let errorMessage = "Failed to enrich recipes: \(error.localizedDescription)"
            self.error = NSError(
                domain: "RecipesGeneratorClean",
                code: -5,
                userInfo: [NSLocalizedDescriptionKey: errorMessage]
            )
        } catch {
            print("❌ Unexpected error enriching recipes: \(error)")

            // Check if this is a context limit error and retry is possible
            if !isRetry && isContextLimitError(error) {
                print("⚠️ Context window exceeded - retrying with fewer recipes...")

                // Clean up session state
                if #available(iOS 26.0, *) {
                    self.session = LanguageModelSession(instructions: Instructions {
                        """
                        You are a culinary advisor who provides personalized cooking advice.

                        Your job is simple: explain WHY each recipe matches the user and give helpful tips.

                        DO NOT select recipes, score recipes, or categorize them - that's already done.

                        For each recipe, provide:
                        1. reasoning: Explain WHY this recipe matches their situation (available ingredients, preferences, time)
                        2. cookingTips: 2-3 practical, actionable tips for cooking this dish
                        3. substitutions: Practical swaps for missing ingredients (if any)

                        Be warm, encouraging, and specific to THIS user's situation.
                        """
                    })
                }

                // Reduce recipes by 1
                let reducedData = reduceRecipesByOne(preComputedData: preComputedData)

                if !reducedData.readyToCook.isEmpty || !reducedData.almostReady.isEmpty {
                    print("🔄 Retrying with \(reducedData.readyToCook.count) ready + \(reducedData.almostReady.count) almost ready")

                    // Retry with reduced data
                    await enrichRecipes(preComputedData: reducedData, isRetry: true)
                    return
                } else {
                    print("❌ Cannot retry - no recipes remaining")
                }
            }

            // Check for ModelManagerError in any error
            let nsError = error as NSError
            if let underlyingErrors = nsError.userInfo[NSMultipleUnderlyingErrorsKey] as? [NSError] {
                for underlyingError in underlyingErrors {
                    print("   Underlying error: \(underlyingError)")
                    if underlyingError.domain == "ModelManagerServices.ModelManagerError" {
                        let modelErrorMessage = "The AI model failed to initialize. This may be temporary - please try again in a few moments. If the problem persists, restart your device."
                        self.error = NSError(
                            domain: "RecipesGeneratorClean",
                            code: -5,
                            userInfo: [NSLocalizedDescriptionKey: modelErrorMessage]
                        )
                        isGenerating = false
                        return
                    }
                }
            }

            self.error = NSError(
                domain: "RecipesGeneratorClean",
                code: -5,
                userInfo: [NSLocalizedDescriptionKey: "Unexpected error: \(error.localizedDescription)"]
            )
        }

        isGenerating = false
    }

    // Check if error is related to context window limits
    private func isContextLimitError(_ error: Error) -> Bool {
        let errorDescription = error.localizedDescription.lowercased()
        return errorDescription.contains("context") ||
               errorDescription.contains("token") ||
               errorDescription.contains("limit") ||
               errorDescription.contains("too large") ||
               errorDescription.contains("too long")
    }

    // Reduce recipe count by 1 (prioritize keeping ready-to-cook)
    private func reduceRecipesByOne(preComputedData: PreComputedData) -> PreComputedData {
        var readyToCook = preComputedData.readyToCook
        var almostReady = preComputedData.almostReady

        // Remove from almost ready first, then ready to cook
        if !almostReady.isEmpty {
            almostReady.removeLast()
            print("🔻 Removed 1 recipe from almost ready (now: \(almostReady.count))")
        } else if !readyToCook.isEmpty {
            readyToCook.removeLast()
            print("🔻 Removed 1 recipe from ready to cook (now: \(readyToCook.count))")
        }

        return PreComputedData(
            readyToCook: readyToCook,
            almostReady: almostReady,
            userContext: preComputedData.userContext
        )
    }

    private func buildEnrichmentPrompt(preComputedData: PreComputedData) -> Prompt {
        let userPrefs = preComputedData.userContext.preferences
        let ingredientList = preComputedData.userContext.availableIngredients.prefix(15).joined(separator: ", ")

        var prefs: [String] = []
        if !userPrefs.tags.isEmpty {
            prefs.append("cuisines: \(userPrefs.tags.joined(separator: ", "))")
        }
        if let maxTime = userPrefs.maxCookingTimeMinutes {
            prefs.append("max time: \(maxTime)min")
        }
        if let difficulty = userPrefs.preferredDifficulty {
            prefs.append("difficulty: \(difficulty)")
        }

        // Build recipe list (concise format)
        let readyList = preComputedData.readyToCook.map { recipe in
            let missing = recipe.missingIngredients.isEmpty ? "none" : recipe.missingIngredients.joined(separator: ", ")
            return """
            #\(recipe.id): \(recipe.name)
               \(recipe.cookingTime) | \(recipe.difficulty) | Score: \(recipe.matchScore)
               Missing: \(missing)
            """
        }.joined(separator: "\n")

        let almostList = preComputedData.almostReady.map { recipe in
            let missing = recipe.missingIngredients.joined(separator: ", ")
            return """
            #\(recipe.id): \(recipe.name)
               \(recipe.cookingTime) | \(recipe.difficulty) | Score: \(recipe.matchScore)
               Missing: \(missing)
            """
        }.joined(separator: "\n")

        // Extract recipe IDs for validation
        let readyIds = preComputedData.readyToCook.map { String($0.id) }
        let almostIds = preComputedData.almostReady.map { String($0.id) }

        return Prompt {
            """
            USER CONTEXT:
            Ingredients: \(ingredientList)...
            Preferences: \(prefs.isEmpty ? "none" : prefs.joined(separator: ", "))

            READY TO COOK (0-1 missing):
            \(readyList.isEmpty ? "none" : readyList)

            ALMOST READY (2-3 missing):
            \(almostList.isEmpty ? "none" : almostList)

            ⚠️ CRITICAL INSTRUCTIONS - READ CAREFULLY:

            1. ONLY enrich the recipes listed above. DO NOT make up or invent additional recipes.
            2. You must return EXACTLY \(preComputedData.readyToCook.count) ready-to-cook enrichments.
            3. You must return EXACTLY \(preComputedData.almostReady.count) almost-ready enrichments.
            4. Use ONLY these recipe IDs:
               - Ready to Cook: \(readyIds.isEmpty ? "none" : readyIds.joined(separator: ", "))
               - Almost Ready: \(almostIds.isEmpty ? "none" : almostIds.joined(separator: ", "))
            5. DO NOT include recipes with IDs not listed above.
            6. If a category is empty (none), return an empty array for that category.

            For EACH recipe listed above, provide:
            - reasoning: WHY this recipe matches the user's situation
            - cookingTips: 2-3 practical, actionable cooking tips
            - substitutions: Practical swaps for missing ingredients (if any)

            Example response structure:
            {
              "readyToCook": [\(readyIds.isEmpty ? "" : " /* enrichments for IDs: \(readyIds.joined(separator: ", ")) */ ")],
              "almostReady": [\(almostIds.isEmpty ? "" : " /* enrichments for IDs: \(almostIds.joined(separator: ", ")) */ ")]
            }
            """
        }
    }

    // Validate enrichments match input recipes
    func validateEnrichments(enriched: EnrichedRecommendations, preComputedData: PreComputedData) {
        let expectedReadyCount = preComputedData.readyToCook.count
        let expectedAlmostCount = preComputedData.almostReady.count
        let actualReadyCount = enriched.readyToCook.count
        let actualAlmostCount = enriched.almostReady.count

        if actualReadyCount != expectedReadyCount {
            print("⚠️ WARNING: AI generated \(actualReadyCount) ready recipes but expected \(expectedReadyCount)")
            print("   This indicates the AI hallucinated or skipped recipes!")
        }

        if actualAlmostCount != expectedAlmostCount {
            print("⚠️ WARNING: AI generated \(actualAlmostCount) almost ready recipes but expected \(expectedAlmostCount)")
            print("   This indicates the AI hallucinated or skipped recipes!")
        }

        // Validate recipe IDs
        let expectedReadyIds = Set(preComputedData.readyToCook.map { $0.id })
        let actualReadyIds = Set(enriched.readyToCook.map { $0.recipeId })
        let extraReadyIds = actualReadyIds.subtracting(expectedReadyIds)

        if !extraReadyIds.isEmpty {
            print("⚠️ WARNING: AI hallucinated ready recipes with IDs: \(Array(extraReadyIds))")
            print("   These enrichments will be ignored in the final response.")
        }

        let expectedAlmostIds = Set(preComputedData.almostReady.map { $0.id })
        let actualAlmostIds = Set(enriched.almostReady.map { $0.recipeId })
        let extraAlmostIds = actualAlmostIds.subtracting(expectedAlmostIds)

        if !extraAlmostIds.isEmpty {
            print("⚠️ WARNING: AI hallucinated almost ready recipes with IDs: \(Array(extraAlmostIds))")
            print("   These enrichments will be ignored in the final response.")
        }
    }

    func prewarmModel() {
        guard #available(iOS 26.0, *) else {
            print("⚠️ iOS 26+ required for Apple Intelligence")
            return
        }
        
        // Check availability
        switch SystemLanguageModel.default.availability {
        case .available:
            break
        case .unavailable(let reason):
            print("⚠️ Cannot prewarm: Model unavailable - \(reason)")
            return
        }

        Task { @MainActor in
            do {
                // Initialize session if needed
                if self.session == nil {
                    let instructions = Instructions {
                        """
                        You are a culinary advisor who provides personalized cooking advice.

                        Your job is simple: explain WHY each recipe matches the user and give helpful tips.

                        DO NOT select recipes, score recipes, or categorize them - that's already done.

                        For each recipe, provide:
                        1. reasoning: Explain WHY this recipe matches their situation (available ingredients, preferences, time)
                        2. cookingTips: 2-3 practical, actionable tips for cooking this dish
                        3. substitutions: Practical swaps for missing ingredients (if any)

                        Be warm, encouraging, and specific to THIS user's situation.
                        """
                    }
                    self.session = LanguageModelSession(instructions: instructions)
                    print("🔄 Session initialized during prewarm")
                }
                
                guard let session = self.session else {
                    print("⚠️ Failed to initialize session for prewarming")
                    return
                }

                print("🔥 Prewarming Recipes model...")

                // Send a simple warm-up prompt to initialize the model
                let warmupPrompt = "Ready to provide culinary advice."

                _ = try await session.respond(
                    to: warmupPrompt,
                    options: GenerationOptions(sampling: .greedy)
                )

                print("✅ Recipes model prewarmed successfully")
            } catch {
                print("⚠️ Recipes prewarm failed (non-critical): \(error.localizedDescription)")
                
                // If prewarm fails, clear the session so it can be recreated on next use
                self.session = nil
            }
        }
    }

    func cleanup() {
        enrichedRecommendations = nil
        error = nil
        isGenerating = false
        print("🧹 RecipesGeneratorClean cleaned up")
    }
}
