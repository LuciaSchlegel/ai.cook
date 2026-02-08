//
//  SubstitutionsGenerator.swift
//  Runner
//
//  Smart ingredient substitutions using Apple Intelligence
//  Uses structured output to prevent hallucination
//

import Foundation
import FoundationModels
import Observation

// MARK: - Input Models

struct SubstitutionRequest: Codable {
    let ingredient: String
    let context: SubstitutionContext?

    struct SubstitutionContext: Codable {
        let recipeName: String?
        let dietaryRestrictions: [String]?
        let availableIngredients: [String]?
    }
}

// MARK: - Output Models (Simplified @Generable for reliability)

@Generable
struct SubstitutionResult {
    @Guide(description: "The ingredient being substituted")
    let originalIngredient: String

    @Guide(description: "List of 3-4 substitute options")
    let substitutes: [SubstituteOption]

    @Guide(description: "A brief tip about substituting this ingredient")
    let tips: String
}

@Generable
struct SubstituteOption {
    @Guide(description: "Name of the substitute ingredient")
    let name: String

    @Guide(description: "Conversion ratio like '1:1' or '1 cup = 3/4 cup'")
    let ratio: String

    @Guide(description: "Brief description of how it changes the dish")
    let notes: String
}

// MARK: - Generator

@Observable
@MainActor
final class SubstitutionsGenerator {

    var error: Error?
    private var session: LanguageModelSession?

    private(set) var result: SubstitutionResult?
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
        guard SubstitutionsGenerator.isAvailable else {
            print("⚠️ Apple Intelligence not available on this device")
            return
        }

