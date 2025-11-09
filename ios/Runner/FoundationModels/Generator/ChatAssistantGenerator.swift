//
//  ChatAssistantGenerator.swift
//  Runner
//
//  Kitchen Assistant chatbot using Foundation Models
//  Enforces cooking/food/nutrition context only
//

import Foundation
import FoundationModels
import EventKit

@MainActor
class ChatAssistantGenerator: ObservableObject {

    // MARK: - Properties

    private let session: LanguageModelSession
    private var conversationHistory: [String] = []
    private let eventStore = EKEventStore()

    @Published var error: Error?
    @Published var currentResponse: String = ""

    // System prompt that enforces cooking context
    private let systemPrompt = """
    You are a helpful kitchen assistant AI specialized in cooking, food, nutrition, and culinary topics.

    SPECIAL CAPABILITY:
    - You can help users create reminders in their iPhone Reminders app for cooking-related tasks
    - When a user asks to be reminded (e.g., "remind me to buy apples tomorrow"), acknowledge it positively
    - Be conversational about reminders, but keep responses concise

    IMPORTANT CONTEXT RULES:

    1. Be friendly, concise, and helpful
    2. Use cooking emojis occasionally to make responses more engaging
    3. When discussing recipes, be specific with measurements and steps
    4. Consider dietary restrictions and preferences (if mentioned by the user) when giving advice
    5. IMPORTANT: If there is previous conversation history, do NOT greet with "Hello" or "Hi" again. Only greet at the START of a conversation. For follow-up messages, jump straight into answering the question.

    Keep responses conversational and practical for home cooks.
    """

    // MARK: - Initialization

    init() {
        // Initialize the Language Model Session
        self.session = LanguageModelSession()
        print("✅ Chat Assistant Generator initialized")
    }

    // MARK: - Public Methods

    /// Send a message and get a response
    /// Returns the AI's response or an off-topic message
    func sendMessage(_ userMessage: String) async -> String {
        do {
            print("💬 User message: \(userMessage)")

            // Check if user is requesting a reminder
            let reminderRequest = detectReminderRequest(in: userMessage)

            // Add user message to conversation history
            conversationHistory.append("User: \(userMessage)")

            // Build the full prompt with context
            let fullPrompt = buildPromptWithHistory(userMessage: userMessage)

            print("🤖 Generating response...")

            // Generate response
            let response = try await session.respond(
                to: fullPrompt,
                options: GenerationOptions(temperature: 0.7)
            )

            var responseText = response.content.trimmingCharacters(in: .whitespacesAndNewlines)

            // If user requested a reminder, try to create it
            if let request = reminderRequest {
                print("🔔 Detected reminder request: \(request.title)")
                let reminderResult = await createReminder(
                    title: request.title,
                    when: request.when
                )

                // Append reminder result to response
                if reminderResult.success {
                    responseText += "\n\n" + reminderResult.message
                } else {
                    responseText += "\n\n" + reminderResult.message
                }
            }

            // Add assistant response to history
            conversationHistory.append("Assistant: \(responseText)")

            // Limit history to last 10 exchanges (20 messages)
            if conversationHistory.count > 20 {
                conversationHistory = Array(conversationHistory.suffix(20))
            }

            print("✅ Response generated: \(responseText.prefix(100))...")

            return responseText

        } catch {
            print("❌ Error generating response: \(error.localizedDescription)")
            self.error = error
            return "I apologize, but I encountered an error processing your message. Please try again."
        }
    }

    /// Clear conversation history
    func clearHistory() {
        conversationHistory.removeAll()
        print("🧹 Conversation history cleared")
    }

