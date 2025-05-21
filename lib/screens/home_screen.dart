import 'package:ai_cook_project/theme.dart';
import 'package:flutter/material.dart';

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
    // Implement AI button action here
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _pages[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: _onAiButtonPressed,
        backgroundColor: AppColors.orange,
        shape: const CircleBorder(),
        child: const Text('ai', style: TextStyle(fontSize: 18)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: AppColors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTabItem(
                icon: Icons.list_alt,
                label: 'Ingredients',
                index: 0,
              ),
              _buildTabItem(
                icon: Icons.restaurant_menu,
                label: 'Recipes',
                index: 1,
              ),
              const SizedBox(width: 48), // espacio para el botón central
              _buildTabItem(
                icon: Icons.calendar_month,
                label: 'Calendar',
                index: 2,
              ),
              _buildTabItem(icon: Icons.settings, label: 'Settings', index: 3),
            ],
          ),
        ),
      ),
      appBar: AppBar(title: const Text('Home'), centerTitle: true),
    );
  }

  Widget _buildTabItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isActive = _currentIndex == index;
    return InkWell(
      onTap: () => _onTabTapped(index),
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isActive ? AppColors.orange : AppColors.black),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.orange : AppColors.black,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
