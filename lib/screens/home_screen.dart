import 'package:ai_cook_project/providers/auth_provider.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Center(
      child: Text('Ingredients', style: TextStyle(color: AppColors.white)),
    ),
    const Center(
      child: Text('Recipes', style: TextStyle(color: AppColors.white)),
    ),
    const Center(
      child: Text('Calendar', style: TextStyle(color: AppColors.white)),
    ),
    const Center(
      child: Text('Settings', style: TextStyle(color: AppColors.white)),
    ),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onAiButtonPressed() {
    showDialog(
      context: context,
      builder:
          (context) => const AlertDialog(
            title: Text('AI Button Pressed'),
            content: Text('You pressed the AI button!'),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenPaddingBottom = MediaQuery.of(context).padding.bottom;
    final buttonSize = screenWidth < 400 ? 64.0 : 72.0;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Home'),
            centerTitle: true,
            backgroundColor: AppColors.background,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: AppColors.white),
                onPressed: () {
                  Provider.of<FBAuthProvider>(context, listen: false).signOut();
                },
              ),
            ],
          ),
          body: _pages[_currentIndex],
          bottomNavigationBar: BottomAppBar(
            color: AppColors.white,
            elevation: 8,
            child: SizedBox(
              height: 72,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTabItem(
                    assetPath: 'assets/icons/recipe.svg',
                    label: 'Ingredients',
                    index: 0,
                  ),
                  _buildTabItem(
                    assetPath: 'assets/icons/chef.svg',
                    label: 'Recipes',
                    index: 1,
                  ),
                  const SizedBox(width: 48), // Espacio central para AI
                  _buildTabItem(
                    assetPath: 'assets/icons/calendar.svg',
                    label: 'Calendar',
                    index: 2,
                  ),
                  _buildTabItem(
                    assetPath: 'assets/icons/settings.svg',
                    label: 'Settings',
                    index: 3,
                  ),
                ],
              ),
            ),
          ),
        ),
        // AI Button flotante y responsive
        Positioned(
          bottom: screenPaddingBottom + 24,
          left: screenWidth / 2 - (buttonSize / 2),
          child: SizedBox(
            height: buttonSize,
            width: buttonSize,
            child: FloatingActionButton(
              onPressed: _onAiButtonPressed,
              backgroundColor: AppColors.orange,
              elevation: 5,
              shape: const CircleBorder(),
              child: const Text(
                'ai',
                style: TextStyle(
                  fontFamily: 'Casta',
                  fontSize: 50,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ),
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
      child: SizedBox(
        width: 64,
        child: Column(
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
              style: TextStyle(color: color, fontSize: 12),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
