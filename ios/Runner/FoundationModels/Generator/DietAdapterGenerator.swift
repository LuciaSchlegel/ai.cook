//
//  DietAdapterGenerator.swift
//  Runner
//
//  Smart recipe diet adaptation using Apple Intelligence
//  Uses structured output for accurate dietary modifications
//

import Foundation
import FoundationModels
import Observation

// MARK: - Input Models

struct DietAdaptationRequest: Codable {
    let recipeName: String
    let ingredients: [String]
    let dietaryNeeds: [String]  // e.g., ["vegan", "gluten-free", "low-sodium"]
}

// MARK: - Output Models (Structured with @Generable)

@Generable
struct DietAdaptationResult {
    @Guide(description: "The original recipe name")
    let originalRecipe: String

    @Guide(description: "The dietary requirements being addressed")
    let dietaryNeeds: [String]

    @Guide(description: "List of ingredient modifications")
    let modifications: [IngredientModification]

    @Guide(description: "General tips for this dietary adaptation")
    let tips: String
}

@Generable
struct IngredientModification {
    @Guide(description: "The original ingredient to replace")
    let original: String

    @Guide(description: "The suggested replacement ingredient")
    let replacement: String

    @Guide(description: "Brief note about the substitution")
    let notes: String
}

// MARK: - Generator

@Observable
@MainActor
final class DietAdapterGenerator {

    var error: Error?
    private var session: LanguageModelSession?

    private(set) var result: DietAdaptationResult?
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
        // Only initialize session if available
        guard DietAdapterGenerator.isAvailable else {
            print("⚠️ Apple Intelligence not available on this device")
            return
        }

