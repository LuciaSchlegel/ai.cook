//main_screen.dart
import 'package:ai_cook_project/providers/auth_provider.dart';
import 'package:ai_cook_project/screens/calendar_screen.dart';
import 'package:ai_cook_project/screens/home_screen.dart';
import 'package:ai_cook_project/screens/ingredients_screen.dart';
import 'package:ai_cook_project/screens/recipes_screen.dart';
import 'package:ai_cook_project/screens/settings_screen.dart';
import 'package:ai_cook_project/screens/profile_screen.dart';
import 'package:ai_cook_project/screens/first_screen.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/widgets/search_bar.dart';
import 'package:ai_cook_project/widgets/main_floating_button.dart';
import 'package:ai_cook_project/widgets/ai_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = -1; // -1 represents home screen
  final TextEditingController _searchController = TextEditingController();
  bool _isMenuOpen = false;

  final List<_PageData> _pages = [
    _PageData(
      title: 'Ingredients',
      icon: 'assets/icons/recipe.svg',
      widget: const IngredientsScreen(),
    ),
    _PageData(
      title: 'Recipes',
      icon: 'assets/icons/chef.svg',
      widget: const RecipesScreen(),
    ),
    _PageData(
      title: 'Calendar',
      icon: 'assets/icons/calendar.svg',
      widget: const CalendarScreen(),
    ),
    _PageData(
      title: 'Settings',
      icon: 'assets/icons/settings.svg',
      widget: const SettingsScreen(),
    ),
  ];

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  void _onProfileTap() {
    // Navigate to profile screen
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const ProfileScreen()));
  }

  void _onFeedTap() {
    setState(() => _currentIndex = -1);
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _getCurrentScreen() {
    if (_currentIndex == -1) {
      return const HomeScreen();
    }
    return _pages[_currentIndex].widget;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            Column(
              children: [
                SafeArea(
                  bottom: false,
                  child: Container(
                    color: AppColors.background,
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 12,
                      bottom: 12,
                    ),
                    child: CustomSearchBar(
                      controller: _searchController,
                      hintText: 'Search...',
                      onChanged: (value) {},
                      isMenuOpen: _isMenuOpen,
                    ),
                  ),
                ),
                Expanded(child: _getCurrentScreen()),
              ],
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              right: 20,
              child: MainFloatingButton(
                key: const ValueKey('main_floating_button'),
                onProfileTap: () {
                  _onProfileTap();
                  setState(() {});
                },
                onFeedTap: () {
                  _onFeedTap();
                  setState(() {});
                },
                onLogoutTap: () {
                  _onLogoutTap();
                  setState(() {});
                },
                currentIndex: _currentIndex,
                onMenuStateChanged: (isOpen) {
                  setState(() => _isMenuOpen = isOpen);
                },
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
          shape: const CircularNotchedRectangle(),
          child: SizedBox(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // First two items
                ...List.generate(
                  2,
                  (index) => Expanded(
                    child: _buildTabItem(
                      assetPath: _pages[index].icon,
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
                      assetPath: _pages[index + 2].icon,
                      label: _pages[index + 2].title,
                      index: index + 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(top: -30, child: const AiButton()),
      ],
    );
  }

  Widget _buildTabItem({
    required String assetPath,
    required String label,
    required int index,
  }) {
    final isActive = _currentIndex == index;
    final color = isActive ? AppColors.orange : AppColors.black;

    return InkWell(
      onTap: () => _onTabTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            assetPath,
            height: 24,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
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

class _PageData {
  final String title;
  final String icon;
  final Widget widget;

  const _PageData({
    required this.title,
    required this.icon,
    required this.widget,
  });
}