        if #available(iOS 26.0, *) {
            let instructions = Instructions {
                """
                You are a culinary expert. Suggest practical ingredient substitutes.

                For each substitute provide:
                - name: The substitute ingredient
                - ratio: The conversion ratio (e.g., "1:1")
                - notes: Brief note about flavor/texture changes

                Keep responses concise and practical.
                """
            }
            self.session = LanguageModelSession(instructions: instructions)
        }
    }

    func generateSubstitutions(request: SubstitutionRequest) async {
        guard !request.ingredient.isEmpty else {
            self.error = NSError(
                domain: "SubstitutionsGenerator",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Ingredient name is required"]
            )
            return
        }

        guard #available(iOS 26.0, *) else {
            self.error = NSError(
                domain: "SubstitutionsGenerator",
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
                domain: "SubstitutionsGenerator",
                code: -3,
                userInfo: [NSLocalizedDescriptionKey: "This device is not eligible for Apple Intelligence. Apple Intelligence requires iPhone 15 Pro, iPhone 16, or newer."]
            )
            return
        case .unavailable(.appleIntelligenceNotEnabled):
            self.error = NSError(
                domain: "SubstitutionsGenerator",
                code: -3,
                userInfo: [NSLocalizedDescriptionKey: "Apple Intelligence is not enabled. Please enable it in Settings > Apple Intelligence & Siri."]
            )
            return
        case .unavailable(.modelNotReady):
            self.error = NSError(
                domain: "SubstitutionsGenerator",
                code: -3,
                userInfo: [NSLocalizedDescriptionKey: "Apple Intelligence model is still downloading or not ready. Please try again later."]
            )
            return
        case .unavailable(let reason):
            self.error = NSError(
                domain: "SubstitutionsGenerator",
                code: -3,
                userInfo: [NSLocalizedDescriptionKey: "Apple Intelligence is unavailable: \(reason)"]
            )
            return
        }

        // Initialize or reinitialize session if needed
        if self.session == nil {
            let instructions = Instructions {
                """
                You are a culinary expert. Suggest practical ingredient substitutes.

                For each substitute provide:
                - name: The substitute ingredient
                - ratio: The conversion ratio (e.g., "1:1")
                - notes: Brief note about flavor/texture changes

                Keep responses concise and practical.
                """
            }
            self.session = LanguageModelSession(instructions: instructions)
            
            print("🔄 Initialized new session for substitutions")
        }

        guard let session = self.session else {
            self.error = NSError(
                domain: "SubstitutionsGenerator",
                code: -4,
                userInfo: [NSLocalizedDescriptionKey: "Failed to initialize AI session"]
            )
            return
        }

        // Check if session is already responding
        if session.isResponding {
            self.error = NSError(
                domain: "SubstitutionsGenerator",
                code: -6,
                userInfo: [NSLocalizedDescriptionKey: "A request is already in progress. Please wait."]
            )
            return
        }

        isGenerating = true
        error = nil

        do {
            let prompt = buildPrompt(request: request)

            print("🔄 Generating substitutions for: \(request.ingredient)")
            print("📝 Prompt: \(prompt)")
            let startTime = Date()

            let response = try await session.respond(
                to: prompt,
                generating: SubstitutionResult.self
            )

            self.result = response.content

            let elapsed = Date().timeIntervalSince(startTime)
            print("✅ Substitutions generated in \(String(format: "%.2f", elapsed))s")

            // Log results
            if let result = self.result {
                print("\n🔄 SUBSTITUTION RESULTS for '\(result.originalIngredient)':")
                print("==================================================")
                for (index, sub) in result.substitutes.enumerated() {
                    print("  \(index + 1). \(sub.name) (\(sub.ratio))")
                    print("     \(sub.notes)")
                }
                print("💡 Tip: \(result.tips)")
                print("==================================================")
            }

        } catch let error as LanguageModelSession.GenerationError {
            print("❌ Generation error: \(error)")
            
            // Provide specific error messages based on error description
            let errorMessage: String
            let errorDescription = error.localizedDescription.lowercased()
            
            // Check error description for known patterns
            if errorDescription.contains("context") || errorDescription.contains("window") || errorDescription.contains("size") {
                errorMessage = "The request is too large. Try simplifying your request."
            } else if errorDescription.contains("unavailable") || errorDescription.contains("not available") {
                errorMessage = "Apple Intelligence model is unavailable. Please check Settings > Apple Intelligence & Siri."
            } else {
                // Check for ModelManagerError in underlying errors
                let nsError = error as NSError
                if let underlyingErrors = nsError.userInfo[NSMultipleUnderlyingErrorsKey] as? [NSError] {
                    for underlyingError in underlyingErrors {
                        print("   Underlying error: \(underlyingError)")
                        if underlyingError.domain == "ModelManagerServices.ModelManagerError" {
                            let modelErrorMessage = "The AI model failed to initialize. This may be temporary - please try again in a few moments. If the problem persists, restart your device."
                            self.error = NSError(
                                domain: "SubstitutionsGenerator",
                                code: -5,
                                userInfo: [NSLocalizedDescriptionKey: modelErrorMessage]
                            )
                            isGenerating = false
                            return
                        }
                    }
                }
                errorMessage = "Failed to generate substitutions: \(error.localizedDescription)"
            }

            self.error = NSError(
                domain: "SubstitutionsGenerator",
                code: -5,
                userInfo: [NSLocalizedDescriptionKey: errorMessage]
            )
        } catch {
            print("❌ Unexpected error generating substitutions: \(error)")
            
            // Check for ModelManagerError in any error
            let nsError = error as NSError
            if let underlyingErrors = nsError.userInfo[NSMultipleUnderlyingErrorsKey] as? [NSError] {
                for underlyingError in underlyingErrors {
                    print("   Underlying error: \(underlyingError)")
                    if underlyingError.domain == "ModelManagerServices.ModelManagerError" {
                        let modelErrorMessage = "The AI model failed to initialize. This may be temporary - please try again in a few moments. If the problem persists, restart your device."
                        self.error = NSError(
                            domain: "SubstitutionsGenerator",
                            code: -5,
                            userInfo: [NSLocalizedDescriptionKey: modelErrorMessage]
                        )
                        isGenerating = false
                        return
                    }
                }
            }

            self.error = NSError(
                domain: "SubstitutionsGenerator",
                code: -5,
                userInfo: [NSLocalizedDescriptionKey: "Unexpected error: \(error.localizedDescription)"]
            )
        }

        isGenerating = false
    }

    private func buildPrompt(request: SubstitutionRequest) -> String {
        var prompt = "What are good substitutes for \(request.ingredient) in cooking?"

        if let context = request.context {
            if let recipeName = context.recipeName, !recipeName.isEmpty {
                prompt += " I'm making \(recipeName)."
            }
            if let dietary = context.dietaryRestrictions, !dietary.isEmpty {
                prompt += " Dietary needs: \(dietary.joined(separator: ", "))."
            }
        }

        prompt += " Give me 3-4 practical options with ratios."

        return prompt
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
                        You are a culinary expert. Suggest practical ingredient substitutes.

                        For each substitute provide:
                        - name: The substitute ingredient
                        - ratio: The conversion ratio (e.g., "1:1")
                        - notes: Brief note about flavor/texture changes

                        Keep responses concise and practical.
                        """
                    }
                    self.session = LanguageModelSession(instructions: instructions)
                    print("🔄 Session initialized during prewarm")
                }
                
                guard let session = self.session else {
                    print("⚠️ Failed to initialize session for prewarming")
                    return
                }

                print("🔥 Prewarming Substitutions model...")
                
                // Use a simple prompt that matches our expected use case
                _ = try await session.respond(to: "What can I substitute for butter?")
                
                print("✅ Substitutions model prewarmed successfully")
            } catch {
                print("⚠️ Substitutions prewarm failed (non-critical): \(error.localizedDescription)")
                
                // If prewarm fails, clear the session so it can be recreated on next use
                self.session = nil
            }
        }
    }

    func cleanup() {
        result = nil
        error = nil
        isGenerating = false
        print("🧹 SubstitutionsGenerator cleaned up")
    }
}