        if #available(iOS 26.0, *) {
            let instructions = Instructions {
                """
                You are a nutrition and dietary expert. Adapt recipes for specific dietary needs.

                For each ingredient modification provide:
                - original: The ingredient being replaced
                - replacement: The dietary-compliant alternative
                - notes: Brief explanation of the swap

                Focus on practical, accessible substitutions that maintain flavor and texture.
                """
            }
            self.session = LanguageModelSession(instructions: instructions)
        }
    }

    func adaptRecipe(request: DietAdaptationRequest) async {
        guard !request.recipeName.isEmpty && !request.ingredients.isEmpty else {
            self.error = NSError(
                domain: "DietAdapterGenerator",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Recipe name and ingredients are required"]
            )
            return
        }

        guard !request.dietaryNeeds.isEmpty else {
            self.error = NSError(
                domain: "DietAdapterGenerator",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "At least one dietary requirement is needed"]
            )
            return
        }

        guard #available(iOS 26.0, *) else {
            self.error = NSError(
                domain: "DietAdapterGenerator",
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
                domain: "DietAdapterGenerator",
                code: -3,
                userInfo: [NSLocalizedDescriptionKey: "This device is not eligible for Apple Intelligence. Apple Intelligence requires iPhone 15 Pro, iPhone 16, or newer."]
            )
            return
        case .unavailable(.appleIntelligenceNotEnabled):
            self.error = NSError(
                domain: "DietAdapterGenerator",
                code: -3,
                userInfo: [NSLocalizedDescriptionKey: "Apple Intelligence is not enabled. Please enable it in Settings > Apple Intelligence & Siri."]
            )
            return
        case .unavailable(.modelNotReady):
            self.error = NSError(
                domain: "DietAdapterGenerator",
                code: -3,
                userInfo: [NSLocalizedDescriptionKey: "Apple Intelligence model is still downloading or not ready. Please try again later."]
            )
            return
        case .unavailable(let reason):
            self.error = NSError(
                domain: "DietAdapterGenerator",
                code: -3,
                userInfo: [NSLocalizedDescriptionKey: "Apple Intelligence is unavailable: \(reason)"]
            )
            return
        }

        // Initialize or reinitialize session if needed
        if self.session == nil {
            let instructions = Instructions {
                """
                You are a nutrition and dietary expert. Adapt recipes for specific dietary needs.

                For each ingredient modification provide:
                - original: The ingredient being replaced
                - replacement: The dietary-compliant alternative
                - notes: Brief explanation of the swap

                Focus on practical, accessible substitutions that maintain flavor and texture.
                """
            }
            self.session = LanguageModelSession(instructions: instructions)
            print("🔄 Initialized new session for diet adaptation")
        }

        guard let session = self.session else {
            self.error = NSError(
                domain: "DietAdapterGenerator",
                code: -4,
                userInfo: [NSLocalizedDescriptionKey: "Failed to initialize AI session"]
            )
            return
        }

        // Check if session is already responding
        if session.isResponding {
            self.error = NSError(
                domain: "DietAdapterGenerator",
                code: -6,
                userInfo: [NSLocalizedDescriptionKey: "A request is already in progress. Please wait."]
            )
            return
        }

        isGenerating = true
        error = nil

        do {
            let prompt = buildPrompt(request: request)

            print("🥗 Adapting recipe: \(request.recipeName) for \(request.dietaryNeeds.joined(separator: ", "))")
            print("📝 Prompt: \(prompt)")
            let startTime = Date()

            let response = try await session.respond(
                to: prompt,
                generating: DietAdaptationResult.self
            )

            self.result = response.content

            let elapsed = Date().timeIntervalSince(startTime)
            print("✅ Diet adaptation completed in \(String(format: "%.2f", elapsed))s")

            // Log results
            if let result = self.result {
                print("\n🥗 DIET ADAPTATION for '\(result.originalRecipe)':")
                print("==================================================")
                print("Dietary needs: \(result.dietaryNeeds.joined(separator: ", "))")
                for mod in result.modifications {
                    print("  → \(mod.original) → \(mod.replacement)")
                    print("    \(mod.notes)")
                }
                print("💡 Tips: \(result.tips)")
                print("==================================================")
            }

        } catch let error as LanguageModelSession.GenerationError {
            print("❌ Generation error: \(error)")

            let errorMessage: String
            let errorDescription = error.localizedDescription.lowercased()

            if errorDescription.contains("context") || errorDescription.contains("window") || errorDescription.contains("size") {
                errorMessage = "The request is too large. Try with fewer ingredients."
            } else if errorDescription.contains("unavailable") || errorDescription.contains("not available") {
                errorMessage = "Apple Intelligence model is unavailable. Please check Settings > Apple Intelligence & Siri."
            } else {
                let nsError = error as NSError
                if let underlyingErrors = nsError.userInfo[NSMultipleUnderlyingErrorsKey] as? [NSError] {
                    for underlyingError in underlyingErrors {
                        print("   Underlying error: \(underlyingError)")
                        if underlyingError.domain == "ModelManagerServices.ModelManagerError" {
                            let modelErrorMessage = "The AI model failed to initialize. This may be temporary - please try again in a few moments. If the problem persists, restart your device."
                            self.error = NSError(
                                domain: "DietAdapterGenerator",
                                code: -5,
                                userInfo: [NSLocalizedDescriptionKey: modelErrorMessage]
                            )
                            isGenerating = false
                            return
                        }
                    }
                }
                errorMessage = "Failed to adapt recipe: \(error.localizedDescription)"
            }

            self.error = NSError(
                domain: "DietAdapterGenerator",
                code: -5,
                userInfo: [NSLocalizedDescriptionKey: errorMessage]
            )
        } catch {
            print("❌ Unexpected error: \(error)")

            let nsError = error as NSError
            if let underlyingErrors = nsError.userInfo[NSMultipleUnderlyingErrorsKey] as? [NSError] {
                for underlyingError in underlyingErrors {
                    print("   Underlying error: \(underlyingError)")
                    if underlyingError.domain == "ModelManagerServices.ModelManagerError" {
                        let modelErrorMessage = "The AI model failed to initialize. This may be temporary - please try again in a few moments. If the problem persists, restart your device."
                        self.error = NSError(
                            domain: "DietAdapterGenerator",
                            code: -5,
                            userInfo: [NSLocalizedDescriptionKey: modelErrorMessage]
                        )
                        isGenerating = false
                        return
                    }
                }
            }

            self.error = NSError(
                domain: "DietAdapterGenerator",
                code: -5,
                userInfo: [NSLocalizedDescriptionKey: "Unexpected error: \(error.localizedDescription)"]
            )
        }

        isGenerating = false
    }

    private func buildPrompt(request: DietAdaptationRequest) -> String {
        let ingredientsList = request.ingredients.joined(separator: ", ")
        let dietaryList = request.dietaryNeeds.joined(separator: ", ")

        return """
        Adapt the recipe "\(request.recipeName)" for these dietary needs: \(dietaryList).

        Current ingredients: \(ingredientsList)

        Identify which ingredients need to be replaced and suggest appropriate alternatives. Only include modifications for ingredients that actually need to change.
        """
    }

    func prewarmModel() {
        guard #available(iOS 26.0, *) else {
            print("⚠️ iOS 26+ required for Apple Intelligence")
            return
        }

        switch SystemLanguageModel.default.availability {
        case .available:
            break
        case .unavailable(let reason):
            print("⚠️ Cannot prewarm: Model unavailable - \(reason)")
            return
        }

        Task { @MainActor in
            do {
                if self.session == nil {
                    let instructions = Instructions {
                        """
                        You are a nutrition and dietary expert. Adapt recipes for specific dietary needs.

                        For each ingredient modification provide:
                        - original: The ingredient being replaced
                        - replacement: The dietary-compliant alternative
                        - notes: Brief explanation of the swap

                        Focus on practical, accessible substitutions that maintain flavor and texture.
                        """
                    }
                    self.session = LanguageModelSession(instructions: instructions)
                    print("🔄 Session initialized during prewarm")
                }

                guard let session = self.session else {
                    print("⚠️ Failed to initialize session for prewarming")
                    return
                }

                print("🔥 Prewarming Diet Adapter model...")
                _ = try await session.respond(to: "Make a basic pasta recipe vegan")
                print("✅ Diet Adapter model prewarmed successfully")
            } catch {
                print("⚠️ Diet Adapter prewarm failed (non-critical): \(error.localizedDescription)")
                self.session = nil
            }
        }
    }

    func cleanup() {
        result = nil
        error = nil
        isGenerating = false
        print("🧹 DietAdapterGenerator cleaned up")
    }
}
