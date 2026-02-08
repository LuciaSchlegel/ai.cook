//
//  UnitConverterGenerator.swift
//  Runner
//
//  Smart cooking unit conversions using Apple Intelligence
//  Uses structured output for accurate conversions
//

import Foundation
import FoundationModels
import Observation

// MARK: - Input Models

struct ConversionRequest: Codable {
    let amount: String
    let fromUnit: String
    let toUnit: String?
    let ingredient: String?
}

// MARK: - Output Models (Structured with @Generable)

@Generable
struct ConversionResult {
    @Guide(description: "The original amount and unit being converted")
    let original: String

    @Guide(description: "List of converted measurements")
    let conversions: [ConvertedMeasurement]

    @Guide(description: "Brief tip about measuring this ingredient")
    let tip: String
}

@Generable
struct ConvertedMeasurement {
    @Guide(description: "The converted amount with unit, e.g., '240 grams'")
    let measurement: String

    @Guide(description: "Type of unit: volume, weight, or count")
    let unitType: String
}

// MARK: - Generator

@Observable
@MainActor
final class UnitConverterGenerator {

    var error: Error?
    private var session: LanguageModelSession?

    private(set) var result: ConversionResult?
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
        guard UnitConverterGenerator.isAvailable else {
            print("⚠️ Apple Intelligence not available on this device")
            return
        }

