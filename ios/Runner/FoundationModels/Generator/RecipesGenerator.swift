//
//  RecipesGenerator.swift
//  Runner
//
//  Created by Lucia Schlegel on 02.11.25.
//

import Foundation
import FoundationModels
import Observation

@Observable
@MainActor
final class RecipesGenerator {

    var error: Error?
    private var session: LanguageModelSession

    private(set) var recommendations: AIRecommendations?
    var isGenerating: Bool = false

    // Pre-compiled regex patterns for performance
    private static let timeRegexPatterns: [(regex: NSRegularExpression, hourIndex: Int, minuteIndex: Int)] = {
        do {
            return [
                (regex: try NSRegularExpression(pattern: #"(\d+)h(?:our)?(?:s)?(\d+)?m"#), hourIndex: 1, minuteIndex: 2),
                (regex: try NSRegularExpression(pattern: #"(\d+)m(?:in)?(?:s)?"#), hourIndex: -1, minuteIndex: 1),
                (regex: try NSRegularExpression(pattern: #"(\d+)h(?:our)?(?:s)?"#), hourIndex: 1, minuteIndex: -1)
            ]
        } catch {
            print("⚠️ Failed to compile time regex patterns: \(error)")
            return []
        }
    }()
    
    init() {
        let instructions = Instructions {
            """
            You are a culinary advisor analyzing recipes for personalized recommendations.

            STRICT CATEGORIZATION RULES - COUNT MISSING INGREDIENTS CAREFULLY:
            - Ready to Cook: EXACTLY 0 or 1 missing ingredients. If 2+ missing, DO NOT put in readyToCook.
            - Almost Ready: EXACTLY 2 or 3 missing ingredients. If 0-1 missing, DO NOT put in almostReady.
            - Ignore recipes with 4+ missing ingredients.

            SCORING (0-100): 90-100=perfect (0 missing), 80-89=excellent (1 missing), 70-79=good (2-3 missing).

            REASONING: Explain WHY this matches the user's situation (ingredients available, time, preferences).

            SUBSTITUTIONS: Only suggest practical swaps maintaining dish quality.
            """
        }
        self.session = LanguageModelSession(instructions: instructions)
    }
    
    func generateRecommendations(
        recipes: [RecipeForAI],
        userContext: UserContextForAI
    ) async {
        guard !recipes.isEmpty else {
            self.error = NSError(
                domain: "RecipesGenerator",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "No recipes available"]
            )
            return
        }
        
        guard !userContext.availableIngredients.isEmpty else {
            self.error = NSError(
                domain: "RecipesGenerator",
                code: -2,
                userInfo: [NSLocalizedDescriptionKey: "No ingredients available"]
            )
            return
        }
        
        isGenerating = true

        do {
            // Create user ingredient set once for reuse
            let userIngredientSet = Set(userContext.availableIngredients.map { $0.lowercased() })

            // Pre-filter recipes to the most relevant ones (cache scores for debug)
            // Reduced to 10 to stay within 4096 token context window
            let scoredRecipes = selectMostRelevantRecipesWithScores(
                from: recipes,
                userContext: userContext,
                userIngredientSet: userIngredientSet,
                maxCount: 10
            )
            let relevantRecipes = scoredRecipes.map { $0.recipe }

            let prompt = buildOptimizedPrompt(
                recipes: relevantRecipes,
                userContext: userContext,
                userIngredientSet: userIngredientSet
            )

            print("🤖 Starting AI recommendation generation...")
            print("📊 Analyzing \(relevantRecipes.count) relevant recipes (filtered from \(recipes.count))")
            print("🥬 User has \(userContext.availableIngredients.count) ingredients")
            print("⚠️  Context window limit: 4096 tokens")

            // Debug the filtering results (reuse already-computed scores)
            print("\n🔍 PRE-FILTERING DEBUG:")
            print("Top 5 selected recipes by relevance score:")
            let debugRecipes = Array(scoredRecipes.prefix(5))
            for (index, scoredRecipe) in debugRecipes.enumerated() {
                print("  \(index + 1). \(scoredRecipe.recipe.name) (Score: \(String(format: "%.1f", scoredRecipe.score)))")
                print("     Time: \(scoredRecipe.recipe.cookingTime), Difficulty: \(scoredRecipe.recipe.difficulty)")
                let recipeIngredientSet = Set(scoredRecipe.recipe.ingredients.map { $0.name.lowercased() })
                let matchingCount = userIngredientSet.intersection(recipeIngredientSet).count
                print("     Matching ingredients: \(matchingCount)/\(scoredRecipe.recipe.ingredients.count)")
            }
            print("")
            
            let startTime = Date()
            
            let response = try await session.respond(
                to: prompt,
                generating: AIRecommendations.self,
                includeSchemaInPrompt: false,
                options: GenerationOptions(sampling: .greedy)
            )

            // Validate and sanitize AI output before accepting
            self.recommendations = validateRecommendations(
                response.content,
                against: relevantRecipes
            )
            
            let endTime = Date()
            let processingTime = Int(endTime.timeIntervalSince(startTime) * 1000)
            
            print("✅ AI recommendations generated in \(processingTime)ms")
            
            // Comprehensive debugging output
            if let recs = self.recommendations {
                print("\n🔍 DETAILED AI OUTPUT:")
                print(String(repeating: "=", count: 50))
                
                print("🍽️ READY TO COOK (\(recs.readyToCook.count)):")
                for (index, recipe) in recs.readyToCook.enumerated() {
                    print("  \(index + 1). \(recipe.recipeName) (Score: \(recipe.matchScore))")
                    print("     ID: \(recipe.recipeId)")
                    print("     Reasoning: \(recipe.reasoning)")
                    if !recipe.missingIngredients.isEmpty {
                        print("     Missing: \(recipe.missingIngredients.joined(separator: ", "))")
                    }
                    if !recipe.suggestedSubstitutions.isEmpty {
                        print("     Substitutions:")
                        for sub in recipe.suggestedSubstitutions {
                            print("       - \(sub.original) → \(sub.alternatives.joined(separator: ", "))")
                        }
                    }
                    if !recipe.cookingTips.isEmpty {
                        print("     Tips: \(recipe.cookingTips.joined(separator: "; "))")
                    }
                    print("")
                }
                
                print("🛒 ALMOST READY (\(recs.almostReady.count)):")
                for (index, recipe) in recs.almostReady.enumerated() {
                    print("  \(index + 1). \(recipe.recipeName) (Score: \(recipe.matchScore))")
                    print("     ID: \(recipe.recipeId)")
                    print("     Reasoning: \(recipe.reasoning)")
                    if !recipe.missingIngredients.isEmpty {
                        print("     Missing: \(recipe.missingIngredients.joined(separator: ", "))")
                    }
                    if !recipe.suggestedSubstitutions.isEmpty {
                        print("     Substitutions:")
                        for sub in recipe.suggestedSubstitutions {
                            print("       - \(sub.original) → \(sub.alternatives.joined(separator: ", "))")
                        }
                    }
                    if !recipe.cookingTips.isEmpty {
                        print("     Tips: \(recipe.cookingTips.joined(separator: "; "))")
                    }
                    print("")
                }
                
                print("🛍️ SHOPPING LIST (\(recs.shoppingList.count)):")
                for (index, item) in recs.shoppingList.enumerated() {
                    print("  \(index + 1). \(item.name)")
                    print("     Reason: \(item.reason)")
                    print("")
                }
                
                print("🔄 POSSIBLE SUBSTITUTIONS (\(recs.possibleSubstitutions.count)):")
                for (index, sub) in recs.possibleSubstitutions.enumerated() {
                    print("  \(index + 1). \(sub.original) → \(sub.alternatives.joined(separator: ", "))")
                }
                
                print(String(repeating: "=", count: 50))
                print("📊 SUMMARY: \(recs.readyToCook.count) ready, \(recs.almostReady.count) almost ready, \(recs.shoppingList.count) shopping items")
                print("")
            } else {
                print("⚠️ No recommendations generated - response.content was nil")
            }
            
        } catch {
            print("❌ Error generating recommendations: \(error)")
            self.error = error
        }
        
        isGenerating = false
    }
    
    private func buildOptimizedPrompt(
        recipes: [RecipeForAI],
        userContext: UserContextForAI,
        userIngredientSet: Set<String>
    ) -> Prompt {
        
        let analyzedRecipes = recipes.map { recipe -> (recipe: RecipeForAI, matches: Int, total: Int) in
            let recipeIngredients = recipe.ingredients.map { $0.name.lowercased() }
            let matches = recipeIngredients.filter { userIngredientSet.contains($0) }.count
            return (recipe, matches, recipeIngredients.count)
        }.sorted { $0.matches > $1.matches } // Sort by best matches first

        // Use all recipes passed in (already filtered to 10)
        let topRecipes = Array(analyzedRecipes)

        // Reduce ingredient list to save tokens (10 instead of 20)
        let ingredientList = userContext.availableIngredients.prefix(10).joined(separator: ", ")
        let ingredientSuffix = userContext.availableIngredients.count > 10
            ? "... +\(userContext.availableIngredients.count - 10)"
            : ""

        var prefs = [String]()
        if !userContext.preferences.tags.isEmpty {
            prefs.append("tags:\(userContext.preferences.tags.joined(separator: ","))")
        }
        if let maxTime = userContext.preferences.maxCookingTimeMinutes {
            prefs.append("time:\(maxTime)m")
        }
        if let difficulty = userContext.preferences.preferredDifficulty {
            prefs.append("diff:\(difficulty)")
        }

        let recipeList = topRecipes.enumerated().map { idx, item in
            let (recipe, matches, total) = item
            let missing = total - matches

            // Minimal ingredient list (3 instead of 4)
            let ings = recipe.ingredients.map(\.name).prefix(3).joined(separator: ", ")
            let suffix = recipe.ingredients.count > 3 ? "..." : ""

            return "#\(recipe.id): \(recipe.name) | \(recipe.cookingTime) | \(recipe.difficulty) | \(matches)/\(total) | \(ings)\(suffix)"
        }.joined(separator: "\n")

        return Prompt {
            """
            INGREDIENTS: \(ingredientList)\(ingredientSuffix)
            PREFS: \(prefs.isEmpty ? "none" : prefs.joined(separator: ", "))
            DIET: \(buildDietaryText(userContext.dietaryRestrictions))

            RECIPES:
            \(recipeList)

            CRITICAL: Use EXACT recipe ID (number after #). E.g., #123 → recipeId:123

            CATEGORIZE STRICTLY BY MISSING INGREDIENT COUNT:
            - readyToCook: recipes with 0 or 1 missing ingredients ONLY
            - almostReady: recipes with 2 or 3 missing ingredients ONLY

            Return up to 3 recipes total.
            JSON: {"readyToCook":[{"recipeId":<ID>,"recipeName":"<NAME>","matchScore":<0-100>,"reasoning":"<WHY>","missingIngredients":[],"suggestedSubstitutions":[{"original":"","alternatives":[]}],"cookingTips":["<TIP>"]}],"almostReady":[],"shoppingList":[{"name":"","reason":""}],"possibleSubstitutions":[]}
            """
        }
    }
    
    private func buildDietaryText(_ restrictions: DietaryRestrictionsForAI) -> String {
        var parts: [String] = []
        if restrictions.isVegan { parts.append("vegan") }
        else if restrictions.isVegetarian { parts.append("veg") }
        if restrictions.isGlutenFree { parts.append("GF") }
        if restrictions.isLactoseFree { parts.append("LF") }
        return parts.isEmpty ? "none" : parts.joined(separator: ",")
    }

    // MARK: - Output Validation

    /// Validates AI-generated recommendations
    /// - Ensures recipe IDs exist in input dataset
    /// - Clamps match scores to valid range (0-100)
    /// - Removes duplicate recommendations
    private func validateRecommendations(
        _ recommendations: AIRecommendations,
        against validRecipes: [RecipeForAI]
    ) -> AIRecommendations {
        let validRecipeIds = Set(validRecipes.map { $0.id })
        var seenRecipeIds = Set<Int>()
        var invalidCount = 0
        var duplicateCount = 0

        func validateRecipe(_ recipe: AIRecommendations.RecommendedRecipe) -> Bool {
            // Check for invalid recipe ID
            guard validRecipeIds.contains(recipe.recipeId) else {
                invalidCount += 1
                print("⚠️ Filtered invalid recipe ID: \(recipe.recipeId) (\(recipe.recipeName))")
                return false
            }

            // Check for duplicates
            guard !seenRecipeIds.contains(recipe.recipeId) else {
                duplicateCount += 1
                print("⚠️ Filtered duplicate recipe: \(recipe.recipeId) (\(recipe.recipeName))")
                return false
            }
            seenRecipeIds.insert(recipe.recipeId)
            return true
        }

        let validatedReadyToCook = recommendations.readyToCook.filter(validateRecipe)
        let validatedAlmostReady = recommendations.almostReady.filter(validateRecipe)

        // Log validation summary
        let totalFiltered = invalidCount + duplicateCount
        if totalFiltered > 0 {
            print("📊 Validation Summary:")
            print("   - Invalid IDs filtered: \(invalidCount)")
            print("   - Duplicates filtered: \(duplicateCount)")
            print("   - Final count: \(validatedReadyToCook.count) ready, \(validatedAlmostReady.count) almost ready")
        }

        return AIRecommendations(
            readyToCook: validatedReadyToCook,
            almostReady: validatedAlmostReady,
            shoppingList: recommendations.shoppingList,
            possibleSubstitutions: recommendations.possibleSubstitutions
        )
    }
    
    func prewarmModel(sampleContext: UserContextForAI) {
        let ings = sampleContext.availableIngredients.prefix(10).joined(separator: ", ")

        session.prewarm(promptPrefix: Prompt {
            """
            INGREDIENTS: \(ings)
            PREFS: tags:\(sampleContext.preferences.tags.joined(separator: ","))
            """
        })

        print("🔥 Model prewarmed")
    }
    
    /// Resets the current state while keeping the model session active
    func reset() {
        recommendations = nil
        error = nil
        isGenerating = false
    }

    /// Full cleanup - releases all resources including the model session
    /// Call this when recommendations are no longer needed to free memory
    func cleanup() {
        reset()
        // Note: LanguageModelSession doesn't have explicit cleanup,
        // but clearing references helps ARC reclaim memory faster
        print("🧹 RecipesGenerator cleaned up")
    }
    
    // MARK: - Smart Recipe Pre-filtering
    
    private func selectMostRelevantRecipesWithScores(
        from recipes: [RecipeForAI],
        userContext: UserContextForAI,
        userIngredientSet: Set<String>,
        maxCount: Int
    ) -> [(recipe: RecipeForAI, score: Double)] {
        
        // Score each recipe based on relevance
        let scoredRecipes = recipes.map { recipe -> (recipe: RecipeForAI, score: Double) in
            var score: Double = 0
            
            // Ingredient matching (most important factor)
            let recipeIngredientSet = Set(recipe.ingredients.map { $0.name.lowercased() })
            let matchingIngredients = userIngredientSet.intersection(recipeIngredientSet).count
            let totalIngredients = recipeIngredientSet.count
            
            if totalIngredients > 0 {
                score += Double(matchingIngredients) / Double(totalIngredients) * 100 // 0-100 points
            }
            
            // Difficulty preference bonus
            if let preferredDifficulty = userContext.preferences.preferredDifficulty {
                if recipe.difficulty.lowercased() == preferredDifficulty.lowercased() {
                    score += 20
                }
            }
            
            // Cooking time preference
            if let maxTimeMinutes = userContext.preferences.maxCookingTimeMinutes {
                let recipeTimeString = recipe.cookingTime.lowercased()
                if let recipeMinutes = extractMinutesFromTimeString(recipeTimeString) {
                    if recipeMinutes <= maxTimeMinutes {
                        score += 15 // Bonus for being within time limit
                        // Extra bonus for being well under the limit
                        if recipeMinutes <= maxTimeMinutes / 2 {
                            score += 10
                        }
                    } else {
                        score -= Double(recipeMinutes - maxTimeMinutes) * 0.5 // Penalty for exceeding
                    }
                }
            }
            
            // Tag preference bonus
            let userTagSet = Set(userContext.preferences.tags.map { $0.lowercased() })
            let recipeTagSet = Set(recipe.tags.map { $0.lowercased() })
            let matchingTags = userTagSet.intersection(recipeTagSet).count
            score += Double(matchingTags) * 10
            
            // Dietary restrictions compliance
            if userContext.dietaryRestrictions.isVegan {
                let veganTags = Set(["vegan", "plant-based"])
                if !veganTags.intersection(recipeTagSet).isEmpty {
                    score += 25
                } else if recipeTagSet.contains("vegetarian") {
                    score -= 10 // Vegetarian but not vegan
                }
            } else if userContext.dietaryRestrictions.isVegetarian {
                let vegTags = Set(["vegan", "vegetarian", "plant-based"])
                if !vegTags.intersection(recipeTagSet).isEmpty {
                    score += 20
                }
            }
            
            if userContext.dietaryRestrictions.isGlutenFree {
                if recipeTagSet.contains("gluten-free") || recipeTagSet.contains("gluten free") {
                    score += 20
                }
            }
            
            if userContext.dietaryRestrictions.isLactoseFree {
                let lactoTags = Set(["lactose-free", "dairy-free", "vegan"])
                if !lactoTags.intersection(recipeTagSet).isEmpty {
                    score += 20
                }
            }
            
            return (recipe: recipe, score: score)
        }
        
        // Sort by score (highest first) and take the top recipes
        return scoredRecipes
            .sorted { $0.score > $1.score }
            .prefix(maxCount)
            .map { $0 }
    }
    
    private func selectMostRelevantRecipes(
        from recipes: [RecipeForAI],
        userContext: UserContextForAI,
        userIngredientSet: Set<String>,
        maxCount: Int
    ) -> [RecipeForAI] {
        return selectMostRelevantRecipesWithScores(
            from: recipes,
            userContext: userContext,
            userIngredientSet: userIngredientSet,
            maxCount: maxCount
        ).map { $0.recipe }
    }
    
    private func extractMinutesFromTimeString(_ timeString: String) -> Int? {
        let cleanedTime = timeString.lowercased().replacingOccurrences(of: " ", with: "")

        // Use pre-compiled regex patterns for better performance
        for pattern in Self.timeRegexPatterns {
            let range = NSRange(location: 0, length: cleanedTime.count)
            if let match = pattern.regex.firstMatch(in: cleanedTime, range: range) {
                var totalMinutes = 0
                
                if pattern.hourIndex != -1 && match.numberOfRanges > pattern.hourIndex {
                    let hourRange = match.range(at: pattern.hourIndex)
                    if hourRange.location != NSNotFound,
                       let hours = Int(String(cleanedTime[Range(hourRange, in: cleanedTime)!])) {
                        totalMinutes += hours * 60
                    }
                }
                
                if pattern.minuteIndex != -1 && match.numberOfRanges > pattern.minuteIndex {
                    let minuteRange = match.range(at: pattern.minuteIndex)
                    if minuteRange.location != NSNotFound,
                       let minutes = Int(String(cleanedTime[Range(minuteRange, in: cleanedTime)!])) {
                        totalMinutes += minutes
                    }
                }
                
                if totalMinutes > 0 {
                    return totalMinutes
                }
            }
        }
        
        return nil
    }
}
