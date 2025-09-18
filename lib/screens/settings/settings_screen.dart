import 'package:ai_cook_project/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/widgets/utils/screen_header.dart';
import 'package:ai_cook_project/widgets/responsive/responsive_builder.dart';

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
                padding: ResponsiveUtils.padding(context, ResponsiveSpacing.lg),
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

                    ResponsiveSpacingWidget.vertical(ResponsiveSpacing.lg),
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

                    ResponsiveSpacingWidget.vertical(ResponsiveSpacing.lg),
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

                    ResponsiveSpacingWidget.vertical(ResponsiveSpacing.lg),
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

                    ResponsiveSpacingWidget.vertical(ResponsiveSpacing.lg),
                    _buildIOSGroupCard([_buildIOSLogoutTile()]),
                    ResponsiveSpacingWidget.vertical(ResponsiveSpacing.lg),
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
      padding: ResponsiveUtils.padding(context, ResponsiveSpacing.sm),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.xs),
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
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.xxl),
        ),
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
        padding: ResponsiveUtils.padding(context, ResponsiveSpacing.xxs),
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
                ? BorderRadius.circular(
                  ResponsiveUtils.borderRadius(
                    context,
                    ResponsiveBorderRadius.xs,
                  ),
                )
                : isFirst
                ? BorderRadius.only(
                  topLeft: Radius.circular(
                    ResponsiveUtils.borderRadius(
                      context,
                      ResponsiveBorderRadius.xs,
                    ),
                  ),
                  topRight: Radius.circular(
                    ResponsiveUtils.borderRadius(
                      context,
                      ResponsiveBorderRadius.xs,
                    ),
                  ),
                )
                : isLast
                ? BorderRadius.only(
                  bottomLeft: Radius.circular(
                    ResponsiveUtils.borderRadius(
                      context,
                      ResponsiveBorderRadius.xs,
                    ),
                  ),
                  bottomRight: Radius.circular(
                    ResponsiveUtils.borderRadius(
                      context,
                      ResponsiveBorderRadius.xs,
                    ),
                  ),
                )
                : null,
      ),
      child: ListTile(
        contentPadding: ResponsiveUtils.padding(context, ResponsiveSpacing.md),
        leading: Container(
          width: ResponsiveUtils.iconSize(context, ResponsiveIconSize.lg),
          height: ResponsiveUtils.iconSize(context, ResponsiveIconSize.lg),
          decoration: BoxDecoration(
            color: AppColors.orange,
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.xs),
            ),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: AppFontFamilies.inter,
            fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.md),
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        subtitle:
            subtitle.isNotEmpty
                ? Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.xs,
                    ),
                    color: Colors.grey[600],
                    fontFamily: AppFontFamilies.inter,
                  ),
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
        contentPadding: ResponsiveUtils.padding(context, ResponsiveSpacing.md),
        leading: Container(
          width: ResponsiveUtils.iconSize(context, ResponsiveIconSize.lg),
          height: ResponsiveUtils.iconSize(context, ResponsiveIconSize.lg),
          decoration: BoxDecoration(
            color: AppColors.orange,
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.xs),
            ),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: AppFontFamilies.inter,
            fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.md),
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        subtitle:
            subtitle.isNotEmpty
                ? Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.xs,
                    ),
                    color: Colors.grey[600],
                    fontFamily: AppFontFamilies.inter,
                  ),
                )
                : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  ResponsiveFontSize.md,
                ),
                color: Colors.grey[500],
                fontFamily: AppFontFamilies.inter,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.sm),
            ),
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
                ? BorderRadius.circular(
                  ResponsiveUtils.borderRadius(
                    context,
                    ResponsiveBorderRadius.xs,
                  ),
                )
                : isFirst
                ? BorderRadius.only(
                  topLeft: Radius.circular(
                    ResponsiveUtils.borderRadius(
                      context,
                      ResponsiveBorderRadius.xs,
                    ),
                  ),
                  topRight: Radius.circular(
                    ResponsiveUtils.borderRadius(
                      context,
                      ResponsiveBorderRadius.xs,
                    ),
                  ),
                )
                : isLast
                ? BorderRadius.only(
                  bottomLeft: Radius.circular(
                    ResponsiveUtils.borderRadius(
                      context,
                      ResponsiveBorderRadius.xs,
                    ),
                  ),
                  bottomRight: Radius.circular(
                    ResponsiveUtils.borderRadius(
                      context,
                      ResponsiveBorderRadius.xs,
                    ),
                  ),
                )
                : null,
      ),
      child: ListTile(
        contentPadding: ResponsiveUtils.padding(context, ResponsiveSpacing.md),
        leading: Container(
          width: ResponsiveUtils.iconSize(context, ResponsiveIconSize.lg),
          height: ResponsiveUtils.iconSize(context, ResponsiveIconSize.lg),
          decoration: BoxDecoration(
            color: AppColors.orange,
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.xs),
            ),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: AppFontFamilies.inter,
            fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.md),
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        subtitle:
            subtitle.isNotEmpty
                ? Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.xs,
                    ),
                    color: Colors.grey[600],
                    fontFamily: AppFontFamilies.inter,
                  ),
                )
                : null,
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.grey[400],
          size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.sm),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildIOSLogoutTile() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(
            ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.xs),
          ),
        ),
      ),
      child: ListTile(
        contentPadding: ResponsiveUtils.padding(context, ResponsiveSpacing.xxs),
        title: Text(
          'Sign Out',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppFontFamilies.inter,
            fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.md),
            fontWeight: FontWeight.w500,
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
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.xxl),
            padding: ResponsiveUtils.padding(context, ResponsiveSpacing.sm),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            color: CupertinoColors.white,
            child: Column(
              children: [
                Container(
                  height: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.lg,
                  ),
                  decoration: BoxDecoration(
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
                        padding: ResponsiveUtils.padding(
                          context,
                          ResponsiveSpacing.sm,
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: AppColors.mutedGreen,
                            fontSize: ResponsiveUtils.fontSize(
                              context,
                              ResponsiveFontSize.md,
                            ),
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      CupertinoButton(
                        padding: ResponsiveUtils.padding(
                          context,
                          ResponsiveSpacing.sm,
                        ),
                        child: Text(
                          'Done',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.mutedGreen,
                            fontSize: ResponsiveUtils.fontSize(
                              context,
                              ResponsiveFontSize.md,
                            ),
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
                                  style: TextStyle(
                                    color: AppColors.button,
                                    fontSize: ResponsiveUtils.fontSize(
                                      context,
                                      ResponsiveFontSize.md,
                                    ),
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
                ResponsiveSpacingWidget.vertical(ResponsiveSpacing.sm),
                Text(
                  '$feature is currently under development and will be available in a future update.',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.md,
                    ),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(
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
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ResponsiveSpacingWidget.vertical(ResponsiveSpacing.sm),
                Text(
                  'AI Cook',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.md,
                    ),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                ResponsiveSpacingWidget.vertical(ResponsiveSpacing.xs),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.md,
                    ),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                ResponsiveSpacingWidget.vertical(ResponsiveSpacing.xs),
                Text(
                  'Your AI-powered cooking companion for discovering delicious recipes and managing your kitchen.',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.md,
                    ),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(
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
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ResponsiveSpacingWidget.vertical(ResponsiveSpacing.sm),
                Text(
                  'Are you sure you want to sign out of your account?',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      ResponsiveFontSize.md,
                    ),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(
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
                child: Text(
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