        if #available(iOS 26.0, *) {
            let instructions = Instructions {
                """
                You are a cooking measurement expert. Convert between cooking units accurately.

                For each conversion provide:
                - measurement: The converted amount with unit (e.g., "240 grams")
                - unitType: The type of unit (volume, weight, or count)

                Always provide conversions to common cooking units.
                Be precise with measurements - cooking depends on accuracy.
                """
            }
            self.session = LanguageModelSession(instructions: instructions)
        }
    }

    func convert(request: ConversionRequest) async {
        guard !request.amount.isEmpty && !request.fromUnit.isEmpty else {
            self.error = NSError(
                domain: "UnitConverterGenerator",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Amount and unit are required"]
            )
            return
        }

        guard #available(iOS 26.0, *) else {
            self.error = NSError(
                domain: "UnitConverterGenerator",
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
                domain: "UnitConverterGenerator",
                code: -3,
                userInfo: [NSLocalizedDescriptionKey: "This device is not eligible for Apple Intelligence. Apple Intelligence requires iPhone 15 Pro, iPhone 16, or newer."]
            )
            return
        case .unavailable(.appleIntelligenceNotEnabled):
            self.error = NSError(
                domain: "UnitConverterGenerator",
                code: -3,
                userInfo: [NSLocalizedDescriptionKey: "Apple Intelligence is not enabled. Please enable it in Settings > Apple Intelligence & Siri."]
            )
            return
        case .unavailable(.modelNotReady):
            self.error = NSError(
                domain: "UnitConverterGenerator",
                code: -3,
                userInfo: [NSLocalizedDescriptionKey: "Apple Intelligence model is still downloading or not ready. Please try again later."]
            )
            return
        case .unavailable(let reason):
            self.error = NSError(
                domain: "UnitConverterGenerator",
                code: -3,
                userInfo: [NSLocalizedDescriptionKey: "Apple Intelligence is unavailable: \(reason)"]
            )
            return
        }

        // Initialize or reinitialize session if needed
        if self.session == nil {
            let instructions = Instructions {
                """
                You are a cooking measurement expert. Convert between cooking units accurately.

                For each conversion provide:
                - measurement: The converted amount with unit (e.g., "240 grams")
                - unitType: The type of unit (volume, weight, or count)

                Always provide conversions to common cooking units.
                Be precise with measurements - cooking depends on accuracy.
                """
            }
            self.session = LanguageModelSession(instructions: instructions)
            print("🔄 Initialized new session for unit conversion")
        }

        guard let session = self.session else {
            self.error = NSError(
                domain: "UnitConverterGenerator",
                code: -4,
                userInfo: [NSLocalizedDescriptionKey: "Failed to initialize AI session"]
            )
            return
        }

        // Check if session is already responding
        if session.isResponding {
            self.error = NSError(
                domain: "UnitConverterGenerator",
                code: -6,
                userInfo: [NSLocalizedDescriptionKey: "A request is already in progress. Please wait."]
            )
            return
        }

        isGenerating = true
        error = nil

        do {
            let prompt = buildPrompt(request: request)

            print("⚖️ Converting: \(request.amount) \(request.fromUnit)")
            print("📝 Prompt: \(prompt)")
            let startTime = Date()

            let response = try await session.respond(
                to: prompt,
                generating: ConversionResult.self
            )

            self.result = response.content

            let elapsed = Date().timeIntervalSince(startTime)
            print("✅ Conversion completed in \(String(format: "%.2f", elapsed))s")

            // Log results
            if let result = self.result {
                print("\n⚖️ CONVERSION RESULTS for '\(result.original)':")
                print("==================================================")
                for conversion in result.conversions {
                    print("  → \(conversion.measurement) (\(conversion.unitType))")
                }
                print("💡 Tip: \(result.tip)")
                print("==================================================")
            }

        } catch let error as LanguageModelSession.GenerationError {
            print("❌ Generation error: \(error)")

            let errorMessage: String
            let errorDescription = error.localizedDescription.lowercased()

            if errorDescription.contains("context") || errorDescription.contains("window") || errorDescription.contains("size") {
                errorMessage = "The request is too large. Try simplifying your request."
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
                                domain: "UnitConverterGenerator",
                                code: -5,
                                userInfo: [NSLocalizedDescriptionKey: modelErrorMessage]
                            )
                            isGenerating = false
                            return
                        }
                    }
                }
                errorMessage = "Failed to convert: \(error.localizedDescription)"
            }

            self.error = NSError(
                domain: "UnitConverterGenerator",
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
                            domain: "UnitConverterGenerator",
                            code: -5,
                            userInfo: [NSLocalizedDescriptionKey: modelErrorMessage]
                        )
                        isGenerating = false
                        return
                    }
                }
            }

            self.error = NSError(
                domain: "UnitConverterGenerator",
                code: -5,
                userInfo: [NSLocalizedDescriptionKey: "Unexpected error: \(error.localizedDescription)"]
            )
        }

        isGenerating = false
    }

    private func buildPrompt(request: ConversionRequest) -> String {
        var prompt = "Convert \(request.amount) \(request.fromUnit)"

        if let toUnit = request.toUnit, !toUnit.isEmpty {
            prompt += " to \(toUnit)"
        } else {
            prompt += " to common cooking units (grams, ml, tablespoons, etc.)"
        }

        if let ingredient = request.ingredient, !ingredient.isEmpty {
            prompt += " for \(ingredient)"
        }

        prompt += ". Provide 3-4 useful conversions."

        return prompt
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
                        You are a cooking measurement expert. Convert between cooking units accurately.

                        For each conversion provide:
                        - measurement: The converted amount with unit (e.g., "240 grams")
                        - unitType: The type of unit (volume, weight, or count)

                        Always provide conversions to common cooking units.
                        Be precise with measurements - cooking depends on accuracy.
                        """
                    }
                    self.session = LanguageModelSession(instructions: instructions)
                    print("🔄 Session initialized during prewarm")
                }

                guard let session = self.session else {
                    print("⚠️ Failed to initialize session for prewarming")
                    return
                }

                print("🔥 Prewarming Unit Converter model...")
                _ = try await session.respond(to: "Convert 1 cup to grams")
                print("✅ Unit Converter model prewarmed successfully")
            } catch {
                print("⚠️ Unit Converter prewarm failed (non-critical): \(error.localizedDescription)")
                self.session = nil
            }
        }
    }

    func cleanup() {
        result = nil
        error = nil
        isGenerating = false
        print("🧹 UnitConverterGenerator cleaned up")
    }
}
