//
//  FoundationModelsChannel.swift
//  Runner
//
//  Created by Lucia Schlegel on 02.11.25.
//

import Flutter
import UIKit
import Foundation

class FoundationModelsChannel {

    private var recipesGeneratorClean: RecipesGeneratorClean?
    private var chatAssistant: ChatAssistantGenerator?

    func registerWith(controller: FlutterViewController) {
        let channel = FlutterMethodChannel(
            name: "ai.cook/foundation_models",
            binaryMessenger: controller.binaryMessenger
        )

        channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            guard let self = self else {
                result(FlutterError(
                    code: "UNAVAILABLE",
                    message: "Generator unavailable",
                    details: nil
                ))
                return
            }

            switch call.method {
            case "generateRecommendationsClean":
                Task {
                    await self.handleGenerateRecommendationsClean(call: call, result: result)
                }

            case "prewarmModel":
                Task {
                    await self.handlePrewarmModel(result: result)
                }

            case "chatSendMessage":
                Task {
                    await self.handleChatSendMessage(call: call, result: result)
                }

            case "chatPrewarm":
                Task {
                    await self.handleChatPrewarm(result: result)
                }

            case "chatClearHistory":
                Task {
                    await self.handleChatClearHistory(result: result)
                }

            case "cleanup":
                Task {
                    await self.handleCleanup(result: result)
                }

            default:
                result(FlutterMethodNotImplemented)
            }
        }

