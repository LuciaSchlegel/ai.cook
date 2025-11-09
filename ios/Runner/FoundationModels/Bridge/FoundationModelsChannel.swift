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
    
    private var recipesGenerator: RecipesGenerator?
    
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
            case "generateRecommendations":
                Task {
                    await self.handleGenerateRecommendations(call: call, result: result)
                }

            case "prewarmModel":
                Task {
                    await self.handlePrewarmModel(call: call, result: result)
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
    private func handleGenerateRecommendations(
        call: FlutterMethodCall,
        result: @escaping FlutterResult
    ) async {
        guard let args = call.arguments as? [String: Any],
              let recipesData = args["recipes"] as? [[String: Any]],
              let userContextData = args["userContext"] as? [String: Any] else {
            print("❌ Invalid arguments received")
            result(FlutterError(
                code: "INVALID_ARGUMENTS",
                message: "Invalid arguments: expected recipes and userContext",
                details: nil
            ))
            return
        }
        
        // Initialize generator if needed (on main actor)
        if recipesGenerator == nil {
            recipesGenerator = RecipesGenerator()
        }
        
        guard let generator = recipesGenerator else {
            result(FlutterError(
                code: "INITIALIZATION_ERROR",
                message: "Failed to initialize recipes generator",
                details: nil
            ))
            return
        }
        
        print("📱 Received request from Flutter:")
        print("   - Recipes: \(recipesData.count)")
        print("   - User context keys: \(userContextData.keys.joined(separator: ", "))")
        
        do {
            // Parse recipes
            let recipesJsonData = try JSONSerialization.data(withJSONObject: recipesData)
            let recipes = try JSONDecoder().decode([RecipeForAI].self, from: recipesJsonData)
            
            print("✅ Parsed \(recipes.count) recipes")
            
            // Parse user context
            let contextJsonData = try JSONSerialization.data(withJSONObject: userContextData)
            let userContext = try JSONDecoder().decode(UserContextForAI.self, from: contextJsonData)
            
            print("✅ Parsed user context:")
            print("   - Available ingredients: \(userContext.availableIngredients.count)")
            print("   - Preferred tags: \(userContext.preferences.tags.joined(separator: ", "))")
            
            // Generate recommendations using Foundation Models
            print("🤖 Starting Foundation Models generation...")
            let startTime = Date()
            
            await generator.generateRecommendations(
                recipes: recipes,
                userContext: userContext
            )
            
            let elapsed = Date().timeIntervalSince(startTime)
            print("⏱️ Generation took \(String(format: "%.2f", elapsed))s")
            
            // Check for errors
            if let error = generator.error {
                print("❌ Generation error: \(error.localizedDescription)")
                result(FlutterError(
                    code: "GENERATION_ERROR",
                    message: "Failed to generate: \(error.localizedDescription)",
                    details: nil
                ))
                return
            }
            
            // Get recommendations
            guard let recommendations = generator.recommendations else {
                print("❌ No recommendations generated")
                result(FlutterError(
                    code: "NO_RESULTS",
                    message: "No recommendations generated",
                    details: nil
                ))
                return
            }
            
            print("✅ Generated recommendations:")
            print("   - Ready to cook: \(recommendations.readyToCook.count)")
            print("   - Almost ready: \(recommendations.almostReady.count)")
            print("   - Shopping suggestions: \(recommendations.shoppingList.count)")

            // Enrich with full recipe data and convert to Flutter format
            let flutterFormat = try enrichForFlutter(
                recommendations: recommendations,
                recipes: recipes
            )

            let resultString = String(data: flutterFormat, encoding: .utf8)

            print("📤 Sending result back to Flutter")
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
    
    @MainActor
    private func handlePrewarmModel(
        call: FlutterMethodCall,
        result: @escaping FlutterResult
    ) async {
        guard let args = call.arguments as? [String: Any],
              let userContextData = args["userContext"] as? [String: Any] else {
            result(FlutterError(
                code: "INVALID_ARGUMENTS",
                message: "Invalid arguments for prewarm",
                details: nil
            ))
            return
        }

        do {
            let contextJsonData = try JSONSerialization.data(withJSONObject: userContextData)
            let userContext = try JSONDecoder().decode(UserContextForAI.self, from: contextJsonData)

            // Initialize generator if needed (on main actor)
            if recipesGenerator == nil {
                recipesGenerator = RecipesGenerator()
            }

            guard let generator = recipesGenerator else {
                result(FlutterError(
                    code: "INITIALIZATION_ERROR",
                    message: "Failed to initialize recipes generator",
                    details: nil
                ))
                return
            }

            print("🔥 Prewarming model...")
            generator.prewarmModel(sampleContext: userContext)
            print("✅ Model prewarmed")

            result(true)

        } catch {
            result(FlutterError(
                code: "PREWARM_ERROR",
                message: "Failed to prewarm: \(error.localizedDescription)",
                details: nil
            ))
        }
    }

    @MainActor
    private func handleCleanup(result: @escaping FlutterResult) async {
        print("🧹 Cleaning up Foundation Models resources...")

        if let generator = recipesGenerator {
            generator.cleanup()
        }

        // Release the generator instance to free memory
        recipesGenerator = nil

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