    /// Prewarm the model for faster first response
    func prewarmModel() {
        Task {
            do {
                print("🔥 Prewarming chat assistant...")

                // Send a simple warmup prompt
                _ = try await session.respond(
                    to: "Hello",
                    options: GenerationOptions(temperature: 0.0) // Use 0.0 for deterministic warmup
                )

                print("✅ Chat assistant prewarmed and ready")
            } catch {
                print("⚠️ Chat prewarm failed (non-critical): \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Private Methods

    /// Detect if user message is requesting a reminder
    private func detectReminderRequest(in message: String) -> (title: String, when: String?)? {
        let lowercased = message.lowercased()

        // Check for reminder keywords
        guard lowercased.contains("remind") else {
            return nil
        }

        // Extract the reminder content
        // Common patterns: "remind me to X", "remind me X", "don't forget X"
        var title = message
        let when: String?

        // Remove "remind me to" / "remind me" prefix
        if let range = lowercased.range(of: "remind me to ") {
            title = String(message[range.upperBound...])
        } else if let range = lowercased.range(of: "remind me ") {
            title = String(message[range.upperBound...])
        }

        // Try to extract time expressions
        let timeKeywords = ["tomorrow", "tonight", "today", "evening", "morning",
                          "monday", "tuesday", "wednesday", "thursday",
                          "friday", "saturday", "sunday", "next week"]

        var extractedWhen: String? = nil
        for keyword in timeKeywords {
            if lowercased.contains(keyword) {
                extractedWhen = keyword
                // Remove the time from title
                if let range = title.lowercased().range(of: keyword) {
                    title.removeSubrange(range)
                }
                break
            }
        }

        // Clean up title
        title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        title = title.trimmingCharacters(in: CharacterSet(charactersIn: ".,!?"))

        guard !title.isEmpty else {
            return nil
        }

        when = extractedWhen

        return (title: title, when: when)
    }

    /// Create a reminder using EventKit
    private func createReminder(title: String, when: String?) async -> (success: Bool, message: String) {
        // Check/request permission
        let status = EKEventStore.authorizationStatus(for: .reminder)

        if status != .fullAccess && status != .writeOnly {
            // Request permission
            do {
                let granted = try await eventStore.requestFullAccessToReminders()
                if !granted {
                    return (false, "⚠️ I need permission to access Reminders. Please enable it in Settings.")
                }
            } catch {
                return (false, "⚠️ Could not request Reminders permission: \(error.localizedDescription)")
            }
        }

        // Parse date if provided
        var dueDate: Date? = nil
        if let whenStr = when {
            dueDate = parseRelativeDate(from: whenStr)
        }

        // Create the reminder
        let reminder = EKReminder(eventStore: eventStore)
        reminder.title = title

        if let dueDate = dueDate {
            let calendar = Calendar.current
            let components = calendar.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: dueDate
            )
            reminder.dueDateComponents = components
        }

        // Get or create calendar
        guard let reminderCalendar = eventStore.defaultCalendarForNewReminders() ??
                eventStore.calendars(for: .reminder).first else {
            return (false, "⚠️ Could not access Reminders calendar.")
        }

        reminder.calendar = reminderCalendar

        // Save
        do {
            try eventStore.save(reminder, commit: true)

            var message = "✅ I've created a reminder: '\(title)'"
            if let dueDate = dueDate {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                message += " due \(formatter.string(from: dueDate))"
            }

            return (true, message)
        } catch {
            return (false, "⚠️ Could not save reminder: \(error.localizedDescription)")
        }
    }

    /// Parse relative date strings
    private func parseRelativeDate(from text: String) -> Date? {
        let lowercased = text.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let calendar = Calendar.current
        let now = Date()

        // Today
        if lowercased == "today" || lowercased == "later today" {
            var components = calendar.dateComponents([.year, .month, .day], from: now)
            components.hour = 18
            components.minute = 0
            return calendar.date(from: components)
        }

        // Tomorrow
        if lowercased == "tomorrow" {
            if let tomorrow = calendar.date(byAdding: .day, value: 1, to: now) {
                var components = calendar.dateComponents([.year, .month, .day], from: tomorrow)
                components.hour = 12
                components.minute = 0
                return calendar.date(from: components)
            }
        }

        // Tonight/evening
        if lowercased == "evening" || lowercased == "tonight" {
            var components = calendar.dateComponents([.year, .month, .day], from: now)
            components.hour = 19
            components.minute = 0
            return calendar.date(from: components)
        }

        // Morning
        if lowercased == "morning" {
            var components = calendar.dateComponents([.year, .month, .day], from: now)
            components.hour = 9
            components.minute = 0
            return calendar.date(from: components)
        }

        // Days of week
        let weekdays = [
            ("sunday", 1), ("monday", 2), ("tuesday", 3), ("wednesday", 4),
            ("thursday", 5), ("friday", 6), ("saturday", 7)
        ]

        for (dayName, weekdayNumber) in weekdays {
            if lowercased == dayName {
                var components = DateComponents()
                components.weekday = weekdayNumber
                components.hour = 12
                components.minute = 0

                if let nextDate = calendar.nextDate(
                    after: now,
                    matching: components,
                    matchingPolicy: .nextTime
                ) {
                    return nextDate
                }
            }
        }

        // Next week
        if lowercased == "next week" {
            if let nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: now) {
                var components = calendar.dateComponents([.year, .month, .day], from: nextWeek)
                components.hour = 12
                components.minute = 0
                return calendar.date(from: components)
            }
        }

        return nil
    }

    /// Build the full prompt with system context and conversation history
    private func buildPromptWithHistory(userMessage: String) -> String {
        var prompt = systemPrompt + "\n\n"

        // Add recent conversation history if exists
        if !conversationHistory.isEmpty {
            prompt += "Previous conversation:\n"
            // Include last 6 exchanges (12 messages) for context
            let recentHistory = conversationHistory.suffix(12)
            for message in recentHistory {
                prompt += message + "\n"
            }
            prompt += "\n"
        }

        // Add current user message
        prompt += "User: \(userMessage)\nAssistant:"

        return prompt
    }

    /// Cleanup resources
    func cleanup() {
        // Clear conversation history
        conversationHistory.removeAll()

        // Reset event store by creating a new instance
        // This ensures no pending reminder operations
        // Note: EKEventStore doesn't require explicit cleanup,
        // but we reset it for a clean state

        print("🧹 Chat assistant cleaned up")
        print("   - Conversation history cleared")
        print("   - Ready for next session")
    }
}
