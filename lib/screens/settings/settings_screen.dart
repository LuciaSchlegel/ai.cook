import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/widgets/utils/screen_header.dart';

class SettingsScreen extends StatelessWidget {
  final VoidCallback? onProfileTap;
  final VoidCallback? onFeedTap;
  final VoidCallback? onLogoutTap;

  const SettingsScreen({
    super.key,
    this.onProfileTap,
    this.onFeedTap,
    this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              onProfileTap: onProfileTap ?? () {},
              onFeedTap: onFeedTap ?? () {},
              onLogoutTap: onLogoutTap ?? () {},
              currentIndex: 3,
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Settings Screen',
                  style: TextStyle(fontSize: 24, color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
