//
//  RemindersManager.swift
//  Runner
//
//  Manages iOS Reminders for the kitchen assistant
//

import Foundation
import EventKit

@MainActor
class RemindersManager {

    private let eventStore = EKEventStore()

    // MARK: - Permission

    /// Check if we have permission to access reminders
    func hasPermission() async -> Bool {
        let status = EKEventStore.authorizationStatus(for: .reminder)
        return status == .fullAccess || status == .writeOnly
    }

    /// Request permission to access reminders
    func requestPermission() async -> Bool {
        do {
            let granted = try await eventStore.requestFullAccessToReminders()
            print(granted ? "✅ Reminders permission granted" : "⚠️ Reminders permission denied")
            return granted
        } catch {
            print("❌ Error requesting reminders permission: \(error.localizedDescription)")
            return false
        }
    }

    // MARK: - Create Reminder

    /// Create a reminder with optional due date
    /// - Parameters:
    ///   - title: The reminder title/text
    ///   - notes: Optional notes/description
    ///   - dueDate: Optional due date
    /// - Returns: Success status and message
    func createReminder(
        title: String,
        notes: String? = nil,
        dueDate: Date? = nil
    ) async -> (success: Bool, message: String) {
        // Check/request permission first
        var hasAccess = await hasPermission()
        if !hasAccess {
            hasAccess = await requestPermission()
            if !hasAccess {
                return (false, "Permission to access Reminders was denied. Please enable it in Settings.")
            }
        }

        do {
            // Create the reminder
            let reminder = EKReminder(eventStore: eventStore)
            reminder.title = title

            if let notes = notes {
                reminder.notes = notes
            }

            if let dueDate = dueDate {
                let calendar = Calendar.current
                let components = calendar.dateComponents(
                    [.year, .month, .day, .hour, .minute],
                    from: dueDate
                )
                reminder.dueDateComponents = components
            }

            // Get or create the default reminders calendar
            guard let defaultCalendar = getOrCreateDefaultCalendar() else {
                return (false, "Could not access Reminders calendar.")
            }

            reminder.calendar = defaultCalendar

            // Save the reminder
            try eventStore.save(reminder, commit: true)

            print("✅ Reminder created: '\(title)'")

            // Build success message
            var message = "✅ I've created a reminder: '\(title)'"
            if let dueDate = dueDate {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                message += " due \(formatter.string(from: dueDate))"
            }

            return (true, message)

        } catch {
            print("❌ Error creating reminder: \(error.localizedDescription)")
            return (false, "Sorry, I couldn't create the reminder: \(error.localizedDescription)")
        }
    }

    // MARK: - Helper Methods

    /// Get the default reminders calendar or create one if needed
    private func getOrCreateDefaultCalendar() -> EKCalendar? {
        // Try to get the default calendar for new reminders
        if let defaultCalendar = eventStore.defaultCalendarForNewReminders() {
            return defaultCalendar
        }

        // If no default, try to find any reminders calendar
        let calendars = eventStore.calendars(for: .reminder)
        if let firstCalendar = calendars.first {
            return firstCalendar
        }

        // As a last resort, create a new calendar
        let newCalendar = EKCalendar(for: .reminder, eventStore: eventStore)
        newCalendar.title = "ai.Cook Reminders"

        // Set the calendar source (usually local or iCloud)
        if let source = eventStore.sources.first(where: { $0.sourceType == .local }) {
            newCalendar.source = source
        } else if let source = eventStore.sources.first {
            newCalendar.source = source
        } else {
            return nil
        }

        do {
            try eventStore.saveCalendar(newCalendar, commit: true)
            return newCalendar
        } catch {
            print("❌ Error creating calendar: \(error.localizedDescription)")
            return nil
        }
    }

    // MARK: - Date Parsing Helpers

    /// Parse a relative date string like "tomorrow", "today", "next monday"
    static func parseRelativeDate(from text: String) -> Date? {
        let lowercased = text.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let calendar = Calendar.current
        let now = Date()

        // Today
        if lowercased.contains("today") || lowercased.contains("later today") {
            // Default to 6 PM today
            var components = calendar.dateComponents([.year, .month, .day], from: now)
            components.hour = 18
            components.minute = 0
            return calendar.date(from: components)
        }

        // Tomorrow
        if lowercased.contains("tomorrow") {
            if let tomorrow = calendar.date(byAdding: .day, value: 1, to: now) {
                var components = calendar.dateComponents([.year, .month, .day], from: tomorrow)
                components.hour = 12 // Default to noon
                components.minute = 0
                return calendar.date(from: components)
            }
        }

        // This evening / tonight
        if lowercased.contains("evening") || lowercased.contains("tonight") {
            var components = calendar.dateComponents([.year, .month, .day], from: now)
            components.hour = 19 // 7 PM
            components.minute = 0
            return calendar.date(from: components)
        }

        // This morning
        if lowercased.contains("morning") {
            if lowercased.contains("tomorrow") {
                if let tomorrow = calendar.date(byAdding: .day, value: 1, to: now) {
                    var components = calendar.dateComponents([.year, .month, .day], from: tomorrow)
                    components.hour = 9 // 9 AM
                    components.minute = 0
                    return calendar.date(from: components)
                }
            } else {
                var components = calendar.dateComponents([.year, .month, .day], from: now)
                components.hour = 9
                components.minute = 0
                return calendar.date(from: components)
            }
        }

        // Next week
        if lowercased.contains("next week") {
            if let nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: now) {
                var components = calendar.dateComponents([.year, .month, .day], from: nextWeek)
                components.hour = 12
                components.minute = 0
                return calendar.date(from: components)
            }
        }

        // Days of the week
        let weekdays = [
            ("sunday", 1), ("monday", 2), ("tuesday", 3), ("wednesday", 4),
            ("thursday", 5), ("friday", 6), ("saturday", 7)
        ]

        for (dayName, weekdayNumber) in weekdays {
            if lowercased.contains(dayName) {
                // Find the next occurrence of this weekday
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

        return nil
    }
}
