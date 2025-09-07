import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/widgets/utils/screen_header.dart';

class SettingsScreen extends StatefulWidget {
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
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _aiRecommendationsEnabled = true;
  bool _autoSaveRecipes = true;
  String _selectedLanguage = 'English';
  String _selectedUnits = 'Metric';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              onProfileTap: widget.onProfileTap ?? () {},
              onFeedTap: widget.onFeedTap ?? () {},
              onLogoutTap: widget.onLogoutTap ?? () {},
              currentIndex: 3,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('General'),
                    _buildIOSGroupCard([
                      _buildIOSSwitchTile(
                        'Notifications',
                        'Receive cooking reminders and updates',
                        Icons.notifications_outlined,
                        _notificationsEnabled,
                        (value) =>
                            setState(() => _notificationsEnabled = value),
                        isFirst: true,
                      ),
                      _buildIOSSwitchTile(
                        'Dark Mode',
                        'Switch to dark theme',
                        Icons.dark_mode_outlined,
                        _darkModeEnabled,
                        (value) => setState(() => _darkModeEnabled = value),
                      ),
                      _buildIOSDropdownTile(
                        'Language',
                        'Select your preferred language',
                        Icons.language_outlined,
                        _selectedLanguage,
                        ['English', 'Spanish', 'French', 'German', 'Italian'],
                        (value) => setState(() => _selectedLanguage = value!),
                      ),
                      _buildIOSDropdownTile(
                        'Units',
                        'Measurement system preference',
                        Icons.straighten_outlined,
                        _selectedUnits,
                        ['Metric', 'Imperial'],
                        (value) => setState(() => _selectedUnits = value!),
                        isLast: true,
                      ),
                    ]),

                    const SizedBox(height: 35),
                    _buildSectionHeader('AI & Recipes'),
                    _buildIOSGroupCard([
                      _buildIOSSwitchTile(
                        'AI Recommendations',
                        'Get personalized recipe suggestions',
                        Icons.auto_awesome_outlined,
                        _aiRecommendationsEnabled,
                        (value) =>
                            setState(() => _aiRecommendationsEnabled = value),
                        isFirst: true,
                      ),
                      _buildIOSSwitchTile(
                        'Auto-save Recipes',
                        'Automatically save recipes you view',
                        Icons.bookmark_outline,
                        _autoSaveRecipes,
                        (value) => setState(() => _autoSaveRecipes = value),
                      ),
                      _buildIOSNavigationTile(
                        'Dietary Preferences',
                        'Set allergies and dietary restrictions',
                        Icons.restaurant_menu_outlined,
                        () => _showDietaryPreferences(),
                      ),
                      _buildIOSNavigationTile(
                        'Cooking Skills',
                        'Set your cooking experience level',
                        Icons.local_dining_outlined,
                        () => _showCookingSkills(),
                        isLast: true,
                      ),
                    ]),

                    const SizedBox(height: 35),
                    _buildSectionHeader('Account'),
                    _buildIOSGroupCard([
                      _buildIOSNavigationTile(
                        'Profile Settings',
                        'Manage your profile information',
                        Icons.person_outline,
                        () => _navigateToProfile(),
                        isFirst: true,
                      ),
                      _buildIOSNavigationTile(
                        'Privacy & Security',
                        'Control your data and privacy settings',
                        Icons.security_outlined,
                        () => _showPrivacySettings(),
                      ),
                      _buildIOSNavigationTile(
                        'Data & Storage',
                        'Manage app data and storage',
                        Icons.storage_outlined,
                        () => _showDataSettings(),
                        isLast: true,
                      ),
                    ]),

                    const SizedBox(height: 35),
                    _buildSectionHeader('Support'),
                    _buildIOSGroupCard([
                      _buildIOSNavigationTile(
                        'Help & FAQ',
                        'Get help and find answers',
                        Icons.help_outline,
                        () => _showHelp(),
                        isFirst: true,
                      ),
                      _buildIOSNavigationTile(
                        'Contact Support',
                        'Get in touch with our team',
                        Icons.support_agent_outlined,
                        () => _contactSupport(),
                      ),
                      _buildIOSNavigationTile(
                        'About',
                        'App version and information',
                        Icons.info_outline,
                        () => _showAbout(),
                        isLast: true,
                      ),
                    ]),

