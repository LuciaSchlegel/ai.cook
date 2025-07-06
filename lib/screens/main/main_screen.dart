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

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = -1; // home screen index
  bool _isAiWindowOpen = false;

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final ingredientsProvider = Provider.of<IngredientsProvider>(context, listen: false);
      final resourceProvider = Provider.of<ResourceProvider>(context, listen: false);
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

  void _toggleAiWindow() {
    setState(() => _isAiWindowOpen = !_isAiWindowOpen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _currentIndex == -1
              ? const HomeScreen()
              : _currentIndex == 0
                  ? CupboardScreen(isActive: true)
                  : _currentIndex == 1
                      ? const RecipesScreen()
                      : _currentIndex == 2
                          ? const CalendarScreen()
                          : _currentIndex == 3
                              ? const SettingsScreen()
                              : const SizedBox(),
          if (_isAiWindowOpen)
            Positioned.fill(
              child: IgnorePointer(
                ignoring: !_isAiWindowOpen,
                child: FloatingChatWindow(
                  isOpen: _isAiWindowOpen,
                  onClose: _toggleAiWindow,
                ),
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
    );
  }
}