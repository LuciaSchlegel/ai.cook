import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Service for communicating with Foundation Models chat assistant on iOS
/// Falls back to API on other platforms or if Foundation Models fail
class FoundationChatService {
  static const platform = MethodChannel('ai.cook/foundation_models');

  /// Send a message and get a response from the chat assistant
  /// Returns the AI response or null if failed
  static Future<String?> sendMessage(String message) async {
    if (!Platform.isIOS) return null;

    try {
      debugPrint('💬 Sending message to Foundation Models chat...');

      final response = await platform.invokeMethod<String>(
        'chatSendMessage',
        {'message': message},
      );

      if (response != null && response.isNotEmpty) {
        debugPrint('✅ Foundation Models chat response received');
        return response;
      }

      debugPrint('⚠️ Empty response from Foundation Models');
      return null;
    } on PlatformException catch (e) {
      debugPrint('⚠️ Foundation Models chat error: ${e.message}');
      debugPrint('   Code: ${e.code}');
      debugPrint('   Details: ${e.details}');
      return null;
    } catch (e) {
      debugPrint('⚠️ Foundation Models chat failed: $e');
      return null;
    }
  }

  /// Prewarm the chat assistant model for faster first response
  static Future<void> prewarmChat() async {
    if (!Platform.isIOS) return;

    try {
      debugPrint('🔥 Prewarming Foundation Models chat...');
      await platform.invokeMethod('chatPrewarm');
      debugPrint('✅ Chat assistant prewarmed successfully');
    } catch (e) {
      debugPrint('⚠️ Chat prewarm failed (non-critical): $e');
      // Non-critical - chat will still work
    }
  }

  /// Clear the conversation history
  static Future<void> clearHistory() async {
    if (!Platform.isIOS) return;

    try {
      debugPrint('🧹 Clearing chat history...');
      await platform.invokeMethod('chatClearHistory');
      debugPrint('✅ Chat history cleared');
    } catch (e) {
      debugPrint('⚠️ Clear history failed: $e');
      // Non-critical
    }
  }

  /// Cleanup chat resources (called when closing chat)
  static Future<void> cleanup() async {
    if (!Platform.isIOS) return;

    try {
      debugPrint('🧹 Cleaning up Foundation Models resources...');
      await platform.invokeMethod('cleanup');
      debugPrint('✅ Foundation Models cleanup complete');
    } catch (e) {
      debugPrint('⚠️ Cleanup failed: $e');
    }
  }
}
