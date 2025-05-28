//main_screen.dart
import 'package:ai_cook_project/providers/auth_provider.dart';
import 'package:ai_cook_project/screens/calendar_screen.dart';
import 'package:ai_cook_project/screens/home_screen.dart';
import 'package:ai_cook_project/screens/cupboard_screen.dart';
import 'package:ai_cook_project/screens/recipes_screen.dart';
import 'package:ai_cook_project/screens/settings_screen.dart';
import 'package:ai_cook_project/screens/profile_screen.dart';
import 'package:ai_cook_project/screens/first_screen.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/widgets/search_bar.dart';
import 'package:ai_cook_project/widgets/main_floating_button.dart';
import 'package:ai_cook_project/widgets/ai_button.dart';
import 'package:ai_cook_project/widgets/floating_chat_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_cook_project/providers/search_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _IconProperties {
  final IconData icon;
  final double size;
  final double? activeSize;
  final Color? activeColor;
  final Color? inactiveColor;
  final double? activeShadowRadius;
  final Color? activeShadowColor;

  const _IconProperties({
    required this.icon,
    this.size = 24,
    this.activeSize,
    this.activeColor,
    this.inactiveColor,
    this.activeShadowRadius,
    this.activeShadowColor,
  });
}

class _PageData {
  final String title;
  final _IconProperties icon;
  final Widget widget;

