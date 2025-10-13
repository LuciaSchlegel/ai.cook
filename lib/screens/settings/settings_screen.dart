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
                padding: EdgeInsets.symmetric(
                  horizontal:
                      ResponsiveUtils.isIPad(context)
                          ? ResponsiveUtils.spacing(
                            context,
                            ResponsiveSpacing.xxl,
                          )
                          : ResponsiveUtils.spacing(
                            context,
                            ResponsiveSpacing.lg,
                          ),
                  vertical: ResponsiveUtils.spacing(
                    context,
                    ResponsiveSpacing.lg,
                  ),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth:
                        ResponsiveUtils.isIPad(context) ? 600 : double.infinity,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Main Title
                      _buildMainTitle(context),
                      ResponsiveSpacingWidget.vertical(ResponsiveSpacing.xl),

                      // Main Settings Card
                      _buildMainSettingsCard(context),

                      ResponsiveSpacingWidget.vertical(ResponsiveSpacing.xl),

                      // Logout Section (separate from main card)
                      _buildLogoutSection(context),

                      ResponsiveSpacingWidget.vertical(ResponsiveSpacing.xl),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: AppTextStyles.casta(
            fontSize:
                ResponsiveUtils.fontSize(context, ResponsiveFontSize.title2) *
                1.2,
            fontWeight: AppFontWeights.bold,
            color: AppColors.white,
            letterSpacing: -0.5,
          ),
        ),
        ResponsiveSpacingWidget.vertical(ResponsiveSpacing.xxs),
        Text(
          'Customize your cooking experience',
          style: AppTextStyles.inter(
            fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.lg),
            fontWeight: AppFontWeights.regular,
            color: AppColors.white,
            height: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildMainSettingsCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.xxxl),
        ),
        border: Border.all(
          color: AppColors.mutedGreen.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.mutedGreen.withValues(alpha: 0.05),
            blurRadius: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
            offset: const Offset(0, 16),
            spreadRadius: -8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // General Section
          _buildSectionInCard(context, 'General', Icons.settings_outlined, [
            _buildSettingsTile(
              context,
              title: 'Notifications',
              subtitle: 'Receive cooking reminders and updates',
              icon: Icons.notifications_outlined,
              trailing: _buildSwitch(
                _notificationsEnabled,
                (value) => setState(() => _notificationsEnabled = value),
              ),
              isFirst: true,
            ),
            _buildSettingsTile(
              context,
              title: 'Language',
              subtitle: 'Select your preferred language',
              icon: Icons.language_outlined,
              trailing: _buildDropdownTrailing(_selectedLanguage),
              onTap: () => _showLanguagePicker(),
            ),
            _buildSettingsTile(
              context,
              title: 'Units',
              subtitle: 'Measurement system preference',
              icon: Icons.straighten_outlined,
              trailing: _buildDropdownTrailing(_selectedUnits),
              onTap: () => _showUnitsPicker(),
              isLast: true,
            ),
          ], isFirst: true),

          // AI & Recipes Section
          _buildSectionInCard(
            context,
            'AI & Recipes',
            Icons.auto_awesome_outlined,
            [
              _buildSettingsTile(
                context,
                title: 'AI Recommendations',
                subtitle: 'Get personalized recipe suggestions',
                icon: Icons.psychology_outlined,
                trailing: _buildSwitch(
                  _aiRecommendationsEnabled,
                  (value) => setState(() => _aiRecommendationsEnabled = value),
                ),
                isFirst: true,
              ),
              _buildSettingsTile(
                context,
                title: 'Auto-save Recipes',
                subtitle: 'Automatically save recipes you view',
                icon: Icons.bookmark_outline,
                trailing: _buildSwitch(
                  _autoSaveRecipes,
                  (value) => setState(() => _autoSaveRecipes = value),
                ),
              ),
              _buildSettingsTile(
                context,
                title: 'Dietary Preferences',
                subtitle: 'Set allergies and dietary restrictions',
                icon: Icons.restaurant_menu_outlined,
                trailing: _buildChevron(),
                onTap: () => _showDietaryPreferences(),
              ),
              _buildSettingsTile(
                context,
                title: 'Cooking Skills',
                subtitle: 'Set your cooking experience level',
                icon: Icons.local_dining_outlined,
                trailing: _buildChevron(),
                onTap: () => _showCookingSkills(),
                isLast: true,
              ),
            ],
          ),

          // Account Section
          _buildSectionInCard(context, 'Account', Icons.person_outline, [
            _buildSettingsTile(
              context,
              title: 'Profile Settings',
              subtitle: 'Manage your profile information',
              icon: Icons.account_circle_outlined,
              trailing: _buildChevron(),
              onTap: () => _navigateToProfile(),
              isFirst: true,
            ),
            _buildSettingsTile(
              context,
              title: 'Privacy & Security',
              subtitle: 'Control your data and privacy settings',
              icon: Icons.security_outlined,
              trailing: _buildChevron(),
              onTap: () => _showPrivacySettings(),
            ),
            _buildSettingsTile(
              context,
              title: 'Data & Storage',
              subtitle: 'Manage app data and storage',
              icon: Icons.storage_outlined,
              trailing: _buildChevron(),
              onTap: () => _showDataSettings(),
              isLast: true,
            ),
          ]),

          // Support Section
          _buildSectionInCard(context, 'Support', Icons.help_outline, [
            _buildSettingsTile(
              context,
              title: 'Help & FAQ',
              subtitle: 'Get help and find answers',
              icon: Icons.quiz_outlined,
              trailing: _buildChevron(),
              onTap: () => _showHelp(),
              isFirst: true,
            ),
            _buildSettingsTile(
              context,
              title: 'Contact Support',
              subtitle: 'Get in touch with our team',
              icon: Icons.support_agent_outlined,
              trailing: _buildChevron(),
              onTap: () => _contactSupport(),
            ),
            _buildSettingsTile(
              context,
              title: 'About',
              subtitle: 'App version and information',
              icon: Icons.info_outline,
              trailing: _buildChevron(),
              onTap: () => _showAbout(),
              isLast: true,
            ),
          ], isLast: true),
        ],
      ),
    );
  }

  Widget _buildSectionInCard(
    BuildContext context,
    String title,
    IconData sectionIcon,
    List<Widget> children, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isFirst)
          SizedBox(
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.xl),
          )
        else
          ResponsiveSpacingWidget.vertical(ResponsiveSpacing.md),

        _buildSectionHeader(context, title, sectionIcon),
        ResponsiveSpacingWidget.vertical(ResponsiveSpacing.sm),

        // Settings items without individual cards
        Column(children: children),

        if (!isLast) ...[
          ResponsiveSpacingWidget.vertical(ResponsiveSpacing.lg),
          // Section divider
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.spacing(
                context,
                ResponsiveSpacing.lg,
              ),
            ),
            height: 1,
            color: AppColors.mutedGreen.withValues(alpha: 0.1),
          ),
        ] else
          SizedBox(
            height: ResponsiveUtils.spacing(context, ResponsiveSpacing.lg),
          ),
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.spacing(context, ResponsiveSpacing.lg),
        vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(
              ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
            ),
            decoration: BoxDecoration(
              color: AppColors.button.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.borderRadius(
                  context,
                  ResponsiveBorderRadius.sm,
                ),
              ),
            ),
            child: Icon(
              icon,
              size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.sm),
              color: AppColors.button,
            ),
          ),
          SizedBox(
            width: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
          ),
          Text(
            title,
            style: AppTextStyles.inter(
              fontSize: ResponsiveUtils.fontSize(
                context,
                ResponsiveFontSize.xl,
              ),
              fontWeight: AppFontWeights.regular,
              color: AppColors.button,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget trailing,
    VoidCallback? onTap,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        border:
            !isLast
                ? Border(
                  bottom: BorderSide(
                    color: AppColors.mutedGreen.withValues(alpha: 0.1),
                    width: 0.5,
                  ),
                )
                : null,
        borderRadius:
            isFirst && isLast
                ? BorderRadius.circular(
                  ResponsiveUtils.borderRadius(
                    context,
                    ResponsiveBorderRadius.xl,
                  ),
                )
                : isFirst
                ? BorderRadius.only(
                  topLeft: Radius.circular(
                    ResponsiveUtils.borderRadius(
                      context,
                      ResponsiveBorderRadius.xl,
                    ),
                  ),
                  topRight: Radius.circular(
                    ResponsiveUtils.borderRadius(
                      context,
                      ResponsiveBorderRadius.xl,
                    ),
                  ),
                )
                : isLast
                ? BorderRadius.only(
                  bottomLeft: Radius.circular(
                    ResponsiveUtils.borderRadius(
                      context,
                      ResponsiveBorderRadius.xl,
                    ),
                  ),
                  bottomRight: Radius.circular(
                    ResponsiveUtils.borderRadius(
                      context,
                      ResponsiveBorderRadius.xl,
                    ),
                  ),
                )
                : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.xl),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.spacing(
                context,
                ResponsiveSpacing.lg,
              ),
              vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
            ),
            child: Row(
              children: [
                _buildIconContainer(context, icon),
                SizedBox(
                  width: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.inter(
                          fontSize: ResponsiveUtils.fontSize(
                            context,
                            ResponsiveFontSize.md,
                          ),
                          fontWeight: AppFontWeights.regular,
                          color: AppColors.button,
                          height: 1.2,
                        ),
                      ),
                      if (subtitle.isNotEmpty) ...[
                        SizedBox(
                          height: ResponsiveUtils.spacing(
                            context,
                            ResponsiveSpacing.xs,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: AppTextStyles.inter(
                            fontSize: ResponsiveUtils.fontSize(
                              context,
                              ResponsiveFontSize.sm,
                            ),
                            fontWeight: AppFontWeights.medium,
                            color: AppColors.mutedGreen,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(
                  width: ResponsiveUtils.spacing(context, ResponsiveSpacing.sm),
                ),
                trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer(BuildContext context, IconData icon) {
    return Container(
      width: ResponsiveUtils.iconSize(context, ResponsiveIconSize.xl),
      height: ResponsiveUtils.iconSize(context, ResponsiveIconSize.xl),
      decoration: BoxDecoration(
        gradient: AppColors.gradientOrange,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.sm),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.orange.withValues(alpha: 0.3),
            blurRadius: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: AppColors.white,
        size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.md),
      ),
    );
  }

  Widget _buildSwitch(bool value, ValueChanged<bool> onChanged) {
    return Switch.adaptive(
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.orange,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildDropdownTrailing(String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: AppTextStyles.inter(
            fontSize: ResponsiveUtils.fontSize(context, ResponsiveFontSize.md),
            fontWeight: AppFontWeights.regular,
            color: AppColors.mutedGreen,
          ),
        ),
        SizedBox(width: ResponsiveUtils.spacing(context, ResponsiveSpacing.xs)),
        Icon(
          Icons.chevron_right,
          color: AppColors.mutedGreen.withValues(alpha: 0.6),
          size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.md),
        ),
      ],
    );
  }

  Widget _buildChevron() {
    return Icon(
      Icons.chevron_right,
      color: AppColors.mutedGreen.withValues(alpha: 0.6),
      size: ResponsiveUtils.iconSize(context, ResponsiveIconSize.md),
    );
  }

  Widget _buildLogoutSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.xxxl) *
              1.8,
        ),
        border: Border.all(color: Colors.red.withValues(alpha: 0.2), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showLogoutDialog(),
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.borderRadius(context, ResponsiveBorderRadius.xxxl) *
                1.8,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.spacing(
                context,
                ResponsiveSpacing.xl,
              ),
              vertical: ResponsiveUtils.spacing(context, ResponsiveSpacing.lg),
            ),
            child: Row(
              children: [
                Container(
                  width: ResponsiveUtils.iconSize(
                    context,
                    ResponsiveIconSize.xl,
                  ),
                  height: ResponsiveUtils.iconSize(
                    context,
                    ResponsiveIconSize.xl,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.borderRadius(
                        context,
                        ResponsiveBorderRadius.sm,
                      ),
                    ),
                  ),
                  child: Icon(
                    Icons.logout_outlined,
                    color: Colors.red,
                    size: ResponsiveUtils.iconSize(
                      context,
                      ResponsiveIconSize.md,
                    ),
                  ),
                ),
                SizedBox(
                  width: ResponsiveUtils.spacing(context, ResponsiveSpacing.md),
                ),
                Expanded(
                  child: Text(
                    'Sign Out',
                    style: AppTextStyles.inter(
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        ResponsiveFontSize.md,
                      ),
                      fontWeight: AppFontWeights.semiBold,
                      color: Colors.red,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.red.withValues(alpha: 0.6),
                  size: ResponsiveUtils.iconSize(
                    context,
                    ResponsiveIconSize.md,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Picker methods
  void _showLanguagePicker() {
    _showIOSPicker(
      'Language',
      ['English', 'Spanish', 'French', 'German', 'Italian'],
      _selectedLanguage,
      (value) => setState(() => _selectedLanguage = value!),
    );
  }

  void _showUnitsPicker() {
    _showIOSPicker(
      'Units',
      ['Metric', 'Imperial'],
      _selectedUnits,
      (value) => setState(() => _selectedUnits = value!),
    );
  }

  void _showIOSPicker(
    String title,
    List<String> options,
    String currentValue,
    ValueChanged<String?> onChanged,
  ) {
    final int initialItem = options.indexOf(currentValue);

    showCupertinoModalPopup<void>(
      context: context,
      builder:
          (BuildContext context) => Container(
            height: 300,
            padding: const EdgeInsets.only(top: 16),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            color: CupertinoColors.systemBackground.resolveFrom(context),
            child: Column(
              children: [
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: CupertinoColors.separator.resolveFrom(context),
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: AppColors.mutedGreen),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      CupertinoButton(
                        child: Text(
                          'Done',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.orange,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    magnification: 1.2,
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

  // Navigation and action methods (keeping your existing implementations)
  void _showDietaryPreferences() =>
      _showComingSoonDialog('Dietary Preferences');
  void _showCookingSkills() => _showComingSoonDialog('Cooking Skills');
  void _navigateToProfile() {
    if (widget.onProfileTap != null) {
      widget.onProfileTap!();
    } else {
      _showComingSoonDialog('Profile Settings');
    }
  }

  void _showPrivacySettings() => _showComingSoonDialog('Privacy & Security');
  void _showDataSettings() => _showComingSoonDialog('Data & Storage');
  void _showHelp() => _showComingSoonDialog('Help & FAQ');
  void _contactSupport() => _showComingSoonDialog('Contact Support');

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
                    fontSize: 18,
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
