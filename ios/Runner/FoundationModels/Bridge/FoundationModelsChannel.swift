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
    private var substitutionsGenerator: SubstitutionsGenerator?
    private var unitConverterGenerator: UnitConverterGenerator?
    private var dietAdapterGenerator: DietAdapterGenerator?

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

            case "generateSubstitutions":
                Task {
                    await self.handleGenerateSubstitutions(call: call, result: result)
                }

            case "convertUnits":
                Task {
                    await self.handleConvertUnits(call: call, result: result)
                }

            case "adaptDiet":
                Task {
                    await self.handleAdaptDiet(call: call, result: result)
                }

            case "prewarmModel":
                Task {
                    await self.handlePrewarmModel(result: result)
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

    // MARK: - Substitutions Handler

    @MainActor
    private func handleGenerateSubstitutions(
        call: FlutterMethodCall,
        result: @escaping FlutterResult
    ) async {
        guard let args = call.arguments as? [String: Any],
              let ingredient = args["ingredient"] as? String else {
            print("❌ Invalid arguments for substitutions")
            result(FlutterError(
                code: "INVALID_ARGUMENTS",
                message: "Expected 'ingredient' parameter",
                details: nil
            ))
            return
        }

        // Initialize generator if needed
        if substitutionsGenerator == nil {
            substitutionsGenerator = SubstitutionsGenerator()
        }

        guard let generator = substitutionsGenerator else {
            result(FlutterError(
                code: "INITIALIZATION_ERROR",
                message: "Failed to initialize substitutions generator",
                details: nil
            ))
            return
        }

        print("🔄 Generating substitutions for: \(ingredient)")

        // Parse optional context
        var context: SubstitutionRequest.SubstitutionContext? = nil
        if let contextData = args["context"] as? [String: Any] {
            context = SubstitutionRequest.SubstitutionContext(
                recipeName: contextData["recipeName"] as? String,
                dietaryRestrictions: contextData["dietaryRestrictions"] as? [String],
                availableIngredients: contextData["availableIngredients"] as? [String]
            )
        }

        let request = SubstitutionRequest(ingredient: ingredient, context: context)

        await generator.generateSubstitutions(request: request)

        // Check for errors
        if let error = generator.error {
            print("❌ Substitution error: \(error.localizedDescription)")
            result(FlutterError(
                code: "GENERATION_ERROR",
                message: "Failed to generate substitutions: \(error.localizedDescription)",
                details: nil
            ))
            return
        }

        // Get result
        guard let substitutionResult = generator.result else {
            print("❌ No substitution result generated")
            result(FlutterError(
                code: "NO_RESULTS",
                message: "No substitutions generated",
                details: nil
            ))
            return
        }

        // Convert to Flutter format
        let flutterData: [String: Any] = [
            "original_ingredient": substitutionResult.originalIngredient,
            "substitutes": substitutionResult.substitutes.map { sub in
                return [
                    "name": sub.name,
                    "ratio": sub.ratio,
                    "notes": sub.notes
                ]
            },
            "tips": substitutionResult.tips
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: flutterData, options: [.prettyPrinted])
            let jsonString = String(data: jsonData, encoding: .utf8)
            print("📤 Sending substitutions back to Flutter")
            result(jsonString)
        } catch {
            result(FlutterError(
                code: "SERIALIZATION_ERROR",
                message: "Failed to serialize result: \(error.localizedDescription)",
                details: nil
            ))
        }
    }

    // MARK: - Unit Converter Handler

    @MainActor
    private func handleConvertUnits(
        call: FlutterMethodCall,
        result: @escaping FlutterResult
    ) async {
        guard let args = call.arguments as? [String: Any],
              let amount = args["amount"] as? String,
              let fromUnit = args["fromUnit"] as? String else {
            print("❌ Invalid arguments for unit conversion")
            result(FlutterError(
                code: "INVALID_ARGUMENTS",
                message: "Expected 'amount' and 'fromUnit' parameters",
                details: nil
            ))
            return
        }

        // Initialize generator if needed
        if unitConverterGenerator == nil {
            unitConverterGenerator = UnitConverterGenerator()
        }

        guard let generator = unitConverterGenerator else {
            result(FlutterError(
                code: "INITIALIZATION_ERROR",
                message: "Failed to initialize unit converter generator",
                details: nil
            ))
            return
        }

        print("⚖️ Converting: \(amount) \(fromUnit)")

        // Parse optional parameters
        let toUnit = args["toUnit"] as? String
        let ingredient = args["ingredient"] as? String

        let request = ConversionRequest(
            amount: amount,
            fromUnit: fromUnit,
            toUnit: toUnit,
            ingredient: ingredient
        )

        await generator.convert(request: request)

        // Check for errors
        if let error = generator.error {
            print("❌ Conversion error: \(error.localizedDescription)")
            result(FlutterError(
                code: "GENERATION_ERROR",
                message: "Failed to convert: \(error.localizedDescription)",
                details: nil
            ))
            return
        }

        // Get result
        guard let conversionResult = generator.result else {
            print("❌ No conversion result generated")
            result(FlutterError(
                code: "NO_RESULTS",
                message: "No conversions generated",
                details: nil
            ))
            return
        }

        // Convert to Flutter format
        let flutterData: [String: Any] = [
            "original": conversionResult.original,
            "conversions": conversionResult.conversions.map { conv in
                return [
                    "measurement": conv.measurement,
                    "unit_type": conv.unitType
                ]
            },
            "tip": conversionResult.tip
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: flutterData, options: [.prettyPrinted])
            let jsonString = String(data: jsonData, encoding: .utf8)
            print("📤 Sending conversions back to Flutter")
            result(jsonString)
        } catch {
            result(FlutterError(
                code: "SERIALIZATION_ERROR",
                message: "Failed to serialize result: \(error.localizedDescription)",
                details: nil
            ))
        }
    }

    // MARK: - Diet Adapter Handler

    @MainActor
    private func handleAdaptDiet(
        call: FlutterMethodCall,
        result: @escaping FlutterResult
    ) async {
        guard let args = call.arguments as? [String: Any],
              let recipeName = args["recipeName"] as? String,
              let ingredients = args["ingredients"] as? [String],
              let dietaryNeeds = args["dietaryNeeds"] as? [String] else {
            print("❌ Invalid arguments for diet adaptation")
            result(FlutterError(
                code: "INVALID_ARGUMENTS",
                message: "Expected 'recipeName', 'ingredients', and 'dietaryNeeds' parameters",
                details: nil
            ))
            return
        }

        // Initialize generator if needed
        if dietAdapterGenerator == nil {
            dietAdapterGenerator = DietAdapterGenerator()
        }

        guard let generator = dietAdapterGenerator else {
            result(FlutterError(
                code: "INITIALIZATION_ERROR",
                message: "Failed to initialize diet adapter generator",
                details: nil
            ))
            return
        }

        print("🥗 Adapting recipe: \(recipeName) for \(dietaryNeeds.joined(separator: ", "))")

        let request = DietAdaptationRequest(
            recipeName: recipeName,
            ingredients: ingredients,
            dietaryNeeds: dietaryNeeds
        )

        await generator.adaptRecipe(request: request)

        // Check for errors
        if let error = generator.error {
            print("❌ Diet adaptation error: \(error.localizedDescription)")
            result(FlutterError(
                code: "GENERATION_ERROR",
                message: "Failed to adapt recipe: \(error.localizedDescription)",
                details: nil
            ))
            return
        }

        // Get result
        guard let adaptationResult = generator.result else {
            print("❌ No adaptation result generated")
            result(FlutterError(
                code: "NO_RESULTS",
                message: "No adaptations generated",
                details: nil
            ))
            return
        }

        // Convert to Flutter format
        let flutterData: [String: Any] = [
            "original_recipe": adaptationResult.originalRecipe,
            "dietary_needs": adaptationResult.dietaryNeeds,
            "modifications": adaptationResult.modifications.map { mod in
                return [
                    "original": mod.original,
                    "replacement": mod.replacement,
                    "notes": mod.notes
                ]
            },
            "tips": adaptationResult.tips
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: flutterData, options: [.prettyPrinted])
            let jsonString = String(data: jsonData, encoding: .utf8)
            print("📤 Sending diet adaptations back to Flutter")
            result(jsonString)
        } catch {
            result(FlutterError(
                code: "SERIALIZATION_ERROR",
                message: "Failed to serialize result: \(error.localizedDescription)",
                details: nil
            ))
        }
    }

    @MainActor
    private func handlePrewarmModel(result: @escaping FlutterResult) async {
        print("🔥 Prewarm model requested")

        // Initialize generators if needed
        if recipesGeneratorClean == nil {
            recipesGeneratorClean = RecipesGeneratorClean()
        }
        if substitutionsGenerator == nil {
            substitutionsGenerator = SubstitutionsGenerator()
        }
        if unitConverterGenerator == nil {
            unitConverterGenerator = UnitConverterGenerator()
        }
        if dietAdapterGenerator == nil {
            dietAdapterGenerator = DietAdapterGenerator()
        }

        // Prewarm all generators
        recipesGeneratorClean?.prewarmModel()
        substitutionsGenerator?.prewarmModel()
        unitConverterGenerator?.prewarmModel()
        dietAdapterGenerator?.prewarmModel()

        result(true)
    }

    @MainActor
    private func handleCleanup(result: @escaping FlutterResult) async {
        print("🧹 Cleaning up Foundation Models resources...")

        recipesGeneratorClean?.cleanup()
        substitutionsGenerator?.cleanup()
        unitConverterGenerator?.cleanup()
        dietAdapterGenerator?.cleanup()

        // Release instances to free memory
        recipesGeneratorClean = nil
        substitutionsGenerator = nil
        unitConverterGenerator = nil
        dietAdapterGenerator = nil

        print("✅ Cleanup complete")
        result(true)
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
