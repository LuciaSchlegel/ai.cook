import 'package:ai_cook_project/screens/auth/services/auth_services.dart';
import 'package:ai_cook_project/screens/home/home_screen.dart';
import 'package:ai_cook_project/screens/main/helpers/tabs.dart';
import 'package:ai_cook_project/screens/main/services/initializer.dart';
import 'package:ai_cook_project/screens/main/widgets/bottom_app_bar.dart';
import 'package:ai_cook_project/screens/profile/profile_screen.dart';
import 'package:ai_cook_project/screens/first_screen.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/widgets/search_bar.dart';
import 'package:ai_cook_project/widgets/main_floating_button.dart';
import 'package:ai_cook_project/widgets/floating_chat_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_cook_project/providers/search_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = -1; // home screen index
  bool _isAiWindowOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await MainScreenInit.initializeData(context: context);
      MainScreenInit.updateSearchScreen(
        context: context,
        currentIndex: _currentIndex,
      );
      if (!mounted) return;
    });
  }

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
    MainScreenInit.updateSearchScreen(
      context: context,
      currentIndex: _currentIndex,
    );
  }

  void _onProfileTap() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const ProfileScreen()));
  }

  void _onFeedTap() {
    setState(() => _currentIndex = -1);
    MainScreenInit.updateSearchScreen(
      context: context,
      currentIndex: _currentIndex,
    );
  }

  void _onLogoutTap() async {
    try {
      await AuthService.logout(context: context);
      if (mounted) {
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

  Widget _getCurrentScreen() {
    if (_currentIndex == -1) {
      return const HomeScreen();
    }
    return pages[_currentIndex].widget;
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
                SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
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
                      if (_currentIndex != -1)
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                    ],
                  ),
                ),
                Expanded(child: _getCurrentScreen()),
              ],
            ),
            Positioned(
              top:
                  MediaQuery.of(context).padding.top +
                  MediaQuery.of(context).size.height * 0.02,
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
        bottomNavigationBar: NavBarBuilder(
          currentIndex: _currentIndex,
          onTabTapped: _onTabTapped,
          toggleAiWindow: _toggleAiWindow,
          isAiWindowOpen: _isAiWindowOpen,
        ),
      ),
    );
  }
}
