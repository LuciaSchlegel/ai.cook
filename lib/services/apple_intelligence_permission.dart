import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ai_cook_project/theme.dart';

class AppleIntelligencePermission {
  static const String _hasShownKey = 'has_shown_apple_intelligence_permission';

  /// Check if we've already shown the Apple Intelligence permission dialog
  static Future<bool> hasShownPermission() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasShownKey) ?? false;
  }

  /// Mark that we've shown the permission dialog
  static Future<void> markAsShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasShownKey, true);
  }

  /// Show the Apple Intelligence permission dialog
  /// Returns true if shown, false if already shown or not iOS
  static Future<bool> showPermissionDialogIfNeeded(BuildContext context) async {
    // Only show on iOS
    if (!Platform.isIOS) return false;

    // Check if already shown
    final hasShown = await hasShownPermission();
    if (hasShown) return false;

    if (!context.mounted) return false;

    // Show the dialog
    await _showDialog(context);

    // Mark as shown
    await markAsShown();

    return true;
  }

  static Future<void> _showDialog(BuildContext context) async {
    return showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.auto_awesome,
                color: AppColors.mutedGreen,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Apple Intelligence',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text(
              'This app uses Apple Intelligence to provide personalized recipe recommendations based on your available ingredients.\n\n'
              'Apple Intelligence processes data on your device to ensure your privacy and deliver fast, intelligent cooking suggestions.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Got it',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  color: AppColors.mutedGreen,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