  const _PageData({
    required this.title,
    required this.icon,
    required this.widget,
  });
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = -1; // -1 represents home screen
  bool _isAiWindowOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSearchScreen();
    });
  }

  void _updateSearchScreen() {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    if (_currentIndex == -1) {
      searchProvider.setCurrentScreen('home');
    } else if (_currentIndex == 0) {
      searchProvider.setCurrentScreen('cupboard');
    } else if (_currentIndex == 1) {
      searchProvider.setCurrentScreen('recipes');
    }
  }

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
    _updateSearchScreen();
  }

  void _onProfileTap() {
    // Navigate to profile screen
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const ProfileScreen()));
  }

  void _onFeedTap() {
    setState(() => _currentIndex = -1);
    _updateSearchScreen();
  }

  void _onLogoutTap() async {
    try {
      await Provider.of<FBAuthProvider>(context, listen: false).signOut();
      if (mounted) {
        // Navigate to FirstScreen after logout
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const FirstScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error logging out. Please try again.')),
        );
      }
    }
  }

  void _toggleAiWindow() {
    setState(() => _isAiWindowOpen = !_isAiWindowOpen);
  }

  final List<_PageData> _pages = [
    _PageData(
      title: 'Cupboard',
      icon: _IconProperties(
        icon: Icons.kitchen_rounded,
        size: 24,
        activeSize: 25,
        activeColor: AppColors.orange,
        inactiveColor: const Color.fromARGB(255, 123, 123, 123),
        activeShadowRadius: 8,
        activeShadowColor: AppColors.orange.withOpacity(0.1),
      ),
      widget: const CupboardScreen(),
    ),
    _PageData(
      title: 'Recipes',
      icon: _IconProperties(
        icon: Icons.restaurant_menu_rounded,
        size: 24,
        activeSize: 25,
        activeColor: AppColors.orange,
        inactiveColor: const Color.fromARGB(255, 123, 123, 123),
        activeShadowRadius: 8,
        activeShadowColor: AppColors.orange.withOpacity(0.1),
      ),
      widget: const RecipesScreen(),
    ),
    _PageData(
      title: 'Calendar',
      icon: _IconProperties(
        icon: Icons.calendar_month_rounded,
        size: 24,
        activeSize: 25,
        activeColor: AppColors.orange,
        inactiveColor: const Color.fromARGB(255, 123, 123, 123),
        activeShadowRadius: 8,
        activeShadowColor: AppColors.orange.withOpacity(0.1),
      ),
      widget: const CalendarScreen(),
    ),
    _PageData(
      title: 'Settings',
      icon: _IconProperties(
        icon: Icons.settings_rounded,
        size: 24,
        activeSize: 25,
        activeColor: AppColors.orange,
        inactiveColor: const Color.fromARGB(255, 123, 123, 123),
        activeShadowRadius: 8,
        activeShadowColor: AppColors.orange.withOpacity(0.1),
      ),
      widget: const SettingsScreen(),
    ),
  ];

  Widget _getCurrentScreen() {
    if (_currentIndex == -1) {
      return const HomeScreen();
    }
    return _pages[_currentIndex].widget;
  }

  @override
  Widget build(BuildContext context) {
    bool isHomeScreen = _currentIndex == -1;
    bool isCupboardScreen = _currentIndex == 0;
    bool isRecipesScreen = _currentIndex == 1;
    final searchProvider = Provider.of<SearchProvider>(context);

    return Material(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              children: [
                // Top safe area with search bar
                SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ), // Add top spacing
                      if (isHomeScreen || isCupboardScreen || isRecipesScreen)
                        Container(
                          color: AppColors.background,
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.05,
                          ),
                          child: CustomSearchBar(
                            controller: searchProvider.searchController,
                            hintText: searchProvider.getSearchHint(),
                            onChanged: searchProvider.onSearch,
                            isMenuOpen: searchProvider.isMenuOpen,
                          ),
                        ),
                      // Add consistent top padding for non-home screens
                      if (_currentIndex != -1)
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                    ],
                  ),
                ),
                // Main content
                Expanded(child: _getCurrentScreen()),
              ],
            ),
            // Floating button positioned relative to safe area
            Positioned(
              top:
                  MediaQuery.of(context).padding.top +
                  MediaQuery.of(context).size.height *
                      0.02, // Match search bar spacing
              right: MediaQuery.of(context).size.width * 0.05,
              child: MainFloatingButton(
                key: const ValueKey('main_floating_button'),
                onProfileTap: _onProfileTap,
                onFeedTap: _onFeedTap,
                onLogoutTap: _onLogoutTap,
                currentIndex: _currentIndex,
                onMenuStateChanged: (isOpen) {
                  searchProvider.setMenuOpen(isOpen);
                },
              ),
            ),
            if (_isAiWindowOpen)
              Positioned.fill(
                child: FloatingChatWindow(
                  isOpen: _isAiWindowOpen,
                  onClose: _toggleAiWindow,
                ),
              ),
          ],
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        BottomAppBar(
          color: AppColors.white,
          elevation: 8,
          notchMargin: 8,
          padding: EdgeInsets.zero,
          height: 40 + MediaQuery.of(context).padding.bottom,
          shape: const CircularNotchedRectangle(),
          child: SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // First two items
                ...List.generate(
                  2,
                  (index) => Expanded(
                    child: _buildTabItem(
                      icon: _pages[index].icon,
                      label: _pages[index].title,
                      index: index,
                    ),
                  ),
                ),
                // Empty space for FAB
                const Expanded(child: SizedBox()),
                // Last two items
                ...List.generate(
                  2,
                  (index) => Expanded(
                    child: _buildTabItem(
                      icon: _pages[index + 2].icon,
                      label: _pages[index + 2].title,
                      index: index + 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -30,
          child: Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: AiButton(
              onPressed: _toggleAiWindow,
              isActive: _isAiWindowOpen,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabItem({
    required _IconProperties icon,
    required String label,
    required int index,
  }) {
    final isActive = _currentIndex == index;
    final color =
        isActive ? AppColors.orange : const Color.fromARGB(255, 123, 123, 123);
    final iconSize = isActive ? (icon.activeSize ?? icon.size) : icon.size;
    final iconColor =
        isActive ? (icon.activeColor ?? color) : (icon.inactiveColor ?? color);

    return InkWell(
      onTap: () => _onTabTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration:
                isActive && icon.activeShadowRadius != null
                    ? BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                              icon.activeShadowColor ??
                              iconColor.withOpacity(0.3),
                          blurRadius: icon.activeShadowRadius!,
                          spreadRadius: 0,
                        ),
                      ],
                    )
                    : null,
            child: Icon(icon.icon, size: iconSize, color: iconColor),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