                    const SizedBox(height: 35),
                    _buildIOSGroupCard([_buildIOSLogoutTile()]),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 16.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.white.withValues(alpha: 0.6),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildIOSGroupCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.mutedGreen, width: 1),
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 1,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildIOSSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border:
            !isLast
                ? Border(
                  bottom: BorderSide(
                    color: Colors.grey.withValues(alpha: 0.3),
                    width: 0.5,
                  ),
                )
                : null,
        borderRadius:
            isFirst && isLast
                ? BorderRadius.circular(10)
                : isFirst
                ? const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                )
                : isLast
                ? const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )
                : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        leading: Container(
          width: 29,
          height: 29,
          decoration: BoxDecoration(
            color: AppColors.orange,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        subtitle:
            subtitle.isNotEmpty
                ? Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                )
                : null,
        trailing: Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.orange,
        ),
      ),
    );
  }

  Widget _buildIOSDropdownTile(
    String title,
    String subtitle,
    IconData icon,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border:
            !isLast
                ? Border(
                  bottom: BorderSide(
                    color: Colors.grey.withValues(alpha: 0.3),
                    width: 0.5,
                  ),
                )
                : null,
        borderRadius:
            isFirst && isLast
                ? BorderRadius.circular(10)
                : isFirst
                ? const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                )
                : isLast
                ? const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )
                : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        leading: Container(
          width: 29,
          height: 29,
          decoration: BoxDecoration(
            color: AppColors.orange,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        subtitle:
            subtitle.isNotEmpty
                ? Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                )
                : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 17, color: Colors.grey[500]),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
          ],
        ),
        onTap: () => _showIOSPicker(title, options, value, onChanged),
      ),
    );
  }

  Widget _buildIOSNavigationTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border:
            !isLast
                ? Border(
                  bottom: BorderSide(
                    color: Colors.grey.withValues(alpha: 0.3),
                    width: 0.5,
                  ),
                )
                : null,
        borderRadius:
            isFirst && isLast
                ? BorderRadius.circular(10)
                : isFirst
                ? const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                )
                : isLast
                ? const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )
                : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        leading: Container(
          width: 29,
          height: 29,
          decoration: BoxDecoration(
            color: AppColors.orange,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        subtitle:
            subtitle.isNotEmpty
                ? Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                )
                : null,
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
        onTap: onTap,
      ),
    );
  }

  Widget _buildIOSLogoutTile() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        title: const Text(
          'Sign Out',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: Colors.red,
          ),
        ),
        onTap: () => _showLogoutDialog(),
      ),
    );
  }

  void _showIOSPicker(
    String title,
    List<String> options,
    String currentValue,
    ValueChanged<String?> onChanged,
  ) {
    final overlayContext =
        Navigator.of(context, rootNavigator: true).overlay!.context;
    final int initialItem = options.indexOf(currentValue);

    showCupertinoModalPopup<void>(
      context: overlayContext,
      builder:
          (BuildContext context) => Container(
            height: 260,
            padding: const EdgeInsets.only(top: 6.0),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            color: CupertinoColors.white,
            child: Column(
              children: [
                Container(
                  height: 44,
                  decoration: const BoxDecoration(
                    color: CupertinoColors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: CupertinoColors.systemGrey4,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: AppColors.mutedGreen,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      CupertinoButton(
                        padding: const EdgeInsets.only(right: 16),
                        child: Text(
                          'Done',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.mutedGreen,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    magnification: 1.22,
                    squeeze: 1.2,
                    useMagnifier: true,
                    itemExtent: 32.0,
                    scrollController: FixedExtentScrollController(
                      initialItem: initialItem != -1 ? initialItem : 0,
                    ),
                    onSelectedItemChanged: (int selectedItem) {
                      onChanged(options[selectedItem]);
                    },
                    children:
                        options
                            .map(
                              (item) => Center(
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    color: AppColors.button,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  // Placeholder methods for navigation and actions
  void _showDietaryPreferences() {
    _showComingSoonDialog('Dietary Preferences');
  }

  void _showCookingSkills() {
    _showComingSoonDialog('Cooking Skills');
  }

  void _navigateToProfile() {
    if (widget.onProfileTap != null) {
      widget.onProfileTap!();
    } else {
      _showComingSoonDialog('Profile Settings');
    }
  }

  void _showPrivacySettings() {
    _showComingSoonDialog('Privacy & Security');
  }

  void _showDataSettings() {
    _showComingSoonDialog('Data & Storage');
  }

  void _showHelp() {
    _showComingSoonDialog('Help & FAQ');
  }

  void _contactSupport() {
    _showComingSoonDialog('Contact Support');
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (BuildContext dialogContext) => CupertinoAlertDialog(
            title: const Icon(
              CupertinoIcons.hammer_fill,
              color: AppColors.orange,
              size: 40,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                Text(
                  '$feature is currently under development and will be available in a future update.',
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: AppColors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void _showAbout() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (BuildContext dialogContext) => CupertinoAlertDialog(
            title: const Icon(
              CupertinoIcons.info_circle_fill,
              color: AppColors.orange,
              size: 40,
            ),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 16),
                Text(
                  'AI Cook',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Your AI-powered cooking companion for discovering delicious recipes and managing your kitchen.',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 14,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    color: AppColors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (BuildContext dialogContext) => CupertinoAlertDialog(
            title: const Icon(
              CupertinoIcons.person_crop_circle_badge_minus,
              color: Colors.red,
              size: 40,
            ),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 16),
                Text(
                  'Are you sure you want to sign out of your account?',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppColors.button,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  if (widget.onLogoutTap != null) {
                    widget.onLogoutTap!();
                  }
                },
                child: const Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