        print("✅ Foundation Models channel registered")
    }

    @MainActor
    private func handleGenerateRecommendationsClean(
        call: FlutterMethodCall,
        result: @escaping FlutterResult
    ) async {
        guard let args = call.arguments as? [String: Any],
              let readyToCookData = args["readyToCook"] as? [[String: Any]],
              let almostReadyData = args["almostReady"] as? [[String: Any]],
              let userContextData = args["userContext"] as? [String: Any] else {
            print("❌ Invalid arguments for clean approach")
            result(FlutterError(
                code: "INVALID_ARGUMENTS",
                message: "Invalid arguments: expected readyToCook, almostReady, and userContext",
                details: nil
            ))
            return
        }

        // Initialize clean generator if needed
        if recipesGeneratorClean == nil {
            recipesGeneratorClean = RecipesGeneratorClean()
        }

        guard let generator = recipesGeneratorClean else {
            result(FlutterError(
                code: "INITIALIZATION_ERROR",
                message: "Failed to initialize clean recipes generator",
                details: nil
            ))
            return
        }

        print("📱 Received CLEAN request from Flutter:")
        print("   - Ready to Cook: \(readyToCookData.count)")
        print("   - Almost Ready: \(almostReadyData.count)")

        do {
            // Parse the pre-computed data
            let preComputedDataDict: [String: Any] = [
                "readyToCook": readyToCookData,
                "almostReady": almostReadyData,
                "userContext": userContextData
            ]

            let preComputedJsonData = try JSONSerialization.data(withJSONObject: preComputedDataDict)
            let preComputedData = try JSONDecoder().decode(PreComputedData.self, from: preComputedJsonData)

            print("✅ Parsed pre-computed data")

            // Enrich recipes with AI-generated language
            print("🤖 Starting AI enrichment (language generation only)...")
            let startTime = Date()

            await generator.enrichRecipes(preComputedData: preComputedData)

            let elapsed = Date().timeIntervalSince(startTime)
            print("⏱️ Enrichment took \(String(format: "%.2f", elapsed))s")

            // Check for errors
            if let error = generator.error {
                print("❌ Enrichment error: \(error.localizedDescription)")
                result(FlutterError(
                    code: "GENERATION_ERROR",
                    message: "Failed to enrich: \(error.localizedDescription)",
                    details: nil
                ))
                return
            }

            // Get enriched recommendations
            guard let enriched = generator.enrichedRecommendations else {
                print("❌ No enriched recommendations generated")
                result(FlutterError(
                    code: "NO_RESULTS",
                    message: "No enriched recommendations generated",
                    details: nil
                ))
                return
            }

            print("✅ Generated enriched recommendations:")
            print("   - Ready to cook: \(enriched.readyToCook.count)")
            print("   - Almost ready: \(enriched.almostReady.count)")

            // Combine pre-computed data with AI enrichments
            let flutterFormat = try buildCleanResponse(
                preComputedData: preComputedData,
                enrichments: enriched
            )

            let resultString = String(data: flutterFormat, encoding: .utf8)

            print("📤 Sending enriched result back to Flutter")
            result(resultString)

        } catch let decodingError as DecodingError {
            print("❌ Decoding error: \(decodingError)")
            result(FlutterError(
                code: "DECODING_ERROR",
                message: "Failed to decode: \(decodingError.localizedDescription)",
                details: "\(decodingError)"
            ))
        } catch {
            print("❌ Processing error: \(error)")
            result(FlutterError(
                code: "PROCESSING_ERROR",
                message: "Failed to process: \(error.localizedDescription)",
                details: "\(error)"
            ))
        }
    }

    /// Build response combining pre-computed data with AI enrichments
    private func buildCleanResponse(
        preComputedData: PreComputedData,
        enrichments: EnrichedRecommendations
    ) throws -> Data {
        // Create lookup for enrichments by recipe ID
        let readyEnrichments = Dictionary(uniqueKeysWithValues: enrichments.readyToCook.map { ($0.recipeId, $0) })
        let almostEnrichments = Dictionary(uniqueKeysWithValues: enrichments.almostReady.map { ($0.recipeId, $0) })

        func enrichRecipe(_ recipe: PreComputedRecipe, _ enrichment: RecipeEnrichment?) -> [String: Any] {
            return [
                "id": recipe.id,
                "title": recipe.name,
                "time_minutes": extractTimeMinutes(from: recipe.cookingTime),
                "difficulty": recipe.difficulty,
                "tags": recipe.tags,
                "match_score": recipe.matchScore,
                "description": enrichment?.reasoning ?? "Great recipe match!",
                "ingredients": recipe.matchingIngredients.map { ["name": $0, "quantity": ""] },
                "steps": enrichment?.cookingTips ?? [],
                "missing_ingredients": recipe.missingIngredients,
                "recipe_substitutions": enrichment?.substitutions.map { sub in
                    return [
                        "original": sub.original,
                        "alternatives": sub.alternatives
                    ]
                } ?? []
            ]
        }

        let flutterData: [String: Any] = [
            "ready_to_cook": preComputedData.readyToCook.map { recipe in
                enrichRecipe(recipe, readyEnrichments[recipe.id])
            },
            "almost_ready": preComputedData.almostReady.map { recipe in
                enrichRecipe(recipe, almostEnrichments[recipe.id])
            },
            "shopping_suggestions": [],  // Not used in clean approach
            "possible_substitutions": []  // Already in recipe-specific substitutions
        ]

        return try JSONSerialization.data(withJSONObject: flutterData, options: [.prettyPrinted])
    }

    @MainActor
    private func handlePrewarmModel(result: @escaping FlutterResult) async {
        print("🔥 Prewarm model requested")

        // Initialize clean generator if needed
        if recipesGeneratorClean == nil {
            recipesGeneratorClean = RecipesGeneratorClean()
        }

        guard let generator = recipesGeneratorClean else {
            result(FlutterError(
                code: "INITIALIZATION_ERROR",
                message: "Failed to initialize generator",
                details: nil
            ))
            return
        }

        // Call prewarm (it runs asynchronously, so we return immediately)
        generator.prewarmModel()

        result(true)
    }

    // MARK: - Chat Assistant Handlers

    @MainActor
    private func handleChatSendMessage(call: FlutterMethodCall, result: @escaping FlutterResult) async {
        guard let args = call.arguments as? [String: Any],
              let message = args["message"] as? String else {
            print("❌ Invalid arguments for chat send message")
            result(FlutterError(
                code: "INVALID_ARGUMENTS",
                message: "Expected 'message' parameter",
                details: nil
            ))
            return
        }

        // Initialize chat assistant if needed
        if chatAssistant == nil {
            chatAssistant = ChatAssistantGenerator()
        }

        guard let assistant = chatAssistant else {
            result(FlutterError(
                code: "INITIALIZATION_ERROR",
                message: "Failed to initialize chat assistant",
                details: nil
            ))
            return
        }

        print("💬 Processing chat message: \(message)")

        // Send message and get response
        let response = await assistant.sendMessage(message)

        print("✅ Chat response generated")
        result(response)
    }

    @MainActor
    private func handleChatPrewarm(result: @escaping FlutterResult) async {
        print("🔥 Chat prewarm requested")

        // Initialize chat assistant if needed
        if chatAssistant == nil {
            chatAssistant = ChatAssistantGenerator()
        }

        guard let assistant = chatAssistant else {
            result(FlutterError(
                code: "INITIALIZATION_ERROR",
                message: "Failed to initialize chat assistant",
                details: nil
            ))
            return
        }

        // Call prewarm (runs asynchronously)
        assistant.prewarmModel()

        result(true)
    }

    @MainActor
    private func handleChatClearHistory(result: @escaping FlutterResult) async {
        print("🧹 Clearing chat history...")

        guard let assistant = chatAssistant else {
            // No assistant initialized, nothing to clear
            result(true)
            return
        }

        assistant.clearHistory()
        result(true)
    }

    @MainActor
    private func handleCleanup(result: @escaping FlutterResult) async {
        print("🧹 Cleaning up Foundation Models resources...")

        if let cleanGenerator = recipesGeneratorClean {
            cleanGenerator.cleanup()
        }

        if let assistant = chatAssistant {
            assistant.cleanup()
        }

        // Release instances to free memory
        recipesGeneratorClean = nil
        chatAssistant = nil

        print("✅ Cleanup complete")
        result(true)
    }

    /// Enriches AI recommendations with full recipe data and converts to Flutter format
    private func enrichForFlutter(
        recommendations: AIRecommendations,
        recipes: [RecipeForAI]
    ) throws -> Data {
        // Create lookup for fast access
        let recipeLookup = Dictionary(uniqueKeysWithValues: recipes.map { ($0.id, $0) })

        func enrichRecipe(_ rec: AIRecommendations.RecommendedRecipe) -> [String: Any]? {
            guard let fullRecipe = recipeLookup[rec.recipeId] else {
                print("⚠️ Skipping recipe \(rec.recipeId) - not found in dataset")
                return nil
            }

            return [
                "id": rec.recipeId,
                "title": rec.recipeName,
                "time_minutes": extractTimeMinutes(from: fullRecipe.cookingTime),
                "difficulty": fullRecipe.difficulty,
                "tags": fullRecipe.tags,
                "description": rec.reasoning,
                "match_score": rec.matchScore,
                "ingredients": fullRecipe.ingredients.map { ing in
                    return [
                        "name": ing.name,
                        "quantity": "\(ing.quantity) \(ing.unit)"
                    ]
                },
                "steps": rec.cookingTips,
                "missing_ingredients": rec.missingIngredients,
                "recipe_substitutions": rec.suggestedSubstitutions.map { sub in
                    return [
                        "original": sub.original,
                        "alternatives": sub.alternatives
                    ]
                }
            ]
        }

        let flutterData: [String: Any] = [
            "ready_to_cook": recommendations.readyToCook.compactMap(enrichRecipe),
            "almost_ready": recommendations.almostReady.compactMap(enrichRecipe),
            "shopping_suggestions": recommendations.shoppingList.map { item in
                return [
                    "name": item.name,
                    "reason": item.reason
                ]
            },
            "possible_substitutions": recommendations.possibleSubstitutions.map { sub in
                return [
                    "original": sub.original,
                    "alternatives": sub.alternatives
                ]
            }
        ]

        return try JSONSerialization.data(withJSONObject: flutterData, options: [.prettyPrinted])
    }

    private func extractTimeMinutes(from timeString: String) -> Int {
        let cleanedTime = timeString.lowercased().replacingOccurrences(of: " ", with: "")

        // Try different patterns
        let patterns: [(regex: NSRegularExpression, hourIndex: Int, minuteIndex: Int)?] = [
            try? (NSRegularExpression(pattern: #"(\d+)h(?:our)?(?:s)?(\d+)?m"#), 1, 2),
            try? (NSRegularExpression(pattern: #"(\d+)m(?:in)?(?:s)?"#), -1, 1),
            try? (NSRegularExpression(pattern: #"(\d+)h(?:our)?(?:s)?"#), 1, -1)
        ]

        for pattern in patterns.compactMap({ $0 }) {
            let range = NSRange(location: 0, length: cleanedTime.utf16.count)
            if let match = pattern.regex.firstMatch(in: cleanedTime, range: range) {
                var totalMinutes = 0

                if pattern.hourIndex != -1 && match.numberOfRanges > pattern.hourIndex {
                    let hourRange = match.range(at: pattern.hourIndex)
                    if hourRange.location != NSNotFound,
                       let substring = Range(hourRange, in: cleanedTime),
                       let hours = Int(cleanedTime[substring]) {
                        totalMinutes += hours * 60
                    }
                }

                if pattern.minuteIndex != -1 && match.numberOfRanges > pattern.minuteIndex {
                    let minuteRange = match.range(at: pattern.minuteIndex)
                    if minuteRange.location != NSNotFound,
                       let substring = Range(minuteRange, in: cleanedTime),
                       let minutes = Int(cleanedTime[substring]) {
                        totalMinutes += minutes
                    }
                }

                if totalMinutes > 0 {
                    return totalMinutes
                }
            }
        }

        return 0
    }
}
