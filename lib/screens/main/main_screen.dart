import 'package:ai_cook_project/dialogs/recipes/ai_recipes_dialog.dart';
import 'package:ai_cook_project/providers/ingredients_provider.dart';
import 'package:ai_cook_project/providers/resource_provider.dart';
import 'package:ai_cook_project/providers/user_provider.dart';
import 'package:ai_cook_project/screens/home/home_screen.dart';
import 'package:ai_cook_project/screens/main/services/initializer.dart';
import 'package:ai_cook_project/screens/main/widgets/bottom_app_bar.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:ai_cook_project/widgets/ai_agent/floating_chat_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_cook_project/screens/cupboard/cupboard_screen.dart';
import 'package:ai_cook_project/screens/recipes/recipes_screen.dart';
import 'package:ai_cook_project/screens/calendar/calendar_screen.dart';
import 'package:ai_cook_project/screens/settings/settings_screen.dart';
import 'package:ai_cook_project/screens/profile/profile_screen.dart';
import 'package:ai_cook_project/screens/auth/services/auth_services.dart';
import 'package:ai_cook_project/screens/first_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = -1; // home screen index
  // Main screen controls the state
  bool _isAiWindowOpen = false;

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final ingredientsProvider = Provider.of<IngredientsProvider>(
        context,
        listen: false,
      );
      final resourceProvider = Provider.of<ResourceProvider>(
        context,
        listen: false,
      );
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      Future(() async {
        await ingredientsProvider.initializeIngredients();
        await resourceProvider.initializeResources();
        await userProvider.getUser();

        if (!mounted) return;

        MainScreenInit.updateSearchScreen(
          context: context,
          currentIndex: _currentIndex,
        );
      });

      _initialized = true;
    }
  }

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
    MainScreenInit.updateSearchScreen(
      context: context,
      currentIndex: _currentIndex,
    );
  }

  // Dialog responds to state changes
  void _toggleAiWindow() {
    setState(() => _isAiWindowOpen = !_isAiWindowOpen);
  }

  // Navigation methods for floating button
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
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const FirstScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error logging out. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _currentIndex == -1
              ? HomeScreen(
                onProfileTap: _onProfileTap,
                onFeedTap: _onFeedTap,
                onLogoutTap: _onLogoutTap,
              )
              : _currentIndex == 0
              ? CupboardScreen(
                isActive: true,
                onProfileTap: _onProfileTap,
                onFeedTap: _onFeedTap,
                onLogoutTap: _onLogoutTap,
              )
              : _currentIndex == 1
              ? RecipesScreen(
                onProfileTap: _onProfileTap,
                onFeedTap: _onFeedTap,
                onLogoutTap: _onLogoutTap,
              )
              : _currentIndex == 2
              ? CalendarScreen(
                onProfileTap: _onProfileTap,
                onFeedTap: _onFeedTap,
                onLogoutTap: _onLogoutTap,
              )
              : _currentIndex == 3
              ? SettingsScreen(
                onProfileTap: _onProfileTap,
                onFeedTap: _onFeedTap,
                onLogoutTap: _onLogoutTap,
              )
              : const SizedBox(),
          if (_isAiWindowOpen && _currentIndex != 1)
            Positioned.fill(
              child: IgnorePointer(
                ignoring: !_isAiWindowOpen,
                child: FloatingChatWindow(
                  isOpen: _isAiWindowOpen,
                  onClose: _toggleAiWindow,
                ),
              ),
            ),
          if (_isAiWindowOpen && _currentIndex == 1)
            AiRecipesDialog(
              onToggle: _toggleAiWindow, // Dialog calls this to close
              isOpen: _isAiWindowOpen, // Dialog reacts to this state
            ), //aqui implementaremos la nueva vista de ai en recipes
        ],
      ),
      bottomNavigationBar: NavBarBuilder(
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
        toggleAiWindow: _toggleAiWindow,
        isAiWindowOpen: _isAiWindowOpen,
      ),
    );
  }
}
